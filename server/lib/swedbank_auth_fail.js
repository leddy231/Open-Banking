import axios from 'axios';
import qs from 'querystring'

const url =  'https://se.psd2.api.swedbank.com:443/psd2/authorize?' + qs.encode({
    bic: 'SANDSESS',
    client_id: "l711da77f864d94e9997abeeb6879f9f31",
    response_type: 'code',
    scope: 'PSD2sandbox',
    redirect_uri: 'https://bankon.leddy231.se/auth?bank=swedbank',
})
console.log(url)
axios.get(url, {headers: {
    'X-Request-ID': '94e3578a-e6a3-416a-aef7-245ea9099cfe',
    Date: Date()
}}).catch(res => {
    console.log(res)
}).then(res => {
    console.log(res)
})