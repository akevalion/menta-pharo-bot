
var request = require("request");

// Pharo report-server should listen here
const reportServerBaseUrl = "http://localhost:8083/"

/**
 * This is the entry point for your Probot App.
 * @param {import('probot').Application} app - Probot's Application class.
 */
module.exports = app => {

  app.log('Yay, the app was loaded!')

  app.on('issues.opened', async context => {
    const issueComment = context.issue({ body: 'Thanks for opening this issue!' })
    return context.github.issues.createComment(issueComment)
  })

  app.on('issues.edited', async context => {

    //console.log(context.payload);

    var options = {
      method: 'POST',
      url: reportServerBaseUrl + 'issues.edited',
      headers: {'Content-Type': 'application/json'},
      body: context.payload,
      json:true
    }
    return request(options, function (error, response, body) {
      if (error) { return console.log(error) }

      console.log(body)

      const issueComment = context.issue({ body: body })
      return context.github.issues.createComment(issueComment)
    });
  })

  // Get an express router to expose new HTTP endpoints
  const route = app.route('/testing');

  // Liveness check
  route.get('/alive', (req, res) => res.end('yes'))

 
}
