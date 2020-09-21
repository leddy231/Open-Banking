import  {cnst, map, filter} from  '../wrangler.js';
import { v4 as uuid } from 'uuid';
import axios from 'axios';
import qs from 'querystring'
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

const client_id = 'NORDEA_CLIENTID'
const client_secret = 'NORDEA_SECRET'

const nordeaAccountFilter = {
    "bank": cnst("nordea"),
    "account_id": "_id",
    "account_numbers": map("account_numbers",{
        "type": filter("_type", (value) => value.split("_")[0] ),
        "number": "value"
    }),
    "account_currency": "currency",
    "account_owner": "account_name",
    "account_balance": "available_balance",
    "account_type": "product",
    "account_status": "status",
    "account_bic": "bank.bic"
}

const auth = {
    redirect: {
        url: '' + qs.encode({
            client_id: client_id,
            client_secret: client_secret,
            redirect_uri: 'https://thebankonproject.se/auth?bank=nordea',
            scope: 'ACCOUNTS_BASIC,ACCOUNTS_BALANCES, ACCOUNTS_DETAILS,ACCOUNTS_TRANSACTIONS',
            country: 'SE',
            duration: 129600

        })
    }
}

export default {
    name: 'nordea',
    auth: auth,
    accounts: {
        get: () => []
    }
}