const fs = require('fs')
const jwt = require('jsonwebtoken')

if (!process.argv[2] | !process.argv[3]) {
  console.log("Generates a JWT signed with RS256 algorithm as Github API expects for Github Apps\n")
  console.log("Expected arguments: <app_id> <pem_path>\n")
  console.log("     <app_id>: The integer that identifies the Github App.")
  console.log("   <pem_path>: The path to the pem file with the RSA private key of the Github App.")
  return 1;
}

const appId = parseInt(process.argv[2])
const cert = fs.readFileSync(process.argv[3])

const now = Math.floor(Date.now() / 1000)
const payload = { "iat": now, "exp": now + (10 * 60), "iss": appId }

const token = jwt.sign(payload, cert, { algorithm: 'RS256'})
console.log(token)
