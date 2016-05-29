Users = require('./model.coffee')()
JWT = require 'jsonwebtoken' #used to sign our content
Secret = require('../secret.coffee').secret


module.exports = ->
  return {
    signup: (request, reply) ->
      user = new Users request.payload
      user.create(true)
      .then (users) ->
        #use the token as the 'authorization' header in requests
        token = JWT.sign(users, Secret) #synchronous
        console.log 'token': token
        reply users
  }
