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
    }
  ]
