/* LegevaktaCloud */

var HealthService = require('cloud/HealthService.js').HealthService;

Parse.Cloud.define("searchForHealthServices", function(request, response) {

	var healthServices = [];
	var searchString = request.params.searchString;

	var query = new Parse.Query("HealthService");
	query.contains("HealthServiceDisplayName", searchString);
	query.find({
		success: function(services) {
			response.success(services);
		}
	});
});



/* Import place names from data source (SSR) */
Parse.Cloud.define("importPlaceNames", function(request, response) {

	var SSRImporterModule = require('cloud/SSRImporter.js').SSRImporter;	
	var SSRImporter = new SSRImporterModule();

	var URL = "http://data.kartverket.no/stedsnavn/GeoJSON/Fylker/03_oslo_stedsnavn.geojson";
	SSRImporter.importPlaceNamesFromURL({importURL: URL}, {
		success: function() {
			response.success("Started importing without errors\n");
		},
		error: function(status) {
			response.error("Failed with status: " + status);
		}
	});

	response.success();

});


/* Creates geoPoints on all objects from lat and lon */
Parse.Cloud.define("createGeoPoints", function(request, response) {
	
	HealthService.setEmptyGeoPointsFromLatLons(HealthService.allObjects);
	response.success("Finished creating geopoints");
});