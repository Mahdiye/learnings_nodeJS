'use strict';
 
Hapi = require 'hapi'
 
uuid = 1 #Use seq instead of proper unique identifiers for demo only 
 
users = 
  admin: 
    id: 'Mahdieh'
    password: 'admin' 
    name: 'Dear ...' 
    
home = (request, reply) -> 
  reply('<html><head><title>Login page</title></head><body><h3>Welcome ' +
    request.auth.credentials.name +
    '</form></body></html>');

login = (request, reply) -> 
 
  if (request.auth.isAuthenticated) then return reply.redirect('/') 
 
  message = ''
  account = null

  if (request.method is 'post')

    if (!request.payload.username or !request.payload.password)  

      message = 'Missing username or password'
    
    else 
      account = users[request.payload.username]
      if (!account or account.password isnt request.payload.password) 
        message = 'Invalid username or password'

  if (request.method is 'get' or message) 
    return reply('<html><head><title>Login page</title></head><body>' +
        (message ? '<h3>' + message + '</h3><br/>' : '') +
        '<form method="post" action="/login">' +
        'Username: <input type="text" name="username"><br>' +
        'Password: <input type="password" name="password"><br/>' +
        '<input type="submit" value="Login"></form></body></html>')

  sid = String(++uuid)
  request.server.app.cache.set(sid, { account: account }, 0, (err) => 

    reply err if err 

    request.cookieAuth.set({ sid: sid })
    return reply.redirect('/')
    )

server = new Hapi.Server()

server.connection
  port: 3100

server.register(require('hapi-auth-cookie'), (err) => 

  throw err if err

  cache = server.cache({ segment: 'sessions', expiresIn: 3 * 24 * 60 * 60 * 1000 });
  server.app.cache = cache;


  server.auth.strategy 'session', 'cookie', true, 
    password: 'password-should-be-32-characters'
    cookie: 'sid-example'
    redirectTo: '/login'
    isSecure: false
    validateFunc: (request, session, callback) ->

      cache.get(session.sid, (err, cached) => 

        return callback(err, false) if (err)

        return callback(null, false) if (!cached) 

        return callback(null, true, cached.account)
      )

  server.route([
    {
       method: 'GET'
       path: '/'
       config:
         handler: home 
    }
    {
      method: ['GET', 'POST']
      path: '/login'
      config:
        handler: login
        auth:
          mode: 'try' 
        plugins:
          'hapi-auth-cookie': { redirectTo: false }
    }
  ])

  server.start ->
    console.log 'Server running at port: ', server.info.port
)
