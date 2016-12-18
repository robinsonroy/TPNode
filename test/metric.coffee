should = require 'should'
metric = require '../lib/metrics'

describe('Metrics', () ->
  describe('#get()', ()->
    it('should retrived the metrics of a group', (done) ->
      metric.get("robinsonroy", (err,value)->
        should.equal("robinsonroy", value[0].username)
        should.equal("ByHQoVKKme", value[0].id)
        should.equal("Polution", value[0].group)
        should.equal("1445515200", value[0].timestamp)
        should.equal("185", value[0].value)
        done()
      ,"Polution"
      )
    )
  )

  describe('#save()', () ->
    #delete the added metrics
    it('should add new metrics', (done)->
      metric.save("robinsonroy", '{ "metric" :[{"group":"test","id": "null", "timestamp":1445515200, "value":187}] }', (err)->
          should.equal(null, err)
          done()
      )
    )
  )

  describe('#delete()', () ->
    it('should delete a metric line', (done)->
      metric.delete("test", (err) ->
        should.equal(null, err)
        done()
      )
    )
  )

  describe('#deleteFromUser()', () ->
    it('should delete all metric af the user', (done)->
      metric.deleteFromUser("debug", (err) ->
        should.equal(null, err)
        done()
      )
    )
  )

)
