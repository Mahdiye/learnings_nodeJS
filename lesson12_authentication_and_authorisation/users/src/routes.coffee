module.exports = (server, options) ->
  Handler = require('./handler')(server, options)
  Validator = require './validator'

  return [
    {
    method: 'POST',
    path: '/register'
    config:
      auth: false
      validate: Validator.register
      handler: Handler.register
    },
    {
      method: 'POST'
      path: '/login'
      config:
        auth:
          mode: 'try'
        validate: Validator.login
        handler: Handler.login
    },
    {
      method: 'GET'
      path: '/me'
      config:
        auth:
          mode: 'required'
        handler: Handler.me
    }
  ]
