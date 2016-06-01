module.exports = (server, options) ->
  Config = require('../../api/src/config').default
  BaseModel = require('odme').CB
  db= new require('puffer') { host: Config.databases.application.host , name: Config.databases.application.name }

  class User extends BaseModel
    source: db
    props:
      email: on
      password: on
      name: on

    PREFIX : 'u'
   
