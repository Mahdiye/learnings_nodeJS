module.exports = (server, options) ->
  Config = require('../../api/src/config').default

  BaseModel = require('odme').CB
  db= new require('puffer') { host: Config.databases.application.host , name: Config.databases.application.name }

  elasticsearch = require 'elasticsearch'
  client = new elasticsearch.Client
    host: "#{Config.searchengine.host}:#{Config.searchengine.port}"

  class User extends BaseModel
    source: db
    props:
      email: on
      password: on
      name: on

    PREFIX : 'u'

    @registered : (email) ->
      client.search
        index: 'lesson12'
        type: 'users'
        body:
          query:
            match:
              email: email