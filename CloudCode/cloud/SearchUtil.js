
/*
 * Utility class for 3rd generation Search Module
 */
var SearchUtil = function() {

	var getHealthServiceNameQuery = function(searchString) {
		var query = new Parse.Query("HealthService");
		query.contains("HealthServiceDisplayNameLowerCase", searchString);
		return query;
	};

	var getMunicipalityNameQuery = function(searchString) {
		var query = new Parse.Query("Municipality");
		query.startsWith("NorskLowerCase", searchString);
		return query;
	};

	var getCountyNameQuery = function(searchString) {
		var query = new Parse.Query("County");
		query.startsWith("NorskLowerCase", searchString);
		return query;
	};

	var getPlaceNameQuery = function(searchString) {
		var query = new Parse.Query("PlaceName");
		query.startsWith("displayNameLowerCase", searchString);
		query.limit(25); // somewhat arbitrary limit - discuss
		return query;
	};

	var getHealthServicesInMunicipalityQuery = function(municipality) {
		var query = new Parse.Query("HealthService");
		var municipalityCode = municipality.get("Kommunenummer");
		if (municipalityCode.length < 4)
			municipalityCode = "0" + municipalityCode;
		query.contains("AppliesToMunicipalityCodes", municipalityCode);
		return query;
	};

	var getHealthServicesInCountyQuery = function(county) {
		var query = new Parse.Query("HealthService");
		var countyCode = county.get("Fylkenummer");
		if (countyCode.length < 2)
			countyCode = "0" + countyCode;
		query.contains("AppliesToCountyCodes", countyCode);
		return query;
	};

	var getHealthServicesInPlaceNameQuery = function(placeName) {
		var query = new Parse.Query("HealthService");
		var municipalityCode = placeName.get("municipalityCode");
		if (municipalityCode.length < 4)
			municipalityCode = "0" + municipalityCode;
		else
			municipalityCode += "";
		query.contains("AppliesToMunicipalityCodes", municipalityCode);
		return query;
	};

	var recursiveHealthServicesInMunicipalityQuery = function(util, municipalities, results, response) {
		if (municipalities.length == 0)
			response.success(results);
		else {
			var municipality = municipalities.pop();
			var query = util.getHealthServicesInMunicipalityQuery(municipality);

			var callBack = function(healthServices) {
				var locationNameHit = {
					locatioName: municipality.get("Norsk"),
					locationType: "municipality",
					healthServices: healthServices
				};
				results.push(locationNameHit);

				if(municipalities.length > 0) {
					util.recursiveHealthServicesInMunicipalityQuery(util, municipalities, results, response);
				} else {
					response.success(results);
				}
			};

			Parse.Promise.when(query.find()).then(callBack, function(error) {
				console.log("Error in 'recursiveHealthServicesInMunicipalityQuery': " + error);
				response.error(error);
			});			
		}
	};

	var recursiveHealthServicesInCountyQuery = function(util, counties, results, response) {
		if (counties.length == 0)
			response.success(results);
		else {
			var county = counties.pop();
			var query = util.getHealthServicesInCountyQuery(county);

			var callBack = function(healthServices) {
				var locationNameHit = {
					locationName: county.get("Norsk"),
					locationType: "county",
					healthServices: healthServices
				};
				results.push(locationNameHit);

				if (counties.length > 0) {
					util.recursiveHealthServicesInCountyQuery(util, counties, results, response);
				} else {
					response.success(results);
				}
			}

			Parse.Promise.when(query.find()).then(callBack, function(error) {
				console.log("Error in 'recursiveHealthServicesInCountyQuery': " + error);
				response.error(error);
			});			
		}
	};

	var recursiveHealthServicesInPlaceNameQuery = function(util, placeNames, results, response) {
		if (placeNames.length == 0) {
			response.success(results);
		} else {
			var placeName = placeNames.pop();
			var query = util.getHealthServicesInPlaceNameQuery(placeName);

			var callBack = function(healthServices) {
				var locationNameHit = {
					locationName: placeName.get("displayName"),
					locationType: "place",
					healthServices: healthServices
				};
				results.push(locationNameHit);

				if (placeNames.length > 0) {
					util.recursiveHealthServicesInPlaceNameQuery(util, placeNames, results, response);
				} else {
					response.success(results);
				}
			}
		}

		Parse.Promise.when(query.find()).then(callBack, function(error) {
			console.log("Error in 'recursiveHealthServicesInPlaceNameQuery': " + error);
			response.error(error);
		});
	};

	return {
		getHealthServiceNameQuery					: getHealthServiceNameQuery,
		getMunicipalityNameQuery					: getMunicipalityNameQuery,
		getCountyNameQuery							: getCountyNameQuery,
		getPlaceNameQuery							: getPlaceNameQuery,
		getHealthServicesInMunicipalityQuery		: getHealthServicesInMunicipalityQuery,
		getHealthServicesInCountyQuery				: getHealthServicesInCountyQuery,
		getHealthServicesInPlaceNameQuery			: getHealthServicesInPlaceNameQuery,
		recursiveHealthServicesInMunicipalityQuery	: recursiveHealthServicesInMunicipalityQuery,
		recursiveHealthServicesInCountyQuery		: recursiveHealthServicesInCountyQuery,
		recursiveHealthServicesInPlaceNameQuery		: recursiveHealthServicesInPlaceNameQuery
	};
};
exports.SearchUtil = SearchUtil;