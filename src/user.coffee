db = require('./db')("user")

module.exports =

  get: (username, password, callback) ->
    db.get username, (err, value) ->
      if err then callback err
      else
        [_password, _name, _email] = value.split(':')
        if password != _password
          return callback "Password not correct"
        callback null,
          name : _name
          email : _email
          username: username

  save: (username, password, name, email, callback) ->
    db.put "#{username}", "#{password}:#{name}:#{email}", (err) -> 
      if err then callback err
      else
        console.log 'user ' + username + ' add'
        callback()

  delete: (username, callback)->
    console.log username + " has deleting is account"
    db.del username, (err)->
      callback err
