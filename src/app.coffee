# http = require('http')
# user = require('./user')
#
# http.createServer((req, res) ->
#   user.get 'Robinson', (id) ->
#     res.writeHead 200, {'Content-Type': 'text/plain'}
#     res.end 'Hello ' + id
#     return
#   return
# ).listen 8080

express = require 'express'
metrics = require './metrics'
user = require './user'
morgan  = require('morgan')
bodyparser = require 'body-parser'


app = express()
app.use morgan 'dev'

app.use bodyparser.json()

app.set 'port', 1337

app.set('view engine', 'pug')
app.set('views', "#{__dirname}/../views")

app.use '/', express.static "#{__dirname}/../public"

app.get '/', (req, res) ->
  res.send "hello world !"

app.get '/hello/:name', (req, res) ->
  res.render 'layout',
    name: req.params.name

app.get '/metrics.json', (req, res) ->
  metrics.get (err, data) ->
    throw next err if err
    res.status(200).json data

app.get '/metrics', (req, res)->
  res.render 'metrics-layout'

app.put '/signup', (req, res)->
  user.save req.body.username, req.body.name, req.body.password, req.body.email, (err) ->
    throw err if err
    res.status(200).send()

app.get '/users', (req, res)->
  user.get (err, data) ->
    throw err if err
    res.render 'user-layout'

app.get '/user/:username', (req, res)->
  user.get req.params.username, (err, value)->
    if err
      res.render 'error',
        error: err
    else
      res.render 'user-layout',
        username : req.params.username
        user: value

app.listen app.get('port'), ->
  console.log "listen on port #{app.get 'port'}"
