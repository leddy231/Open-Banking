import path from 'path'
import express from 'express'
import morgan from 'morgan'
import banks from './lib/banks/banks.js'
import {db, storage, auth} from './lib/firebase.js'
const app = express();

app.use(morgan('combined'))
app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
  res.sendFile(path.join(process.cwd() + '/sites/login.html'));
});

app.get('/.well-known/assetlinks.json', (req, res) => {
  res.sendFile(path.join(path.resolve() + '/assetlinks.json'));
})

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

async function fireuser(req, res, next) {
  let token = req.query.firebasetoken
  if(token != null) {
    const decodedToken = await auth.verifyIdToken(token)
    req.user = decodedToken
    req.user.data = db.collection('users').doc(req.user.user_id)
    next()
  } else {
    res.json({error: 'No firebase user token provided'})
  }
}

function accesstoken(req, res, next) {
  let token = req.query.accesstoken
  if(token != null) {
    req.token = token
    next()
  } else {
    res.json({error: 'No accesstoken supplied'})
  }
}

app.get('/redirecturl', bankquery, async (req, res) => {
  res.json({url: req.bank.auth.redirect.url})
})

app.get('/auth', bankquery, async (req, res) => {
  //let response = await req.bank.auth.redirect.parse(req)
  //res.redirect(`/accounts?bank=${req.bank.name}&token=${response.access_token}`)
  res.send('ok')
})

app.post('/token', bankquery, fireuser, async (req, res) => {
  let response = await req.bank.auth.redirect.parse(req)
  req.user.data.collection('banks').doc(req.bank.name).set({accesstoken: response.access_token, consent: false})
  res.json({accesstoken: response.access_token})
})

app.get('/accounts', bankquery, accesstoken, async (req, res) => {
  let accounts = await req.bank.accounts.get(req)
  res.json(accounts)
})

app.post('/accounts', bankquery, accesstoken, fireuser, async (req, res) => {
  let accounts = await req.bank.accounts.get(req)
  for (const accountIndex in accounts) {
    var account = accounts[accountIndex]
    req.user.data.collection('accounts').doc(account.account_id).set(account)
  }
  res.json({status: 'ok'})
})

app.post('/consent', bankquery, accesstoken, fireuser, async (req, res) => {
  const data = await req.user.data.collection('accounts').get()
  let accounts = []
  data.forEach((doc) => {
    accounts.push(doc.data())
  });
  let response = await req.bank.accounts.consent(req, accounts)
  console.log(response)
  res.json(response)
})

app.all('/validconsent', bankquery, async (req, res) => {
  await db.collection('users').doc(req.query.user).collection('banks').doc(req.bank.name).update({consent: true})
  res.send('<h1>You can return to the Bankon app now</h1>')
})
app.post('/verifyFirebase', fireuser, async (req, res) => {
  res.json(req.user)
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