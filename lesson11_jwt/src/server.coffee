Hapi = require 'hapi'
Route = require('./route')()
Secret = require('../secret').secret
User = require('./model.coffee')()

server = new Hapi.Server()

server.connection
  port: 3100

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

      User.get (request.params.key or decoded.doc_key)
      .then (user) ->
        if (decoded.email isnt user.doc.email)
          return callback(null, false)
        else
          return callback(null, true)

    verifyOptions:
      ignoreExpiration: true

  server.auth.default 'jwt'

  server.route Route

server.start ->
  console.log 'Server running at: ', server.info.uri
