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
      user_key: on

    PREFIX : 'p'

    @list: (from=0)->
      size = 5
      client.search
        index: 'lesson12'
        type: 'posts'
        body:
          from: size*from
          size: size
          query:
            match_all: {}
          sort: [
            user_key:
              order: "asc"
            name:
              order: "desc"
          ]
