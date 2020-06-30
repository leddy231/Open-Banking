import { cnst, wrangle } from  './wrangler.js';
import { v4 as uuid } from 'uuid';
import axios from 'axios';
import qs from 'querystring'

const client_id = 'l724380896884942a8adefc673a7bef568'
const client_secret = 'ea6abb896d4b42d09a92c98a3bf3520f'

const auth = {
    redirect: {
        url: 'https://se.psd2.api.swedbank.com:443/psd2/authorize' + qs.encode({
            client_id: client_id,
            bic: 'SANDSESS',
            response_type: 'code',
            redirect_uri: 'https://bankon.leddy231.se/auth?bank=swedbank',
            scope: 'PSD2sandbox'

        })
    }
}

export default {
    name: 'swedbank',
    auth: auth,
    accounts: {
        get: () => []
    }
}