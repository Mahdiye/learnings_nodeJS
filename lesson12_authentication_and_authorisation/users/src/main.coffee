routes = require './routes'

exports.register = ( server, options, next) ->
  server = server.select 'api'
  server.route require('./routes') server, options
  next()

exports.register.attributes =
  pkg: require('../package.json')
