import  {cnst, map, filter} from  '../wrangler.js';
import { v4 as uuid } from 'uuid';
import axios from 'axios';
import qs from 'querystring'
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

const client_id = 'a3685f8f-708e-4375-b769-4f9ed618f1f8'
const client_secret = 'rT0bJ0wY0oR3xG7gQ0qU8iF4uM7dC8lS6mQ7oD7iY8jL7mD0sT'

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
            redirect_uri: 'https://bankon.leddy231.se/auth?bank=nordea',
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