User = require('./model.coffee')()
JWT = require 'jsonwebtoken' #used to sign our content
Secret = require('../secret').secret
UUID = require 'node-uuid'

module.exports = ->

  return {
    signup: (request, reply) ->
      user = new User request.payload
      user.create(true)
      .then (user) ->
        #use the token as the 'authorization' header in requests
        verification =
          valid: true
          id: UUID.v4()
          exp: new Date().getTime() + 30 * 60 * 1000 #expires in 30 minutes time
          email: user.email
          doc_key: user.doc_key
        token = JWT.sign(verification, Secret) #synchronous
        console.log 'token': token
        reply user

    login: (request, reply) ->
      User.get(request.params.key)
      .then (user) ->
        if (request.payload.email isnt user.doc.email) or (request.payload.password isnt user.doc.password)
          reply " Invalid email or password "

        else if request.payload.email is user.doc.email and request.payload.password is user.doc.password
          reply 'You are logged in'
            .header("Authorization", request.headers.authorization)

    me: (request, reply) ->
      User.get( request.auth.credentials.doc_key )
      .then (me) ->
        reply me.doc
        
  }
