module.exports = (server, options) ->
  Handler = require('./handler')(server, options)
  Validator = require './validator'

  return [
    {
    method: 'POST',
    path: '/register'
    config:
      auth:
        mode: 'try'
      validate: Validator.login
      handler: Handler.register
    },
    {
      method: 'POST'
      path: '/login/{key}'
      config:
        auth:
          mode: 'try'
        handler: Handler.login
    }
  ]
