// Generated by CoffeeScript 1.11.1
(function() {
  var http, user;

  http = require('http');

  user = require('./user');

  http.createServer(function(req, res) {
    user.get('Robinson', function(id) {
      res.writeHead(200, {
        'Content-Type': 'text/plain'
      });
      res.end('Hello ' + id);
    });
  }).listen(8080);

}).call(this);