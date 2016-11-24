db = require('./db')("user")

module.exports =
  get: (callback) ->
    callback null, db.createReadStream().on('data', (data) ->
      console.log data.key, '=', data.value
      ).on('error', (err) ->
        console.log 'Oh my!', err
      ).on('close', ->
        console.log 'Stream closed'
      ).on 'end', ->
        console.log 'Stream ended'

  post: (user, callback) ->
    metrics = []
    consol.log id
    rs = db.createdReadStream()
      start: "user:#{username}"
      stop: "user:#{id}"
    .on 'data', (data) ->
      [_, _username] = data.key.split ':'
      []
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, user

  save: (username, password, name, email, callback) ->
    db.put "#{username}", "#{name}:#{password}:#{email}", (err) -> 
      if err then callback err
      else
        console.log 'user ' + username + ' add'
        callback()

  remove: (username, callback)->
    callback(username)
