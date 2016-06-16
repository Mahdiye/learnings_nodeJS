Boom = require 'boom'
module.exports = (server, options) ->
  Secret = require('../../api/src/config').defaults.secret_key
  User = require('./model.coffee')(server, options)
  JWT = require 'jsonwebtoken' #used to sign our content

  return {
    register: (request, reply) ->
      User.get_by_email (request.payload.email)
      .then (result) ->
        if (result.hits.total) >= 1
          return reply Boom.conflict("Email already exist")
        else
          user = new User request.payload
          user.create(true)
          .then (user) ->
             reply user

    login: (request, reply) ->
      User.get_by_email (request.payload.email)
      .then (result) ->
        if (result.hits.total) is 0
          reply Boom.badRequest "Invalid email"
        else
          doc = result.hits.hits[0]._source.doc
          if doc.email is request.payload.email and doc.password is request.payload.password
            #use the token as the 'authorization' header in requests
            options =
              expiresIn: "7d"
            payload =
              email: doc.email
              name: doc.name
              doc_key: doc.doc_key
            token = JWT.sign(payload, Secret, options) #synchronous
            console.log 'token': token
            reply ('logged in')
              .header('Authorization', token)
          else reply Boom.badRequest "Wrong password"

    me: (request, reply) ->
      User.get( request.auth.credentials.doc_key )
      .then (me) ->
        reply email:me.doc.email, name: me.doc.name
  }
