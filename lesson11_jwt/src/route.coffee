Handler = require('./handler.coffee')()
module.exports = ->
  return [
    {
      method: 'POST'
      path: '/signup'
      config:
        auth: false
        handler: Handler.signup
    }
  ]
