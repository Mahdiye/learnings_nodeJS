chai =  require 'chai'
should = chai.should()
chaiHttp = require 'chai-http'
shortid = require('shortid').generate()
Config = require('../../api/src/config')
chai.use chaiHttp
URL = "#{Config.defaults.server.api.host}:#{Config.defaults.server.api.port}"

existing_user_info =
  email: 'm.hosseinyzade@gmail.com'
  password: '123456'
  name: 'Mahdieh'

login_info =
  email: 'm.hosseinyzade@gmail.com'
  password: '123456'

new_user_info =
  email: "m.hosseinyzade#{shortid}@gmail.com"
  password: 'abc123456'
  name: 'Mahdieh'

context 'User', ->
  describe 'login progress', ->
    before (done) ->
      chai.request(URL)
        .post('/register')
        .send(existing_user_info)
         .end (err, res) ->
           done()

    it 'should not register with an existing email', (done) ->
      chai.request(URL)
        .post('/register')
        .send(existing_user_info)
        .end (err, res) ->
          res.text.should.contain 'Email already exist'
          res.should.have.status 409
          done()
   
    it 'should register with new email', (done) ->
      chai.request(URL)
        .post('/register')
        .send(new_user_info)
        .end (err, res) ->
          delete res.body.doc_key
          delete res.body.doc_type
          res.should.have.status 200
          res.body.should.be.deep.eq new_user_info
          done()

    it 'should login with email and password', (done) ->
      chai.request(URL)
        .post('/login')
        .send(login_info)
        .end (err, res) ->
          res.should.have.status 200
          res.text.should.contain "logged in"
          done()

    it 'should not login with wrong password', (done) ->
      chai.request(URL)
        .post('/login')
        .send(email: login_info.email, password: '123456abc')
        .end (err, res) ->
          res.should.have.status 401
          res.text.should.contain "Wrong password"
          done()

    it 'should not login with wrong email', (done) ->
      chai.request(URL)
        .post('/login')
        .send(email: new_user_info.email, password: login_info.password)
        .end (err, res) ->
          res.should.have.status 401
          res.text.should.contain "Invalid email"
          done()

    it 'should not show detail of a user without token', (done) ->
      chai.request(URL)
        .get('/me')
        .end (err, res) ->
          res.should.have.status 401
          done()
          
    it 'should get detail of the user', ->
      chai.request(URL)
        .post('/login')
        .send(login_info)
      .then (res) ->
        chai.request(URL)
        .get('/me')
        .set('Authorization',res.headers.authorization)
        .then (result) ->
          result.should.have.status 200
          result.body.email.should.be.eq 'm.hosseinyzade@gmail.com'
        .catch (err) ->
          throw err
