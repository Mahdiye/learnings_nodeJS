module.exports = (server, options) ->
  Config = require('../../api/src/config').defaults

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
      is_valid: off

    PREFIX : 'u'

    @get_by_email : (email) ->
      client.search
        index: 'lesson12'
        type: 'users'
        body:
          query:
            match:
              email: email
