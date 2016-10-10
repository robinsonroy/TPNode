var http = require('http');
var user = require('./user');

http.createServer(function(req, res){
  user.get("Robinson", function(id){
    res.writeHead(200, {'Content-Type': 'text/plain'});
		res.write('hey ');
		res.end('Hello ' + id);
  });

}).listen(8080);
