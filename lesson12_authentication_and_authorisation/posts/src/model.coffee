_ = require 'lodash'

module.exports = (server, options) ->
  Defaults = options.defaults

  BaseModel = require('odme').CB
  db= new require('puffer') { host: Defaults.databases.application.host , name: Defaults.databases.application.name }

  elasticsearch = require 'elasticsearch'
  client = new elasticsearch.Client
    host: "#{Defaults.searchengine.host}:#{Defaults.searchengine.port}"

  class Post extends BaseModel
    source: db
    props:
      name: on
      user_key: off

    PREFIX : 'p'

    @list_all: (page=0)->
      size = 5
      client.search
        index: 'lesson12'
        type: 'posts'
        body:
          from: page*size
          size: size
          query:
            match_all: {}
          sort: [
            user_key:
              order: "asc"
            name:
              order: "desc"
          ]
      .then (results) ->
        blogs = []
        user_keys = []
        for keys in results.hits.hits
          user_keys.push keys._source.doc.user_key
          blogs.push keys._source.doc

        server.methods.user.find _.uniq user_keys
          .then (user_details) ->
            user_details
            details = []
            for user in user_details
              for blog in blogs
                if user.doc_key is blog.user_key
                  details.push _.concat(blog,user)

            return details

    @get_by_user_key: (user_key, page=0) ->
      size = 5
      client.search
        index: 'lesson12'
        type: 'posts'
        body:
          from: page*size
          size: size
          query:
            match:
              user_key: user_key
