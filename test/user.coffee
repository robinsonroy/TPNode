should = require 'should'
user = require '../lib/user'

describe('User', () ->

  describe('#save()', ()->
    it('should add a user to the database', (done) ->
      user.save("jack", "password", "JackRichard", "jack@gmail.com", (err)->
        should.equal(undefined, err)
        done()
        )
    )
  )

  describe('#get()', () ->
    it('should execute add user', (done) ->
        user.get("lgrondin", "password", (err,value)->
          should.equal("lgrondin",value.username)
          should.equal("Lionel",value.name)
          should.equal("lgrondin@gmail.com",value.email)
          done()
        )
      )
    )
)
