
var request = require("request");
var rp = require('request-promise')

// Pharo report-server should listen here
const reportServerBaseUrl = "http://localhost:8083/"

/**
 * This is the entry point for your Probot App.
 * @param {import('probot').Application} app - Probot's Application class.
 */
module.exports = app => {

  app.log('App loaded!')

  app.on('issues.opened', async context => {
    const issueComment = context.issue({ body: 'Thanks for opening this issue!' })
    return context.github.issues.createComment(issueComment)
  })

  app.on('issues.edited', async context => {

    //console.log(context.payload);

    const options = {
      method: 'POST',
      url: reportServerBaseUrl + 'issues.edited',
      headers: {'Content-Type': 'application/json'},
      body: context.payload,
      json:true
    }

// TODO: convert to rp and usetest when pharo is down

    return request(options, function (error, response, body) {
      if (error) { return console.log(error) }

      console.log(body)

      const issueComment = context.issue({ body: body })
      return context.github.issues.createComment(issueComment)
    })
  })

  // Get an express router to expose new HTTP endpoints (a liveness check)
  app.route('/alive').get('/', (req, res) => {

    console.log("I'm alive, so let's ask to report server.")

    return rp(reportServerBaseUrl + 'alive').then(body => res.end(body)).catch(_ => res.sendStatus(500))
  })

 
}
