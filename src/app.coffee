# http = require('http')

express = require 'express'
session = require 'express-session'
levelStore = require('level-session-store')(session);
metrics = require './metrics'
user = require './user'
morgan  = require 'morgan'
bodyparser = require 'body-parser'
stylus = require 'stylus'
nib = require 'nib'


app = express()
app.use morgan 'dev'

app.use stylus.middleware
   src: __dirname + '/../stylesheets'
   dest: __dirname + '/../public/css'
   compile: (str, path) ->
     stylus(str)
       .set('filename', path)
       .set('compress', true)
       .use(nib())
       .import('nib')

app.use bodyparser.json()
app.use bodyparser.urlencoded(
  extended: true
)

app.set 'port', 1337

app.use session(
  secret: 'metricsApp'
  store: new levelStore './db/session'
  resave: true
  saveUninitialized: true
  #cookie: { secure: true }
)


authCheck = (req, res, next) ->
  console.log "Auth Check ..."
  console.log req.session.user
  if req.session.loggedIn == true
    console.log("auth check ok")
    next()
  else
    console.log("auth check nok")
    res.redirect '/login'

app.set('view engine', 'pug')
app.set('views', "#{__dirname}/../views")

app.use '/', express.static "#{__dirname}/../public"

app.get '/login', (req, res) ->
  console.log "Login Error : " + req.query.error
  res.render 'login',
    error: req.query.error ?= ''

app.post '/login', (req, res) ->
  user.get req.body.username, req.body.password, (err, value)->
    if err
      req.params.error = err
      res.redirect '/login'+'/?error='+err,
    else
      req.session.loggedIn = true;
      req.session.user = value.username;
      res.redirect '/'

app.get '/logout', authCheck, (req,res) ->
  delete req.session.loggedIn
  delete req.session.user
  res.redirect '/'

app.get '/', authCheck, (req, res) ->
  console.log("access to app")
  res.end('Welcome !');

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

app.listen app.get('port'), ->
  console.log "listen on port #{app.get 'port'}"
