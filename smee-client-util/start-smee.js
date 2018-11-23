const path = require('path')
require('dotenv').config({ path: path.join(__dirname, '../.env') })

const SmeeClient = require('smee-client')

const smee = new SmeeClient({
    source: process.env.WEBHOOK_PROXY_URL,
    target: 'http://localhost:3000',
    logger: console
})

const events = smee.start()

process.on('SIGINT', function () {
    // Stop forwarding events
    events.close()
    console.log("Finished forwarding")
})
