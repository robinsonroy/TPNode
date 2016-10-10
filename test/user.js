var should = require('should');
var assert = require('assert');

var user = require('../lib/user');

describe('User', function() {
  describe('#get()', function() {
    it('should execute the callback', function() {
       var tmp = user.get("wilson", function(user){
          return user;
        });
      assert.equal("wilson", tmp);
    });
  });
});
