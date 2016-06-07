module.exports = (server, options) ->
  Handler = require('./handler')(server, options)
  Validator = require './validator'

  return [
    {
    method: 'POST',
    path: '/posts'
    config:
      auth:
        mode: 'required'
      validate: Validator.create
      handler: Handler.create
    }
  ]
