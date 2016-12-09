db = require('./db')("metrics")

shortid = require 'shortid'

module.exports =
  get: (username, callback) ->
    metrics = []
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      [_username, _group, _id] = data.key.split(':')
      if(_username == username)
        [_timestamp, _value] = data.value.split(':')
        metric =
          "username" : _username,
          "group" : _group,
          "id" : _id,
          "timestamp" : _timestamp,
          "value" : _value
        metrics.push (metric)
    rs.on 'error', ()->
      callback error, null
    rs.on 'close', ()->
      callback null, metrics

  getInGroupe: (username, groupe, callback) ->
  #   callback null

  save: (username, metrics, callback) -> 
    console.log "Save some metrics"
    ws = db.createWriteStream() 
    ws.on 'error', callback 
    ws.on 'close', callback 
    for metric in metrics 
      if username and metric.groupe and metric.timestamp and metric.value
        #format 2013-11-04 14:30 UTC to a timestamp
        metric.timestamp = new Date(metric.timestamp).getTime()
        if metric.id
          ws.write key: "#{username}:#{metric.groupe}:#{metric.id}", value: "#{metric.timestamp}:#{metric.value}"
          console.log "Metric modified"
        else
          ws.write key: "#{username}:#{metric.groupe}:#{shortid.generate()}", value:"#{metric.timestamp}:#{metric.value}"
          console.log "Metric created"
      else
        callback "Missing some information in metric"
    ws.end()
