Hapi = require 'hapi'
Config = require './config'
Secret = Config.defaults.secret_key

server = new Hapi.Server()

server.connection
  port: Config.defaults.server.api.port
  labels: 'api'

server.register [
  { register: require 'vision' }
  { register: require 'inert' }
  { register: require 'lout' }
  { register: require 'hapi-auth-jwt2' }
], (err) ->
  throw err if err

  server.auth.strategy 'jwt', 'jwt',
    key: Secret #Never Share your secret key 
    validateFunc: (decoded, request, callback) ->
      console.log(" - - - - - - - decoded token:")
      console.log(decoded)
      console.log(" - - - - - - - request info:")
      console.log(request.info)
      console.log(" - - - - - - - user agent:")
      console.log(request.headers['user-agent'])

      #should improve
      if (decoded.exp < new Date().getTime())
        return callback(null, true)
      else
        return callback(null, false)

    verifyOptions:
      ignoreExpiration: false #reject expired tokens

  server.auth.default 'jwt'

server.register [
  {
    register: require 'lesson12_authentication_and_authorisation.users'
    select: ['api']
  },
  {
    register: require 'lesson12_authentication_and_authorisation.posts'
    options:
      secure_key: Secret
      defaults: Config.defaults
    select: ['api']
  }
],(err) ->
  throw err if err

server.route
  method: 'GET'
  path: '/server/health'
  handler: (request, reply) ->
    reply 'server is ok'

server.start ->
  console.log 'Server running at: ', server.info.uri
