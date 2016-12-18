should = require 'should'
user = require '../lib/user'

describe('User', () ->

  describe('#save()', ()->
    it('should add a user in the database', (done) ->
      user.save("jack", "password", "JackRichard", "jack@gmail.com", (err)->
        should.equal(undefined, err)
        done()
      )
    )
    it('should get this user from the database', (done) ->
      user.get("jack", "password", (err, value)->
        should.equal(undefined, err)
        should.equal(value.email, "jack@gmail.com")
        done()
      )
    )
  )

  describe('#delete()', ()->
    it('should delete robinsonroy from the database', (done) ->
      user.delete("robinsonroy", (err)->
        should.equal(undefined, err)
        done()
      )
    )
    it('should not get this user from the database', (done) ->
      user.get("robinson", "password", (err, value)->
        should.equal(undefined, value)
        should.notEqual(undefined, err)
        done()
      )
    )
  )

  describe('#get()', () ->
    it('should execute get the user', (done) ->
        user.get("lgrondin", "password", (err,value)->
          should.equal("lgrondin",value.username)
          should.equal("Lionel",value.name)
          should.equal("lgrondin@gmail.com",value.email)
          done()
        )
      )
    )
)
