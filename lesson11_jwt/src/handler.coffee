Users = require('./model.coffee')()

module.exports = ->
  return {
    signup: (request, reply) ->
      user = new Users request.payload
      user.create(true)
      .then (users) ->
        reply users
  }
