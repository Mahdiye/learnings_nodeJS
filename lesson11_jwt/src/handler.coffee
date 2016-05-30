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
      reply 'enter email: m.hosseinyzade@gmail.com and password: 1234' unless request.payload.email is 'm.hosseinyzade@gmail.com' and request.payload.password is '1234'

      if request.payload.email is 'm.hosseinyzade@gmail.com' and request.payload.password is '1234'
        reply 'You are logged in'
          .header("Authorization", request.headers.authorization)
  }
