module.exports = (server, options) ->
  Handler = require('./handler')(server, options)
  return [
    {
    method: 'POST',
    path: '/register'
    config:
      auth:
        mode: 'try'
      handler: Handler.register
    }
  ]
