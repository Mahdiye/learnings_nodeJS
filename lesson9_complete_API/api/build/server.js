var Hapi, server;

Hapi = require('hapi');

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

server.start(function(err) {
  if (err) {
    throw err;
  }
  return console.log('server start at: ', server.info.uri);
});
