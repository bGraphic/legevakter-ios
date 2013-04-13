var SearchModule = function() {
	
	var search = function(searchString, response) {

		var healthServices = [];

		searchString = searchString.toLowerCase();

		var healthServiceQuery = (new Parse.Query("HealthService")).contains("HealthServiceDisplayNameLowerCase", searchString);
		

		Parse.Promise.when(healthServiceQuery.find()).then(function(results) {
			healthServices.push.apply(healthServices, results);

			var municipalityQuery = (new Parse.Query("Municipality")).contains("NorskLowerCase", searchString);
			Parse.Promise.when(municipalityQuery.find()).then(function(municipalities) {
		
				var municipalityCodesRegex = "";

				if (municipalities.length > 0) {
					for (i=0;i<municipalities.length;i++) {
						municipalityCode = municipalities[i].get("Kommunenummer");
						if (municipalityCode.length < 4) {
							municipalityCode = "0" + municipalityCode;
						}
						municipalityCodesRegex += municipalityCode;
						if(i < municipalities.length - 1) {
							municipalityCodesRegex += "|";
						}
					}	
				} else {
					municipalityCodesRegex = "ENSURE_NO_MATCH";
				}

				console.log("municipalityCodesRegex: " + municipalityCodesRegex);

				var municipalityCodeQuery = (new Parse.Query("HealthService")).matches("AppliesToMunicipalityCodes", municipalityCodesRegex);
				Parse.Promise.when(municipalityCodeQuery.find()).then(function(results) {
					healthServices.push.apply(healthServices, results);

					var countyQuery = (new Parse.Query("County")).contains("NorskLowerCase", searchString);
					Parse.Promise.when(countyQuery.find()).then(function(counties) {

						var countyCodesRegex = "";

						if (counties.length > 0) {
							for (i=0;i<counties.length;i++) {
								countyCode = counties[i].get("Fylkenummer");
								if(countyCode.length < 2) {
									countyCode = "0" + countyCode;
								}
								countyCodesRegex += countyCode;
								if (i < counties.length - 1) {
									countyCodesRegex += "|";
								}
							}
						} else {
							countyCodesRegex = "ENSURE_NO_MATCH";
						}

						console.log("countyCodesRegex: " + countyCodesRegex);

						var countyCodeQuery = (new Parse.Query("HealthService")).matches("AppliesToCountyCodes", countyCodesRegex);
						Parse.Promise.when(countyCodeQuery.find()).then(function(results) {
							healthServices.push.apply(healthServices, results);

							var placeNameQuery = (new Parse.Query("PlaceName")).contains("displayNameLowerCase", searchString);
							Parse.Promise.when(placeNameQuery.find()).then(function(placeNames) {

								var municipalityCodesRegex = "";

								if (placeNames.length > 0) {
									for (i=0;i<placeNames.length;i++) {
										municipalityCode = placeNames[i].get("municipalityCode");
										if(municipalityCode.length < 4)
											municipalityCode = "0" + municipalityCode;
										municipalityCodesRegex += municipalityCode;
										if (i < placeNames.length - 1)
											municipalityCodesRegex += "|";
									}
								} else {
									municipalityCodesRegex = "ENSURE_NO_MATCH";
								}

								console.log("in placeName municipalityCodesRegex: " + municipalityCodesRegex);

								var municipalityCodeQuery = (new Parse.Query("HealthService")).matches("AppliesToMunicipalityCodes", municipalityCodesRegex);
								Parse.Promise.when(municipalityCodeQuery.find()).then(function(results) {
									healthServices.push.apply(healthServices, results);

									// all queries have finished - time to give something back
									response.success(healthServices);
								});
							});
						});
					});
				});	
			});
		});
	};

	var universalSearch = function(searchString, response) {
		searchString = searchString.toLowerCase();

		var searchStringInNameHealthServices = [];
		var searchStringInMunicipalityNameHealthServices = [];
		var searchStringInCountyNameHealthServices = [];
		var searchStringInPlaceNameHealthServices = [];
		
		var healthServiceQuery = (new Parse.Query("HealthService")).contains("HealthServiceDisplayNameLowerCase", searchString);
		
		Parse.Promise.when(healthServiceQuery.find()).then(function(results) {
			searchStringInNameHealthServices = results;

			var municipalityQuery = (new Parse.Query("Municipality")).contains("NorskLowerCase", searchString);
			Parse.Promise.when(municipalityQuery.find()).then(function(municipalities) {
				var searchModule = new SearchModule();
				var municipalityCodesRegex = searchModule.getMunicipalityCodesRegex(municipalities);
				var municipalityCodeQuery = (new Parse.Query("HealthService")).matches("AppliesToMunicipalityCodes", municipalityCodesRegex);
				Parse.Promise.when(municipalityCodeQuery.find()).then(function(results) {
					searchStringInMunicipalityNameHealthServices = results;

					var countyQuery = (new Parse.Query("County")).contains("NorskLowerCase", searchString);
					Parse.Promise.when(countyQuery.find()).then(function(counties) {
						var searchModule = new SearchModule();
						var countyCodesRegex = searchModule.getCountyCodesRegex(counties);
						var countyCodeQuery = (new Parse.Query("HealthService")).matches("AppliesToCountyCodes", countyCodesRegex);
						Parse.Promise.when(countyCodeQuery.find()).then(function(results) {
							searchStringInCountyNameHealthServices = results;

							var placeNameQuery = (new Parse.Query("PlaceName")).contains("displayNameLowerCase", searchString);
							Parse.Promise.when(placeNameQuery.find()).then(function(placeNames) {
								var searchModule = new SearchModule();
								var municipalityCodesRegex = searchModule.getMunicipalityCodesFromPlaceNamesRegex(placeNames);
								var municipalityCodeQuery = (new Parse.Query("HealthService")).matches("AppliesToMunicipalityCodes", municipalityCodesRegex);
								Parse.Promise.when(municipalityCodeQuery.find()).then(function(results) {
									searchStringInPlaceNameHealthServices = results;

									// done searching - let's wrap it up
									response.success({
										searchStringInNameHealthServices: searchStringInNameHealthServices,
										searchStringInLocationNameHealthServices: {
											searchStringInMunicipalityNameHealthServices: searchStringInMunicipalityNameHealthServices,
											searchStringInCountyNameHealthServices: searchStringInCountyNameHealthServices,
											searchStringInPlaceNameHealthServices: searchStringInPlaceNameHealthServices
										}
									});
								});
							});
						});
					});
				});
			});
		});
	};

	var getMunicipalityCodesRegex = function(municipalities) {
		var municipalityCodesRegex = "";

		if (municipalities.length > 0) {
			for (i=0;i<municipalities.length;i++) {
				municipalityCode = municipalities[i].get("Kommunenummer");
				if (municipalityCode.length < 4) {
					municipalityCode = "0" + municipalityCode;
				}
				municipalityCodesRegex += municipalityCode;
				if(i < municipalities.length - 1) {
					municipalityCodesRegex += "|";
				}
			}	
		} else {
			municipalityCodesRegex = "ENSURE_NO_MATCH";
		}

		return municipalityCodesRegex;
	};

	var getCountyCodesRegex = function(counties) {
		var countyCodesRegex = "";

		if (counties.length > 0) {
			for (i=0;i<counties.length;i++) {
				countyCode = counties[i].get("Fylkenummer");
				if(countyCode.length < 2) {
					countyCode = "0" + countyCode;
				}
				countyCodesRegex += countyCode;
				if (i < counties.length - 1) {
					countyCodesRegex += "|";
				}
			}
		} else {
			countyCodesRegex = "ENSURE_NO_MATCH";
		}

		return countyCodesRegex;
	};

	var getMunicipalityCodesFromPlaceNamesRegex = function(placeNames) {
		var municipalityCodesRegex = "";

		if (placeNames.length > 0) {
			for (i=0;i<placeNames.length;i++) {
				municipalityCode = placeNames[i].get("municipalityCode");
				if(municipalityCode.length < 4)
					municipalityCode = "0" + municipalityCode;
				municipalityCodesRegex += municipalityCode;
				if (i < placeNames.length - 1)
					municipalityCodesRegex += "|";
			}
		} else {
			municipalityCodesRegex = "ENSURE_NO_MATCH";
		}

		return municipalityCodesRegex;		
	};

	return {
		search: search,
		universalSearch: universalSearch,
		getMunicipalityCodesRegex: getMunicipalityCodesRegex,
		getCountyCodesRegex: getCountyCodesRegex,
		getMunicipalityCodesFromPlaceNamesRegex: getMunicipalityCodesFromPlaceNamesRegex
	};
}
exports.SearchModule = SearchModule;