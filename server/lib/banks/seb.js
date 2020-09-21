
import { cnst, wrangle } from  '../wrangler.js';
import { v4 as uuid } from 'uuid';
import axios from 'axios';
import qs from 'querystring'

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

const client_id = 'SEB_CLIENTID'
const client_secret = 'SEB_SECRET'

const sebAccountFilter = {
    "bank": cnst("seb"),
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
    "account_balance": cnst("0"),//"creditLine",
    "account_type": "product",
}

async function decoupledAuth() {
    
    try {
        //https://developer.sebgroup.com/node/4347
        let url = 'https://api-sandbox.sebgroup.com/auth/bid/v2/authentications';
        const response = await axios.post(url, {}, {withCredentials: true});
        let token = response["auto_start_token"];
        let bankidurl = `bankid:///?autostarttoken=${token}`
        console.log(bankidurl);
        var status = (await axios.get(url), {withCredentials: true}).status
        while(status == 'PENDING') {
            await sleep(2000);
            var status = (await axios.get(url), {withCredentials: true}).status
        }
        if(status == 'FAILED') {
            throw("Failed auth")
        }
        console.log("yay")
    } catch (error) {
        console.log(error)
    }
}

async function getAccounts(req) {
    try {
        //https://developer.sebgroup.com/node/4998
        let url = "https://api-sandbox.sebgroup.com/ais/v6/identified2/accounts";
        let headers = { 
            accept: 'application/json', 
            'X-Request-ID': uuid(),
            'PSU-IP-Address': req.headers['x-forwarded-for'] || req.connection.remoteAddress,
            'Authorization': 'Bearer ' + req.query.accesstoken
        }
        const response = await axios.get(url, {headers: headers});
        var {accounts} = response.data
        console.log(accounts)
        accounts = accounts.map((acc) => 
            wrangle(acc, sebAccountFilter)
        )
        return accounts
    } catch (error) {
        console.log(error)
    }
}

async function parseAuthCode(req) {
    try {
        //https://developer.sebgroup.com/node/1655
        let url = 'https://api-sandbox.sebgroup.com/mga/sps/oauth/oauth20/token';
        let data = { 
            client_id: client_id,
            client_secret: client_secret,
            code: req.query.code,
            redirect_uri: 'https://thebankonproject.se/auth?bank=seb',
            grant_type: "authorization_code"
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

const auth = {
    redirect: {
        url: 'https://api-sandbox.sebgroup.com/mga/sps/oauth/oauth20/authorize?' + qs.encode({
            client_id: client_id,
            scope: "psd2_accounts psd2_payments",
            redirect_uri: "https://thebankonproject.se/auth?bank=seb",
            response_type: "code"
        }),
        parse: parseAuthCode
    }
}

export default {
    name: 'seb',
    auth: auth,
    accounts: {
        get: getAccounts
    }

}
