should = require 'should'
user = require '../lib/user'

describe('User', () ->
  describe('#get()', () ->
    it('should execute the callback', () ->
      tmp = user.get("jack", (user)->user)
      should.equal("jack", tmp)
      return
    )
    return
  )
  return
)
