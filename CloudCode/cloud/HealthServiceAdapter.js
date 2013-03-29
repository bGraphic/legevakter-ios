/* Adapter to the API at data.helsenorge.no - Health Services (legevakt) */

var HealthServiceAdapter = new function() {

	this.isHealthServiceData = function(data) {
		var isHealthServiceData = false;

		if (data
			&& data.RelevantResults 
			&& data.RelevantResults[0]
			&& data.RelevantResults[0].HealthServiceDisplayName)
				isHealthServiceData = true;	

		return isHealthServiceData;
	}
}
exports.HealthServiceAdapter = HealthServiceAdapter;
