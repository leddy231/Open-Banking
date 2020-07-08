import path from 'path'
import express from 'express'
import banks from './lib/banks/banks.js'
const app = express();

app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
  res.sendFile(path.join(process.cwd() + '/sites/login.html'));
});

app.get('/banks', async (req, res) => {
  res.json(Object.keys(banks));
})

function bankquery(req, res, next) {
  let bank = banks[req.query.bank]
  if(bank != null) {
    req.bank = bank
    next()
  } else {
    res.json({error: 'Unknown bank'})
  }
}

app.get('/redirecturl', bankquery, async (req, res) => {
  res.json({url: req.bank.auth.redirect.url})
})

app.get('/auth', bankquery, async (req, res) => {
  let response = await req.bank.auth.redirect.parse(req)
  res.redirect(`/accounts?bank=${req.bank.name}&token=${response.access_token}`)
})

app.post('/token', bankquery, async (req, res) => {
  let response = await req.bank.auth.redirect.parse(req)
  res.json({token: response.access_token})
})

app.get('/accounts', bankquery, async (req, res) => {
  let accounts = await req.bank.accounts.get(req)
  res.json(accounts)
})

app.get('/*', (req, res) => {
  var obj = {
    body: req.body,
    params: req.params,
    query: req.query,
    url: req.originalUrl,
  };
  res.send(JSON.stringify(obj, null, 2));
});

app.listen(8000, () => {
  console.log('Example app listening on port 8000!')
});