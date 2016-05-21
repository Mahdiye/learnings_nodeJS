Hapi = require 'hapi'
_ = require 'lodash'

#couchbase = require 'couchbase'

BaseModel = require('odme').CB
db= new require('puffer') {host: 'localhost', name:'posts'}

elasticsearch = require 'elasticsearch'
client = new elasticsearch.Client
  host: 'localhost:9200',
  log: 'trace'

server = new Hapi.Server()
server.connection
  port: 3100

server.register [
  require 'vision'
  require 'inert'
  register: require 'lout'
], (err) -> throw err if err


class Post extends BaseModel
  source: db
  props:
    title: on
    body: on
    author: on
  PREFIX : 'post'
 
server.route
  method: 'GET'
  path: '/posts/{post_key}'
  handler: (request, reply) ->
    key = request.params.post_key
    Post.get(key)
      .then (post) ->
        reply post.doc

server.route
  method: 'POST'
  path: '/posts'
  handler: (request, reply) ->
    post = new Post request.payload
    post.create(true)
      .then (post) ->
        reply post

server.route
  method: 'GET'
  path: '/posts'
  handler: (request, reply) ->
    client.search
      index: 'posts'
      type: 'post'
    .then (result) ->
      keys = _.map(result.hits.hits, '_source.doc.doc_key')
      Post.find(keys)
      .then (blogs) ->
        reply blogs

server.route
  method: 'PUT'
  path: '/posts/{post_key}'
  handler: (request, reply) ->
    key = request.params.post_key
    post = new Post key, request.payload
    post.update(true)
      .then (post) ->
        reply post

server.start (err) ->
  throw err if err
  console.log 'server start at: ', server.info.uri
