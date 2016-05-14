var Hapi, server;

Hapi = require('hapi');

server = new Hapi.Server();

server.connection({
  port: 3000
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

server.method('sayhi', function(name) {
  return "hi " + name;
});

server.route({
  method: 'GET',
  path: '/hello/{name}',
  handler: function(request, reply) {
    return reply(server.methods.sayhi(request.params.name));
  }
});

server.start(function() {
  return console.log('Server running at:', server.info.uri);
});
