users = 
  admin: 
    id: 'Mahdieh'
    password: 'admin' 
    name: 'Dear ...' 

uuid = 1 #Use seq instead of proper unique identifiers for demo only 
 
module.exports = ->
  return {
    home : (request, reply) -> 
      reply('<html><head><title>Login page</title></head><body><h3>Welcome ' +
        request.auth.credentials.name +
        '</form></body></html>');

    login : (request, reply) -> 
     
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

    say_hello : (request, reply) ->
      if request.auth.isAuthenticated
        reply "hello #{request.params.name}"

    ping_pong : (request, reply ) ->
      if request.auth.isAuthenticated
        reply 'pong'
      else reply "I will say pong if login"

    logout : (request, reply) -> 
      request.cookieAuth.clear()
      return reply.redirect('/')
  }
