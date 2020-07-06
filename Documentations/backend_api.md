
### GET /banks
returns a list of all available banks, use these strings in the other requests  
response: `[string]`

### GET /redirecturl?bank=$bank
gets the redirect url for `$bank`  
response: `{url: string}`

### GET /auth?bank=$bank&code=$code
after a redirect auth is completed user gets redirected here, register a URL handler for this to get the `$code`  
response: redirects to /accounts?bank=$bank&token=$token if accessed by browser

### POST /token?bank=$bank&code=$code
post the code here to get a access token  
response: `{token: string}`

### GET /accounts?bank=$bank&token=$token
gets the accounts from `$bank` with the access `$token`  
response: 
```
{
    "bank": $bank,
    "account_id": string,
    "account_numbers": [
        {
            "type": "IBAN",
            "number": string
        },
        {
            "type": BBAN,
            "number": string
        },
    ],
    "account_currency": string,
    "account_owner": string,
    "account_balance": string,
    "account_type": string,
    "account_status": string,
    "account_bic": string,
}
```