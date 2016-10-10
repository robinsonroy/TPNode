http = require('http')
user = require('./user')

http.createServer((req, res) ->
  user.get 'Robinson', (id) ->
    res.writeHead 200, {'Content-Type': 'text/plain'}
    res.end 'Hello ' + id
    return
  return
).listen 8080
