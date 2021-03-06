Boom = require 'boom'
_ = require 'lodash'
id = require('shortid').generate()

module.exports = (server, options) ->
  Secret = options.secret_key
  Post = require('./model.coffee')(server, options)

  return {
    create: (request, reply) ->
      post = new Post "p_#{id}:#{request.auth.credentials.doc_key}", request.payload
      post.doc.user_key = request.auth.credentials.doc_key
      post.create(true)
      .then (post) ->
        reply post

    list_all: (request, reply) ->
      reply Post.list_all(request.query.page)

    get_by_key: (request, reply) ->
      key = request.params.post_key
      Post.get(key)
        .then (post) ->
          reply post.doc

    list_my_post: (request, reply) ->
      user_key = request.auth.credentials.doc_key
      Post.get_by_user_key(user_key, request.query.page)
      .then (my_posts) ->
        data = []
        for result in my_posts.hits.hits
          data.push result._source.doc
        reply data
    
    delete:(request, reply) ->
      if  (request.params.key).split(":")[1] is  request.auth.credentials.doc_key
        Post.remove(request.params.key)
        .then (result) ->
          reply result
      else reply Boom.badRequest "just delete your own post"

    update: (request, reply) ->
      if  (request.params.key).split(":")[1] is  request.auth.credentials.doc_key
        post = new Post request.params.key, request.payload
        post.update(true)
        .then (result) ->
          reply result
      else reply "just update your own post"
  }
