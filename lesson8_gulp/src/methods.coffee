Hapi = require 'hapi'
server = new Hapi.Server()

server.connection
  port: 3000

server.register [
  require 'vision'
  require 'inert'
  register: require 'lout'
], (err) -> throw err if err

server.method 'sayhi', (name) -> "hi #{name}"

server.route
  method: 'GET'
  path:'/hello/{name}'
  handler: (request, reply) ->
    reply server.methods.sayhi request.params.name

server.start ->
  console.log 'Server running at:', server.info.uri
