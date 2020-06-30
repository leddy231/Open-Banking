import path from 'path'
import express from 'express'
import banks from './lib/banks.js'
const app = express();

app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
  res.sendFile(path.join(process.cwd() + '/sites/login.html'));
});

app.get('/banks', async (req, res) => {
  res.json(Object.keys(banks));
})

app.use('/api', (req, res, next) => {
  let bank = banks[req.query.bank]
  if(bank === null) {
    res.json({error: 'Unknown bank'})
  } else {
    req.bank = bank
    next()
  }
})

app.get('/api/redirecturl', async (req, res) => {
  res.json({url: req.bank.auth.redirect.url})
})

app.get('/api/auth', async (req, res) => {
  let response = await req.bank.auth.redirect.parse(req)
  res.redirect(`/accounts?bank=${req.bank.name}&token=${response.access_token}`)
})

app.get('/api/accounts', async (req, res) => {
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