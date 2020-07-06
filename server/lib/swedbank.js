import { cnst, wrangle } from  './wrangler.js';
import { v4 as uuid } from 'uuid';
import axios from 'axios';
import qs from 'querystring'
import moment from 'moment'

const DateFormat = "ddd, DD MMM YYYY HH:mm:ssz"
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

async function getConsent(req) {
    try {
        //https://developer.swedbank.com/dev/apis/details/6cc65715-9803-4356-98af-708011b7dc7b/spec#/consent/putConsent
        let url = 'https://psd2.api.swedbank.com:443/sandbox/v3/consents/?' + qs.encode({
            bic: "SANDSESS",
            'app-id': client_id,
        })
        let headers = { 
            Date: moment().format(DateFormat) + 'GMT',
            Authorization: 'Bearer ' + req.query.token,
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
            Authorization: 'Bearer ' + req.query.token,
            'X-Request-ID': uuid(),
            'Consent-ID': consent.consentId,
            accept: 'application/json', 
            'PSU-IP-Address': req.headers['x-forwarded-for'] || req.connection.remoteAddress,
        }
        const response = await axios.get(url, {headers: headers});
        var {accounts} = response.data
        accounts = accounts.map((acc) => 
            wrangle(acc, swedbankAccountFilter)
        )
        return accounts
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
        get: getAccounts
    }
}