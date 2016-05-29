Hapi = require 'hapi'
Route = require('./route.coffee')()
JWT = require 'jsonwebtoken' #used to sign our content

Secret = require('../secret.coffee').secret

people =
  1:
    id: 1
    name: 'admin'

#use the token as the 'authorization' header in requests
token = JWT.sign(people[1], Secret) #synchronous
console.log 'token': token

server = new Hapi.Server()

server.connection
  port: 3100

server.register [
  require 'vision'
  require 'inert'
  register: require 'lout'
], (err) -> throw err if err

server.register require('hapi-auth-jwt2'), (err) ->
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

      if (!people[decoded.id])
        return callback(null, false)
      else
        return callback(null, true)

    verifyOptions: { algorithms: [ 'HS256' ] } #pick a strong algorithm 

  server.auth.default 'jwt'

  server.route Route

server.start ->
  console.log 'Server running at: ', server.info.uri
