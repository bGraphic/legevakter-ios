/* 
	Tests for ../cloud/HealthServiceAdapter.js
*/
var HealthServiceAdapter = require('../cloud/HealthServiceAdapter.js').HealthServiceAdapter;
var HealthServiceTestData = require('../test/HealthServiceTestData.js').HealthServiceTestData;
var expect = require('expect.js');

// isHealthServiceData()
describe('HealthServiceAdapter.isHealthServiceData()', function() {

	it('should be a function', function () {
		expect(HealthServiceAdapter.isHealthServiceData).to.be.a('function');
	});

	it('should be return true with test data', function () {
		var data = HealthServiceTestData.getTestData();
		expect(HealthServiceAdapter.isHealthServiceData(data)).to.be.ok();
	});

	it('should return false null data', function () {
		var data = null;
		expect(HealthServiceAdapter.isHealthServiceData()).not.to.be.ok();
	});

	it('should return false with empty data', function () {
		var data = {};
		expect(HealthServiceAdapter.isHealthServiceData(data)).not.to.be.ok();
	});

	it('should return false with empty RelevantResults', function () {
		var data = {"RelevantResults" : []};
		expect(HealthServiceAdapter.isHealthServiceData(data)).not.to.be.ok();
	});

	it('should return false with corrupt data', function () {
		var data = {"RleevantRseuslt" : 
			[{"HealthServiceDisplayName" : "Not a Health Serivce"}]
		};
		expect(HealthServiceAdapter.isHealthServiceData(data)).not.to.be.ok();
	});
});
