id = require('shortid').generate()
module.exports = (server, options) ->
  Secret = options.secret_key
  Post = require('./model.coffee')(server, options)

  return {
    create: (request, reply) ->
      post = new Post "p_#{id}:#{request.payload.user_key}", request.payload
      post.create(true)
        .then (post) ->
          reply post

    get_by_key: (request, reply) ->
      key = request.params.post_key
      Post.get(key)
        .then (post) ->
          reply post.doc
  }
