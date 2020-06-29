
import { cnst } from  './wrangler.js';
import axios from 'axios';
import qs from 'querystring'

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

const client_id = 'N48Hmiaxd7Jdm88CL37c'
const client_secret = 'mT9Bki2coWwUeugyIqDX'

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
    "account_owner": "ownerName",
    "account_balance": "creditLine",
    "account_type": "product",
    "account_status": "status",
    "account_bic": "bic",
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

async function parseAuthCode(code) {
    try {
        //https://developer.sebgroup.com/node/1655
        let url = 'https://api-sandbox.sebgroup.com/mga/sps/oauth/oauth20/token';
        let data = { 
            client_id: client_id,
            client_secret: client_secret,
            code: code,
            redirect_uri: 'https://bankon.leddy231.se/auth?bank=seb',
            grant_type: "authorization_code"
        }

        let headers = { 
            accept: 'application/json', 
            'content-type': 'application/x-www-form-urlencoded'
        }
        const response = await axios.post(url, qs.stringify(data), {headers: headers});

        return response
    } catch (error) {
        console.log(error)
    }
}

const auth = {
    redirectUrl: `https://api-sandbox.sebgroup.com/mga/sps/oauth/oauth20/authorize?client_id=${client_id}&scope=psd2_accounts psd2_payments&redirect_uri=${encodeURIComponent("https://bankon.leddy231.se/auth?bank=seb")}&response_type=code`,
    onRedirect: parseAuthCode
}

export default {
    'name': 'seb',
    'accountFilter': sebAccountFilter,
    'auth': auth,

}
