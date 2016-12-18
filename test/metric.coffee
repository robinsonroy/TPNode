should = require 'should'
metric = require '../lib/metrics'

describe('Metrics', () ->
  describe('#get()', ()->
    it('should retrived the metrics of a group', (done) ->
      metric.get("robinsonroy", (err,value)->
        should.equal("robinsonroy", value[0].username)
        should.equal("ByHQoVKKme", value[0].id)
        should.equal("Polution", value[0].group)
        should.equal("1445515200000", value[0].timestamp)
        should.equal("185", value[0].value)
        done()
      ,"Polution"
      )
    )
  )

  describe('#save()', () ->
    #delete the added metrics
    it('should add new metrics', (done)->
      metricJson = []
      metricToSave =
        group: 'test'
        timestamp: '1445515200000'
        value: 187
      metricJson.push(metricToSave)

      metric.save("robinsonroy", metricJson, (err)->
          should.equal(null, err)
          done()
      )
    )
  )

  describe('#delete()', () ->
    it('should delete a metric line', (done)->
      metric.delete("robinsonroy:Polution:H1N7jEYYXl", (err) ->
        should.equal(null, err)
        done()
      )
    )
  )

  describe('#deleteFromUser()', () ->
    it('should delete all metric af the user', (done)->
      metric.deleteFromUser("robinsonroy", (err) ->
        should.equal(null, err)
        done()
      )
    )
    it('should get no metric', (done) ->
      metric.get("robinsonroy", (err, value) ->
        should.equal(null, err)
        value.should.be.empty
        done()
        )
      )
  )

)
