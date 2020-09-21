import { cnst, wrangle } from  '../wrangler.js';
import { v4 as uuid } from 'uuid';
import qs from 'querystring'

const client_id = 'HANDELSBANKEN_CLIENTID'
const client_secret = ''

const auth = {
    redirect: {
        url: 'https://sandbox.handelsbanken.com/openbanking/oauth2/authorize/1.0?' + qs.encode({
            client_id: client_id,
            response_type: 'code',
            scope: "AIS:ab6daed6-ed5d-46db-8851-05f393a3bd06",
            redirect_uri: 'https://thebankonproject.se/auth?bank=handelsbanken',
            state: 'test'
        })
    }
}

export default {
    name: 'handelsbanken',
    auth: auth,
    accounts: {
        get: () => []
    }
}