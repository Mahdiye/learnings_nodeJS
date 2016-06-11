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

    @list: ->
      client.search
        index: 'lesson12'
        type: 'posts'
        body:
          query:
            match_all: {}
