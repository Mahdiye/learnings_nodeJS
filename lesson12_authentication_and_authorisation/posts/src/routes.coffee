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
    },
    {
    method: 'GET',
    path: '/posts'
    config:
      auth:
        mode: 'optional'
      validate: Validator.list
      handler: Handler.list
    },
    {
    method: 'GET',
    path: '/posts/{post_key}'
    config:
      auth:
        mode: 'optional'
      validate: Validator.get_by_key
      handler: Handler.get_by_key
    }

  ]
