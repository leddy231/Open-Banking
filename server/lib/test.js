import moment from 'moment'

const DateFormat = "ddd, DD MMM YYYY HH:mm:ssz"
console.log(moment().format(DateFormat) + 'GMT')