/* LegevaktaCloud */

var HealthService = require('cloud/HealthService.js').HealthService;

/* Creates geoPoints on all objects from lat and lon */
Parse.Cloud.define("createGeoPoints", function(request, response) {
	
	HealthService.setEmptyGeoPointsFromLatLons(HealthService.allObjects);
	response.success("Finished creating geopoints");
});
