
/*
 * This is the 3rd generation search module.
 *
 * Returns a dictionary organized as follows:
 * 
 * { searchStringInNameHealthServices: [healthService, healthService, healthService, ...],
 *   searchStringInLocationNameHealthServices:
 *   [
 *     {
 *       locationName: Horten
 *       locationType: place
 *       healthServices: [healthService, healthService]
 *     },
 *     {
 *       locationName: Hemsedal
 *       locationType: place
 *       healthServices: [healthService]
 *     },
 *     {
 *      locationName: Hvaler
 *      locationType: muncipality
 *      healthServices: [healthService]
 *     }, 
 *     {
 *       locationName: Hordaland
 *       locationType: county
 *       healthServices:  [healthService, healthService, healthService, healthService]
 *     }
 *   ]
 * }
 *
 */

var SearchModule = function() {

	var search = function(searchString, response) {
		var searchString = searchString.toLowerCase(),
			SearchUtil = require('cloud/SearchUtil.js').SearchUtil,
			util = new SearchUtil();

		var searchStringInNameHealthServices = [],
			searchStringInLocationNameHealthServices = [];

		var healthServiceNameQuery = util.getHealthServiceNameQuery(searchString);
		Parse.Promise.when(healthServiceNameQuery.find()).then(
			function (healthServices) {
			searchStringInNameHealthServices = healthServices;

			var municipalityNameQuery = util.getMunicipalityNameQuery(searchString);
			Parse.Promise.when(municipalityNameQuery.find()).then(
				function (municipalities) {

				console.log("Found municipalities: " + municipalities.length);

				util.recursiveHealthServicesInMunicipalityQuery(util, municipalities, [], {
					success: function(results) {
						searchStringInLocationNameHealthServices.push.apply(
										searchStringInLocationNameHealthServices,
										results);

						var countyNameQuery = util.getCountyNameQuery(searchString);
						Parse.Promise.when(countyNameQuery.find()).then(
							function (counties) {

							console.log("Found counties: " + counties.length);

							util.recursiveHealthServicesInCountyQuery(util, counties, [], {
								success: function(results) {
									searchStringInLocationNameHealthServices.push.apply(
										searchStringInLocationNameHealthServices,
										results);

									var placeNameQuery = util.getPlaceNameQuery(searchString);
									Parse.Promise.when(placeNameQuery.find()).then(
										function (placeNames) {

										console.log("Found placeNames: " + placeNames.length);

										util.recursiveHealthServicesInPlaceNameQuery(util, placeNames, [], {
											success: function(results) {
												searchStringInLocationNameHealthServices.push.apply(
													searchStringInLocationNameHealthServices,
													results);

												response.success({
													searchStringInNameHealthServices: searchStringInNameHealthServices,
													searchStringInLocationNameHealthServices: searchStringInLocationNameHealthServices
												});
											},
											error: function(error) {
												response.error(error);
											}
										});
									}, function (error) {
										console.log("Error in 'countyNameQuery': " + error);
										response.error(error);
									});
								},
								error: function(error) {
									response.error(error);
								}
							});
						}, function(error) {
							console.log("Error in 'countyNameQuery': " + error);
							response.error(error);
						});
					},
					error: function(error) {
						response.error(error);
					}
				});
			}, function (error) {
				console.log("Error in 'municipalityNameQuery': " + error);
				response.error(error);
			});

		}, function (error) {
			console.log("Error in 'healthServiceNameQuery': " + error);
			response.error(error);
		});
	};


	return {
		search: search
	};
};
exports.SearchModule = SearchModule;