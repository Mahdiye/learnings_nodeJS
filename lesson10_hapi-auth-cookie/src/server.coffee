'use strict';
 
Hapi = require 'hapi'
Route = require './route'

server = new Hapi.Server()

server.connection
  port: 3100

server.register [
  require 'vision'
  require 'inert'
  register: require 'lout'
], (err) -> throw err if err

server.register(require('hapi-auth-cookie'), (err) => 

  throw err if err

  cache = server.cache({ segment: 'sessions', expiresIn: 3 * 24 * 60 * 60 * 1000 });
  server.app.cache = cache;

  server.auth.strategy 'session', 'cookie', true, 
    password: 'password-should-be-32-characters'
    cookie: 'sid-example'
    redirectTo: '/login'
    isSecure: false
    validateFunc: (request, session, callback) ->

      cache.get(session.sid, (err, cached) => 

        return callback(err, false) if (err)

        return callback(null, false) if (!cached) 

        return callback(null, true, cached.account)
      )
)

server.route Route()
server.start ->
  console.log 'Server running at port: ', server.info.port
