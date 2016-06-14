module.exports = (server, options) ->
  User = require('../../users/src/model') server, options
  server.method 'user.find', (keys, next) ->
    next null, User.find(keys)
