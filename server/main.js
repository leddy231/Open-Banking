var path = require('path');
var request = require("request");
const express = require('express')
const app = express();


app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
  res.send("Hello bankon!");
});

app.get('/login', (req, res) => {
  res.sendFile(path.join(__dirname + '/sites/login.html'));
});

app.get('/auth', (req, res, next) => {
  if(req.query.bank == 'seb') {
    const code = req.query.code;
    getAccessToken(code).then(response => {
        res.json(response)
    })
  } else {
    next();
  }
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

function getAccessToken(code) {
  return new Promise((resolve, reject) => {
    //https://developer.sebgroup.com/node/1655
    var options = { 
      method: 'POST',
      url: 'https://api-sandbox.sebgroup.com/mga/sps/oauth/oauth20/token',
      headers: { 
        accept: 'application/json', 'content-type': 'application/x-www-form-urlencoded'
      },
      form: { 
        client_id: 'N48Hmiaxd7Jdm88CL37c',
        client_secret: 'mT9Bki2coWwUeugyIqDX',
        code: code,
        redirect_uri: 'https://bankon.leddy231.se/auth?bank=seb',
        grant_type: 'authorization_code'
      }
    };

    request(options, (error, response, body) => {
      if(error) {
        console.error('Failed: %s', error.message);
        reject(error);
      }
      resolve(JSON.parse(body));
    });
  })
}