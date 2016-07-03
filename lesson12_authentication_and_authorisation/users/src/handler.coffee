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
        console.log result.hits

        if (result.hits.total) is 0
          reply Boom.unauthorized "Invalid email"
        else
          doc = result.hits.hits[0]._source.doc
          if doc.email is request.payload.email and doc.password is request.payload.password

            #set logged_in flag
            User.get doc.doc_key
            .then (user) ->
              user.doc.is_valid = true
              user.update()

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
          else reply Boom.unauthorized "Wrong password"

    me: (request, reply) ->
      User.get( request.auth.credentials.doc_key )
      .then (me) ->
        if me.doc.is_valid
          reply email:me.doc.email, name: me.doc.name, user_key: me.doc.doc_key
        else reply Boom.unauthorized "Login first"

    logout: (request, reply) ->
      #set logged_out flag 
      User.get request.auth.credentials.doc_key
      .then (user) ->
        user.doc.is_valid = false
        user.update()
        reply "logged out"
  }
