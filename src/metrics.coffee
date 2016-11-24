db = require('./db')("metrics")

module.exports =
  ###
    `get(callback)` 
    ——————— 
    returns some hard-coded metrics 

    `callback`: callback function
  ###

  get: (callback) ->
    callback null, [
      timestamp:(new Date '2013-11-04 14:00 UTC').getTime(), value:1
    ,
      timestamp:(new Date '2013-11-04 14:30 UTC').getTime(), value:2
    ]
