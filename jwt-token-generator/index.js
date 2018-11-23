const path = require('path')
require('dotenv').config({ path: path.join(__dirname, '../.env') })
const jwt = require('jsonwebtoken')

const cert = process.env.PRIVATE_KEY
const appId = process.env.APP_ID

let now = Math.floor(Date.now() / 1000)
let payload = { "iat": now, "exp": now + (10 * 60), "iss": appId }

let token = jwt.sign(payload, cert, { algorithm: 'RS256'})
console.log(token)
