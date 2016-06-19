module.exports = (server, options) ->
  User = require('../../users/src/model') server, options
  server.method 'user.find', (keys) ->
    User.find(keys)
