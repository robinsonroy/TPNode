db = require('./db')("metrics")

module.exports =
  get: (username, callback) ->
    console.log [timestamp:(new Date '2013-11-04 14:00 UTC').getTime(), value:1]
    callback null, [
      timestamp:(new Date '2013-11-04 14:00 UTC').getTime(), value:1
    ,
      timestamp:(new Date '2013-11-04 14:30 UTC').getTime(), value:2
    ]

  save: (username, metric, callback) ->
    if username and metric.timestamp and metric.value and metric.groupe
      db.put "#{username}:#{groupe}:#{metric.timestamp}", "#{metric.value}", (err) -> 
        if err then callback err
        else
          console.log "timestamp :  #{metric.timestamp}, value: #{metric.value} add for #{username}"
          callback null
    else
      callback "metric is empty"
