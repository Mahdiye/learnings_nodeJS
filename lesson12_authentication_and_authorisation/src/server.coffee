Hapi = require 'hapi'
Config = require './config'

server = new Hapi.Server()

server.connection
  port: Config.default.server.api.port
  labels: 'api'

server.register [
  { register: require 'vision' }
  { register: require 'inert' }
  { register: require 'lout' }
], (err) ->
  throw err if err

server.route
  method: 'GET'
  path: '/server/health'
  handler: (request, reply) ->
    reply 'server is ok'

server.start ->
  console.log 'Server running at: ', server.info.uri
