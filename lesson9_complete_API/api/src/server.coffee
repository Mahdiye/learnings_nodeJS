Hapi = require 'hapi'

server = new Hapi.Server()
server.connection
  port: 3100

server.register [
  require 'vision'
  require 'inert'
  register: require 'lout'
], (err) -> throw err if err

server.start (err) ->
  throw err if err
  console.log 'server start at: ', server.info.uri

