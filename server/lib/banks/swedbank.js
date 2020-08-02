import { cnst, wrangle, join, map } from  '../wrangler.js';
import { v4 as uuid } from 'uuid';
import axios from 'axios';
import qs from 'querystring'
import moment from 'moment'

const DateFormat = "ddd, DD MMM YYYY HH:mm:ssz"
const DateFormatTransactions = "ddd, DD MMM YYYY"
const client_id = 'l711da77f864d94e9997abeeb6879f9f31'
const client_secret = '4c4e430bf39e4252b0ba4d30e15b9e47'
//https://bankon.leddy231.se/auth?bank=swedbank&code=8d3bb423-d5ba-4f16-8586-fecd3f3f1dad

const swedbankAccountFilter = {
    "bank": cnst("swedbank"),
    "account_id": "resourceId",
    "account_numbers": [
        {
            "type": cnst("IBAN"),
            "number": "iban"
        },
        {
            "type": cnst("BBAN"),
            "number": "bban"
        },
    ],
    "account_currency": "currency",
    "account_balance": cnst("0"),
    "account_type": "product",
}

const swedbankTransactionsFilter = {
    'transactions': join([
        map('transactions.pending', {
            'amount': 'transactionAmount.amount',
            'currency': 'transactionAmount.currency',
            'date': 'valueDate',
            'pending': cnst(true)
        }),
        map('transactions.booked', {
            'amount': 'transactionAmount.amount',
            'currency': 'transactionAmount.currency',
            'date': 'valueDate',
            'pending': cnst(false)
        })
    ])
}

async function getConsent(req) {
    try {
        //https://developer.swedbank.com/dev/apis/details/6cc65715-9803-4356-98af-708011b7dc7b/spec#/consent/putConsent
        let url = 'https://psd2.api.swedbank.com:443/sandbox/v3/consents/?' + qs.encode({
            bic: "SANDSESS",
            'app-id': client_id,
        })
        let headers = { 
            Date: moment().format(DateFormat) + 'GMT',
            Authorization: 'Bearer ' + req.token,
            'X-Request-ID': uuid(),
            'PSU-IP-Address': req.headers['x-forwarded-for'] || req.connection.remoteAddress,
            'PSU-User-Agent': 'axios/0.19.2',
            'TPP-Redirect-Preferred': false,
            'TPP-Redirect-URI': 'https://bankon.leddy231.se/auth?bank=swedbank',
            'TPP-Explicit-Authorisation-Preferred': false,
            'Content-Type': 'application/json'
        }
        let data = {
            "access": {
                "accounts": [
                {
                    "iban": "string"
                }
                ],
                "availableAccounts": "allAccounts",
                "balances": [
                {
                    "iban": "string"
                }
                ],
                "transactions": [
                {
                    "iban": "string"
                }
                ]
            },
            "combinedServiceIndicator": true,
            "frequencyPerDay": 4,
            "recurringIndicator": false,
            "validUntil": "2020-08-31"
        }
        const response = await axios.post(url, data, {headers: headers});
        return response.data
    } catch (error) {
        console.log(error)
        console.log(error.response.data)
    }
}

async function getDetailedConsent(req, accounts) {
    try {
        //https://developer.swedbank.com/dev/apis/details/6cc65715-9803-4356-98af-708011b7dc7b/spec#/consent/putConsent
        let url = 'https://psd2.api.swedbank.com:443/sandbox/v3/consents/?' + qs.encode({
            bic: "SANDSESS",
            'app-id': client_id,
        })
        let headers = { 
            Date: moment().format(DateFormat) + 'GMT',
            Authorization: 'Bearer ' + req.token,
            'X-Request-ID': uuid(),
            'PSU-IP-Address': req.headers['x-forwarded-for'] || req.connection.remoteAddress,
            'PSU-User-Agent': 'axios/0.19.2',
            'TPP-Redirect-Preferred': true,
            'TPP-Redirect-URI': 'https://bankon.leddy231.se/validconsent?bank=swedbank&user=' + req.user.user_id,
            'Content-Type': 'application/json'
        }
        let ibanlist = accounts.map((acc) => {
            return {iban: acc.account_numbers[0].number}
        })
        let data = {
            "access": {
                "accounts": ibanlist,
                "balances": ibanlist,
                "transactions": ibanlist
            },
            "combinedServiceIndicator": true,
            "frequencyPerDay": 4,
            "recurringIndicator": true,
            "validUntil": "2020-08-31"
        }
        const response = await axios.post(url, data, {headers: headers});
        req.user.data.collection('banks').doc('swedbank').update({consentId: response.data.consentId})
        return {url: response.data['_links'].scaRedirect.href}
    } catch (error) {
        console.log(error)
        console.log(error.response.data)
    }
}

async function parseAuthCode(req) {
    try {
        let url = 'https://se.psd2.api.swedbank.com:443/psd2/token';
        let data = { 
            client_id: client_id,
            client_secret: client_secret,
            grant_type: "authorization_code",
            redirect_uri: 'https://bankon.leddy231.se/auth?bank=swedbank',
            code: req.query.code,
        }

        let headers = { 
            accept: 'application/json', 
            'content-type': 'application/x-www-form-urlencoded'
        }
        const response = await axios.post(url, qs.stringify(data), {headers: headers});

        return response.data
    } catch (error) {
        console.log(error)
    }
}

async function getAccounts(req) {
    try {
        //https://developer.swedbank.com/dev/apis/details/7ae2ca0f-c1f6-4e58-a9e6-e9b2d51d07e8/spec#/accounts/getAccounts
        let consent = await getConsent(req);
        let url = "https://psd2.api.swedbank.com:443/sandbox/v3/accounts?" + qs.encode({
            bic: "SANDSESS",
            'app-id': client_id,
            withBalance: true
        })
        let headers = {
            Date: moment().format(DateFormat) + ' GMT',
            Authorization: 'Bearer ' + req.token,
            'X-Request-ID': uuid(),
            'Consent-ID': consent.consentId,
            accept: 'application/json', 
            'PSU-IP-Address': req.headers['x-forwarded-for'] || req.connection.remoteAddress,
        }
        const response = await axios.get(url, {headers: headers});
        var {accounts} = response.data
        console.log(accounts)
        accounts = accounts.map((acc) => 
            wrangle(acc, swedbankAccountFilter)
        )
        return accounts
    } catch (error) {
        console.log(error)
        console.log(error.response.data)
    }
}

async function validconsent(req, userdata) {
    await userdata.collection('banks').doc(req.bank.name).update({consent: true})
    let bankdata = await userdata.collection('banks').doc(req.bank.name).get();
    let consentId = bankdata.data().consentId
    const snapshot = await userdata.collection('accounts').get()
    snapshot.forEach((doc) => {
        let account = doc.data();
        if(account.bank == req.bank.name) {
            getAccountBalance(req, account.account_id, consentId)
        }
    });
}

async function getAccountDetails(req) {
    try {
        let bankdata = await req.user.data.collection('banks').doc(req.bank.name).get();
        let consentId = bankdata.data().consentId
        const snapshot = await req.user.data.collection('accounts').get()
        snapshot.forEach((doc) => {
            let account = doc.data();
            if(account.bank == req.bank.name) {
                //https://developer.swedbank.com/dev/apis/details/7ae2ca0f-c1f6-4e58-a9e6-e9b2d51d07e8/spec#/accounts/getAccounts
                let url = "https://psd2.api.swedbank.com:443/sandbox/v3/accounts/"+account.account_id+"/balances?" + qs.encode({
                    bic: "SANDSESS",
                    'app-id': client_id,
                })
                let headers = {
                    Date: moment().format(DateFormat) + ' GMT',
                    Authorization: 'Bearer ' + req.token,
                    'X-Request-ID': uuid(),
                    'Consent-ID': consentId,
                    accept: 'application/json', 
                    'PSU-IP-Address': req.headers['x-forwarded-for'] || req.connection.remoteAddress,
                }
                /*
                axios.get(url, {headers: headers}).then((res) => {
                    let balance = res.data.balances[0].balanceAmount.amount
                    req.user.data.collection('accounts').doc(account.account_id).update({'account_balance': balance})
                })
                */
                let urlTransactions = "https://psd2.api.swedbank.com:443/sandbox/v3/accounts/"+account.account_id+"/transactions?" + qs.encode({
                    bic: "SANDSESS",
                    'app-id': client_id,
                    dateFrom: moment().subtract(20, 'days').format('YYYY-MM-DD'),
                    dateTo: moment().format('YYYY-MM-DD'),
                    bookingStatus: 'both',
                })
                axios.get(urlTransactions, {headers: headers}).then((res) => {
                    let data = wrangle(res.data, swedbankTransactionsFilter)
                    console.log(data)
                    req.user.data.collection('accounts').doc(account.account_id).update(data)
                }).catch((error) => {
                    if(error.response != null) {
                        console.log(error.response.data)
                    } else {
                        console.log(error)
                    }
                    
                    
                })

            }
        });
        
    } catch (error) {
        console.log(error)
        console.log(error.response.data)
    }
}

const auth = {
    redirect: {
        url: 'https://se.psd2.api.swedbank.com:443/psd2/authorize?' + qs.encode({
            bic: 'SANDSESS',
            client_id: client_id,
            response_type: 'code',
            scope: 'PSD2sandbox',
            redirect_uri: 'https://bankon.leddy231.se/auth?bank=swedbank',
        }),
        parse: parseAuthCode
    }
}

export default {
    name: 'swedbank',
    auth: auth,
    accounts: {
        get: getAccounts,
        consent: getDetailedConsent,
        details: getAccountDetails
    }
}