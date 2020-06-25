import  {cnst, map, filter} from  './wrangler';

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

export const nordea = {
    'name': 'nordea',
    'accountFilter': nordeaAccountFilter
}