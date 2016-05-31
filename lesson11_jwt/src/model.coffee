module.exports = ->
  BaseModel = require('odme').CB
  db= new require('puffer') {host: 'localhost', name:'lesson11'}

  class User extends BaseModel
    source: db
    props:
      email: on
      password: on
      full_name: on
      dob: on
      weight: on
      height: on

    PREFIX : 'u'
   
