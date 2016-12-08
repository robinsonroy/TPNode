should = require 'should'
user = require '../lib/user'

describe('User', () ->
  describe('#get()', () ->
    it('should execute the callback', () ->
      user.get("lgrondin","password", (err, value) ->
        should.equal(lgrondin,value.username))
    )
  )

  describe('#save()', ()->
    it('should execute the callback', () ->
      user.save("jack", (user,value)->
        should.equal(1, 1)
    )
  )

)
