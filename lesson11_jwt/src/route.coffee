Handler = require('./handler.coffee')()
module.exports = ->
  return [
    {
      method: 'POST'
      path: '/signup'
      config:
        auth: false
        handler: Handler.signup
    },
    {
      method: 'POST'
      path: '/login/{key}'
      config:
        auth: 'jwt'
        handler: Handler.login
    }
    {
      method: 'GET'
      path: '/me'
      config:
        handler: Handler.me
    }
  ]
