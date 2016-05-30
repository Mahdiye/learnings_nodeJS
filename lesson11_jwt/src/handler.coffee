User = require('./model.coffee')()
JWT = require 'jsonwebtoken' #used to sign our content
Secret = require('../secret').secret


module.exports = ->
  return {
    signup: (request, reply) ->
      user = new User request.payload
      user.create(true)
      .then (users) ->
        reply users
        #use the token as the 'authorization' header in requests
        token = JWT.sign(users, Secret) #synchronous
        console.log 'token': token

    login: (request, reply) ->
      User.get(request.params.key)
      .then (user) ->
        if (request.payload.email isnt user.doc.email) or (request.payload.password isnt user.doc.password)
          reply "enter email: #{user.doc.email} and password: #{user.doc.password}"

        else if request.payload.email is user.doc.email and request.payload.password is user.doc.password
          reply 'You are logged in'
            .header("Authorization", request.headers.authorization)
  }
