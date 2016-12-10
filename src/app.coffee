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
  console.log "Auth Check for " + req.session.username
  if req.session.username
    console.log("Auth check ok")
    next()
  else
    console.log("Auth check nok")
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
      req.session.username = value.username;
      res.redirect '/'

app.get '/logout', authCheck, (req,res) ->
  console.log "Logout of " + req.session.username
  delete req.session.loggedIn
  delete req.session.username
  res.redirect '/'

app.get '/signup', (req, res)->
  res.render 'signup',
    error: req.query.error ?= ''

app.post '/signup', (req, res)->
  user.save req.body.username, req.body.password, req.body.name, req.body.email, (err) ->
    if err
      req.params.err = err
      res.redirect '/signup'
    else
      console.log "Signup secess"
      req.session.loggedIn = true;
      req.session.username = req.body.username;
      res.redirect '/'

app.post '/user/delete', authCheck, (req, res)->
  metrics.deleteFromUser req.session.username, (err)->
    throw err if err
    next()
  user.delete req.session.username, (err) ->
    throw err if err
    res.redirect '/logout'

app.get '/', authCheck, (req, res) ->
  res.render 'app',
    metric_error: req.query.metric_error ?= ''

## send all the user's metrics
## If group is pass in query it send back all the user's metrics for one group
app.get '/metrics.json', authCheck, (req, res)->
  metrics.get req.session.username, (err, data)->
    throw next err if err
    res.status(200).json data
  , req.query.group

app.post '/metrics.json', authCheck, (req, res)->
  metricsJson = req.body
  metrics.save req.session.username, metricsJson, (err) ->
    if err
      console.log "error" + err
      req.params.metric_error = err
      res.redirect '/'
    else
      res.redirect '/'

app.post '/metric/delete/:group/:id', authCheck, (req, res) ->
  key = req.session.username + ':' + req.params.group + ':' + req.params.id
  metrics.delete key , (err) ->
    throw err if err
    res.redirect '/'

app.listen app.get('port'), ->
  console.log "listen on port #{app.get 'port'}"
