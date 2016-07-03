chai = require('chai')
should = chai.should()
chaiHttp = require 'chai-http'
Config = require('../../api/src/config')


chai.use chaiHttp
URL = "#{Config.defaults.server.api.host}:#{Config.defaults.server.api.port}"

auth = null
user_key = null
blog = null

login =
  chai.request(URL)
   .post('/login')
   .field('email', 'm.hosseinyzade@gmail.com')
   .field('password', '123456')

context 'post' , ->
  describe 'post when user is login', ->
    before ->
      login
      .then (res) ->
        auth = res.headers.authorization

        chai.request(URL)
          .get('/me')
          .set('Authorization', auth)
          .then (result) ->
            result.should.have.status 200
            user_key = result.body.user_key
            
            chai.request(URL)
              .post('/posts')
              .set('Authorization', auth)
              .field('name', 'lesson 12 tests')
              .then (created_post) ->
                blog = created_post.body

    it 'should get created post', ->
      chai.request(URL)
      .get("/posts/#{blog.doc_key}")
      .then (res) ->
        res.should.have.status 200
        res.body.doc_key.should.be.eq blog.doc_key

    it 'should list all post with detail of the author', ->
      chai.request(URL)
      .get('/posts')
      .then (res) ->
        console.log res.body
        res.body.should.have.length.above 3


    it 'should not delete post of another author', ->
      chai.request(URL)
      .post('/login')
      .field('email', 'm.hosseinyzade123@gmail.com')
      .field('password', '123456')
      .then (res) ->
        authentication = res.headers.authorization

        chai.request(URL)
        .get('/me')
        .set('Authorization', authentication)
        .then (result) ->
          result.should.have.status 200
          user_key = result.body.user_key

          chai.request(URL)
          .delete("/me/posts/#{blog.doc_key}")
          .set('Authorization', authentication)
          .then (res) ->
            res
          .catch (err) ->
            err.should.have.status 400

    describe 'list posts even for unregistered users', ->
      it 'should list post of all user for all', ->
         chai.request(URL)
          .get('/posts')
          .then (post) ->
            console.log post.body
            post.body.should.have.length.above 1
