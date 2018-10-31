
const rp = require('request-promise')
const express = require('express')
const path = require('path')

// This server will serve files in this directory
const public = path.join(__dirname, '../public')

// Pharo report-server should listen here
const reportServerBaseUrl = "http://localhost:8083/"

/**
 * This is the entry point for the Github's Probot App.
 * @param {import('probot').Application} app - Probot's Application class.
 */
module.exports = app => {

  app.log('Github App ready!')

  app.on('issues.opened', async context => {
    const issueComment = context.issue({ body: 'Thanks for opening this issue!' })
    return context.github.issues.createComment(issueComment)
  })

  app.on('issues.edited', async context => {

    const options = {
      method: 'POST',
      url: reportServerBaseUrl + 'issues.edited',
      headers: {'Content-Type': 'application/json'},
      body: context.payload,
      json:true
    }

    return rp(options)
      .then(body => {
        const issueComment = context.issue({ body: body })
        return context.github.issues.createComment(issueComment)
      })
  })

  // Get an express router to expose new HTTP endpoints (a liveness check)
  app.route('/alive').get('/', (req, res) => {
    const options = {
      method: 'GET',
      url: reportServerBaseUrl + 'alive'
    }

    return rp(options)
      .then(body => res.end(body))
      .catch(_ => res.send.status(500).end("Report server is not alive"))
  })

  app.route('/public').use(express.static(public))

}
