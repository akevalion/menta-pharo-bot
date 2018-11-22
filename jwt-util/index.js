require('dotenv').config()

var jwt = require('jsonwebtoken')

var cert = process.env.PRIVATE_KEY

var token = jwt.sign({ foo: 'bar' }, cert, { algorithm: 'RS256'})

console.log(token)