'use strict';
var Hapi, Route, server;

Hapi = require('hapi');

Route = require('./route');

server = new Hapi.Server();

server.connection({
  port: 3100
});

server.register([
  require('vision'), require('inert'), {
    register: require('lout')
  }
], function(err) {
  if (err) {
    throw err;
  }
});

server.register(require('hapi-auth-cookie'), (function(_this) {
  return function(err) {
    var cache;
    if (err) {
      throw err;
    }
    cache = server.cache({
      segment: 'sessions',
      expiresIn: 3 * 24 * 60 * 60 * 1000
    });
    server.app.cache = cache;
    return server.auth.strategy('session', 'cookie', true, {
      password: 'password-should-be-32-characters',
      cookie: 'sid-example',
      redirectTo: '/login',
      isSecure: false,
      validateFunc: function(request, session, callback) {
        return cache.get(session.sid, (function(_this) {
          return function(err, cached) {
            if (err) {
              return callback(err, false);
            }
            if (!cached) {
              return callback(null, false);
            }
            return callback(null, true, cached.account);
          };
        })(this));
      }
    });
  };
})(this));

server.route(Route());

server.start(function() {
  return console.log('Server running at port: ', server.info.port);
});
