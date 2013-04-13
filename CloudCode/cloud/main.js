/* LegevaktaCloud */

/* Start Section 
 * Fill in lower case versions on save 
 */
Parse.Cloud.beforeSave("HealthService", function(request, response) {
	var healthService = request.object;
	healthService.set("HealthServiceDisplayNameLowerCase", 
		healthService.get("HealthServiceDisplayName").toLowerCase());
});
Parse.Cloud.beforeSave("Municipality", function(request, response) {
	var municipality = request.object;
	municipality.set("NorskLowerCase",
		municipality.get("Norsk").toLowerCase());
});
Parse.Cloud.beforeSave("County", function(request, response) {
	var county = request.object;
	county.set("NorskLowerCase",
		county.get("Norsk").toLowerCase());
});
/* End Section */

/* 
  * Fritekstsøk
*/
Parse.Cloud.define("searchForHealthServices", function(request, response) {

	var searchString = request.params.searchString;	
	var SearchModule = require('cloud/SearchModule.js').SearchModule;
	var searchModule = new SearchModule();

	searchModule.search(searchString,
	{
		success: function(results) {
			response.success(results);
		},
		error: function(error) {
			response.error(error.message);
		}
	});

});
/* End */



/* Creates geoPoints on all objects from lat and lon */
Parse.Cloud.define("createGeoPoints", function(request, response) {
	var HealthService = require('cloud/HealthService.js').HealthService;
	HealthService.setEmptyGeoPointsFromAllObjects({
		success: function(geoPointsCreated) {
			response.success("Succeeded creating " + geoPointsCreated + " geopoints");
		},
		error: function(message) {
			response.error("Could not create geoPoints for some reason: " + message);
		}
	});
	
});

/* Used to bulk fill in lower case versions of display names */
Parse.Cloud.define("fixLowerCaseHealthServiceDisplayNames", function(request, response) {

	var query = new Parse.Query("HealthService");
	query.doesNotExist("HealthServiceDisplayNameLowerCase");
	query.limit(25);
	query.find({
		success: function(results) {
			if(results.length == 0)
				response.success("done");
			console.log("how many results: " + results.length);
			for(i=0;i<results.length;i++) {
				var thisObject = results[i];
				var displayName = thisObject.get("HealthServiceDisplayName");
				var displayNameLowerCase = displayName.toLowerCase();
				thisObject.set("HealthServiceDisplayNameLowerCase", displayNameLowerCase);
				thisObject.save();
			}
			response.success("did " + results.length);
		},
		error: function(error) {
			response.error(error.message);
		}
	});
});

/* Used to bulk fill in lower case versions of Norwegian display names */
Parse.Cloud.define("fixLowerCaseMunicipalityNorsk", function(request, response) {
	var query = new Parse.Query("Municipality");
	query.doesNotExist("NorskLowerCase");
	query.limit(7);
	// query.equalTo("Fylkenummer", "20");
	query.find({
		success:function(results) {
			if(results.length == 0)
				response.success("done");
			else {
				console.log("how many results: " + results.length);
				for(i=0;i<results.length;i++) {
					var thisObject = results[i];
					var norsk = thisObject.get("Norsk");
					var norskLowerCase = norsk.toLowerCase();
					thisObject.set("NorskLowerCase", norskLowerCase);
					thisObject.save();
				}
				response.success("did " + results.length);
			}
		},
		error: function(error) {
			response.error(error.message);
		}
	});
});

/* Used to bulk fill in lower case versions of Norwegian display names */
Parse.Cloud.define("fixLowerCaseCountyNorsk", function(request, response) {
	var query = new Parse.Query("County");
	query.doesNotExist("NorskLowerCase");
	query.limit(7);
	query.find({
		success: function(results) {
			if(results.length == 0)
				response.success("done");
			else {
				console.log("how many results: " + results.length);
				for (i=0;i<results.length;i++) {
					var thisObject = results[i];
					var norsk = thisObject.get("Norsk");
					var norskLowerCase = norsk.toLowerCase();
					thisObject.set("NorskLowerCase", norskLowerCase);
					thisObject.save();
				}
				response.success("did " + results.length);
			}
		},
		error: function(error) {
			response.error(error.message);
		}
	});
});
