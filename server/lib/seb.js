
import { cnst } from  './wrangler.js';
import axios from 'axios';

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

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

async function auth() {
    
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

export default {
    'name': 'seb',
    'accountFilter': sebAccountFilter,
    'auth': auth
}
