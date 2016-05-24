var users, uuid;

users = {
  admin: {
    id: 'Mahdieh',
    password: 'admin',
    name: 'Dear ...'
  }
};

uuid = 1;

module.exports = function() {
  return {
    home: function(request, reply) {
      return reply('<html><head><title>Login page</title></head><body><h3>Welcome ' + request.auth.credentials.name + '</form></body></html>');
    },
    login: function(request, reply) {
      var account, message, sid;
      if (request.auth.isAuthenticated) {
        return reply.redirect('/');
      }
      message = '';
      account = null;
      if (request.method === 'post') {
        if (!request.payload.username || !request.payload.password) {
          message = 'Missing username or password';
        } else {
          account = users[request.payload.username];
          if (!account || account.password !== request.payload.password) {
            message = 'Invalid username or password';
          }
        }
      }
      if (request.method === 'get' || message) {
        return reply('<html><head><title>Login page</title></head><body>' + (message != null ? message : '<h3>' + message + {
          '</h3><br/>': ''
        }) + '<form method="post" action="/login">' + 'Username: <input type="text" name="username"><br>' + 'Password: <input type="password" name="password"><br/>' + '<input type="submit" value="Login"></form></body></html>');
      }
      sid = String(++uuid);
      return request.server.app.cache.set(sid, {
        account: account
      }, 0, (function(_this) {
        return function(err) {
          if (err) {
            reply(err);
          }
          request.cookieAuth.set({
            sid: sid
          });
          return reply.redirect('/');
        };
      })(this));
    },
    say_hello: function(request, reply) {
      if (request.auth.isAuthenticated) {
        return reply("hello " + request.params.name);
      }
    },
    ping_pong: function(request, reply) {
      if (request.auth.isAuthenticated) {
        return reply('pong');
      } else {
        return reply("I will say pong if login");
      }
    },
    logout: function(request, reply) {
      request.cookieAuth.clear();
      return reply.redirect('/');
    }
  };
};
