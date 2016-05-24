var Handler;

Handler = require('./handler');

module.exports = function() {
  return [
    {
      method: 'GET',
      path: '/',
      config: {
        handler: Handler().home
      }
    }, {
      method: ['GET', 'POST'],
      path: '/login',
      config: {
        handler: Handler().login,
        auth: {
          mode: 'try'
        },
        plugins: {
          'hapi-auth-cookie': {
            redirectTo: false
          }
        }
      }
    }, {
      method: 'GET',
      path: '/hello/{name}',
      config: {
        handler: Handler().say_hello,
        plugins: {
          'hapi-auth-cookie': {
            redirectTo: false
          }
        }
      }
    }, {
      method: 'GET',
      path: '/ping',
      config: {
        auth: {
          mode: 'try'
        },
        handler: Handler().ping_pong,
        plugins: {
          'hapi-auth-cookie': {
            redirectTo: false
          }
        }
      }
    }, {
      method: 'GET',
      path: '/logout',
      config: {
        handler: Handler().logout
      }
    }
  ];
};
