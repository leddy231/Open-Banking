import swedbank from './swedbank.js'


import axios from 'axios';
axios.get(swedbank.auth.redirect.url).catch(e => {
    console.log(e)
}).then(res => {
    console.log(res)
})