
var request = require("request");

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
      method: 'GET',
      url: 'https://randomuser.me/api/',
      headers: {},
      json:true
    }
    return request(options, function (error, response, body) {
      if (error) { return console.log(error); }

      const names = body.results[0].name
      const message = 'Hello mr. ' + context.payload.sender.login + '. Do you know ' + names.title + ". " + names.last + "?"

      const issueComment = context.issue({ body: message })
      return context.github.issues.createComment(issueComment)

    });

  })

}
