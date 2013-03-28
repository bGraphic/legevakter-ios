/* Adapter to the API at data.helsenorge.no - Health Services (legevakt) */

// exports.test = function () {
// 	return true;
// }

var HealthServiceAdapter = new function() {
	this.test = function () {
		return true;
	};
}
exports.HealthServiceAdapter = HealthServiceAdapter;