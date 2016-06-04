module.exports = (server, options) ->
  Secret = require('../../api/src/config').default.secret_key
  User = require('./model.coffee')(server, options)
  JWT = require 'jsonwebtoken' #used to sign our content
  aguid = require('aguid')()

  return {
    register: (request, reply) ->
      User.registered (request.payload.email)
      .then (result) ->
        if (result.hits.total) >= 1
          return reply "Email already exist"
        else
          user = new User request.payload
          user.create(true)
          .then (user) ->
            #use the token as the 'authorization' header in requests
            verification =
              valid: true
              id: aguid
              exp: new Date().getTime() + 30 * 60 * 1000 #expires in 30 minutes time
              email: user.email
              name: user.name
              doc_key: user.doc_key
            token = JWT.sign(verification, Secret) #synchronous
            console.log 'token': token
            reply user
