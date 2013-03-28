
var HealthServiceAdapter = require('../cloud/HealthServiceAdapter.js').HealthServiceAdapter;
var expect = require('expect.js');

describe('HealthServiceAdapter.test()', function() {
	it('should be true', function () {

		HealthServiceAdapter.test({}, {
			success : function (test) {
				done();
				expect(test).to.be.true;
			}
		});
	});
});