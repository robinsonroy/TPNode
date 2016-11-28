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

  get: (username, password, callback) ->
    db.get username, (err, value) ->
      if err then callback err
      else
        [_password, _name, _email] = value.split(':')
        if password != _password
          console.log("Password not correct")
          return callback "Password not correct"
        callback null,
          name : _name
          email : _email
          username: username

  save: (username, password, name, email, callback) ->
    db.put "#{username}", "#{name}:#{password}:#{email}", (err) -> 
      if err then callback err
      else
        console.log 'user ' + username + ' add'
        callback()

  remove: (username, callback)->
    callback(username)
