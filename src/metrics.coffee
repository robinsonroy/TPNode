db = require('./db')("metrics")

shortid = require 'shortid'

module.exports =
  get: (username, callback, group) ->
    metrics = []
    rs = db.createReadStream()
    rs.on 'data', (data) ->
      [_username, _group, _id] = data.key.split(':')
      if _username == username
        [_timestamp, _value] = data.value.split(':')
        metric =
          "username" : _username,
          "group" : _group,
          "id" : _id,
          "timestamp" : _timestamp,
          "value" : _value
        #if group is undefined it send the datas
        if !group
          metrics.push (metric)
        #if group is defined it send the datas from this group
        else if _group == group
          metrics.push (metric)

    rs.on 'error', ()->
      callback error, null
    rs.on 'close', ()->
      callback null, metrics

  save: (username, metrics, callback) -> 
    console.log "Save some metrics"
    ws = db.createWriteStream() 
    ws.on 'error', callback 
    ws.on 'close', callback 
    for metric in metrics 
      if username and metric.group and metric.timestamp and metric.value
        if metric.id
          ws.write key: "#{username}:#{metric.group}:#{metric.id}", value: "#{metric.timestamp}:#{metric.value}"
          console.log "Metric modified"
        else
          ws.write key: "#{username}:#{metric.group}:#{shortid.generate()}", value:"#{metric.timestamp}:#{metric.value}"
          console.log "Metric created"
      else
        callback "Missing some informations in metric"
    ws.end()

  delete: (key, callback) ->
    db.del key, (err)->
      if !err
        console.log key + " has be deleted."
      callback err

  deleteFromUser: (username, callback) ->
    this.get username, (err, metrics) ->
      for metric in metrics
        key = username + ':' + metric.group + ':' + metric.id
        db.del key, (err)->
          if !err
            console.log key + " has be deleted."
          throw err if err
