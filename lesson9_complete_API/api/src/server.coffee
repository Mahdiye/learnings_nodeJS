Hapi = require 'hapi'
couchbase = require 'couchbase'
BaseModel = require('odme').CB
db= new require('puffer') {host: 'localhost', name:'post'}

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
    titel: on
  PREFIX : 'post'
 
server.route
  method: 'GET'
  path: '/posts/{post_key}'
  handler: (request, reply) ->
    key = request.params.post_key
    Post.get(key)
      .then (post) ->
        reply post.doc

server.start (err) ->
  throw err if err
  console.log 'server start at: ', server.info.uri
