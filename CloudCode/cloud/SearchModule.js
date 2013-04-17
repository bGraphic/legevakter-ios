/**
 * SearchModule.js - Parse Cloud Module for "Legevakter"
 *
 * Free Text Search for health services
 * Searches in health service, county, municipality and place names
 * 
 * Copyright: Tom Erik Støwer 2013
 * E-mail: testower@gmail.com
 *
 */

/*
 * Keep a module-wide 'private' pointer to self (to avoid scope confusion)
 */
var _this;

/**
 * Constructur for SearchModule
 * 
 * Accepts a hashmap of options:
 *
 * @required
 *   - searchString: The string to search for
 *  
 * @optional options coming soon:
 *   - pagination -> get results from 100–200
 *   - exclude options -> search only in place names, or only in counties and municipalities
 *   - ...
 *
 */
function SearchModule (options) {
	// Copy self to module-wide pointer
	_this = this;

	// Initialize options
	_this.searchString = options.searchString.toLowerCase();

	// Initialize SearchQuery (handles all Parse.Query-specific stuff)
	var SearchQuery = require('cloud/SearchQuery.js');
	_this.searchQuery = new SearchQuery();


	// Initialize the call stack (determines order of search)
  	_this.callStack = [
  		_this._searchPlaceNames,
		_this._searchCountyNames,
		_this._searchMunicipalityNames,
		_this._searchHealthServiceNames
	];

	// Initialize arrays that will hold search results
	_this.searchStringInNameHealthServices = [];
	_this.searchStringInLocationNameHealthServices = [];
}

/**
 *	Public search method - starts the search from top of the call stack
 */
SearchModule.prototype.search = function (response) {
	_this.response = response;
	_this._executeFromTopOfStack();
}

/**
 * Private methods
 */

// If there are functions left in the stack, pop off the top one and execute it
SearchModule.prototype._executeFromTopOfStack = function () {
	if (_this.callStack.length) {
		var fn = _this.callStack.pop();
		fn();	
	} else {
		_this._searchSuccess();
	}
}

// Last method to be called before responding to the user (given no previous errors)
SearchModule.prototype._searchSuccess = function () {
	var results = {
		searchStringInNameHealthServices: _this.searchStringInNameHealthServices,
		searchStringInLocationNameHealthServices: _this.searchStringInLocationNameHealthServices
	};
	_this.response.success(results);
}

// An error occurred somewhere. This method responds with this error.
SearchModule.prototype._searchError = function (error) {
	if (!error)
		error = new Error("Unknown error");
	_this.response.error(error);
}

// Add some set of results to the locationNameResults array
SearchModule.prototype._addToLocationNameResults = function(results) {
	_this.searchStringInLocationNameHealthServices.push.apply(
		_this.searchStringInLocationNameHealthServices, results);
}

/**
 * The search implementation
 */
SearchModule.prototype._searchHealthServiceNames = function () {
	_this.searchQuery.setHealthServiceNameQuery(_this.searchString);
	var callback = function (healthServices) {
		_this.searchStringInNameHealthServices = healthServices;
		_this._executeFromTopOfStack();
	};
	var error = function() {
		var message = "Error promising health services by names.";
		console.log(message);
		_this._searchError(new Error(message));
	};
	_this.searchQuery.executeQueryWithCallbackAndError(callback, error);
}

SearchModule.prototype._searchMunicipalityNames = function () {
	_this.searchQuery.setMunicipalityNameQuery(_this.searchString);
	var callback = function (municipalities) {
		_this._searchHealthServicesInMunicipality(municipalities, [], {
			success: function(results) {
				_this._addToLocationNameResults(results);
				_this._executeFromTopOfStack();
			},
			error: function(error) {
				_this._searchError(error);
			}
		});
	};
	var error = function() {
		var message = "Error promising municipalities by name.";
		console.log(message);
		_this._searchError(new Error(message));
	};
	_this.searchQuery.executeQueryWithCallbackAndError(callback, error);
}

SearchModule.prototype._searchHealthServicesInMunicipality = function(municipalities, results, response) {
	if (municipalities.length == 0)
		response.success(results);
	else {
		var municipality = municipalities.pop();
		
		_this.searchQuery.setHealthServicesInMunicipalityQuery(municipality);
		var callback = function(healthServices) {
			var locationNameHit = {
				locationName: municipality.get("Norsk") + " i " + municipality.get("Fylke"),
				locationType: "municipality",
				healthServices: healthServices
			};
			results.push(locationNameHit);

			// recursive call
			_this._searchHealthServicesInMunicipality(municipalities, results, response);
		};
		var error = function (error) {
			response.error(error);
		};
		_this.searchQuery.executeQueryWithCallbackAndError(callback, error);
	}
}

SearchModule.prototype._searchCountyNames = function() {
	_this.searchQuery.setCountyNameQuery(_this.searchString);
	var callback = function (counties) {
		_this._searchHealthServicesInCounty(counties, [], {
			success: function (results) {
				_this._addToLocationNameResults(results);
				_this._executeFromTopOfStack();
			},
			error: function (error) {
				_this._searchError(error);
			}
		});
	};
	var error = function () {
		var message = "Error promising counties by name.";
		console.log(message);
		_this._searchError(new Error(message));
	};
	_this.searchQuery.executeQueryWithCallbackAndError(callback, error);
}

SearchModule.prototype._searchHealthServicesInCounty = function(counties, results, response) {
	if (counties.length == 0)
		response.success(results);
	else {
		var county = counties.pop();
		_this.searchQuery.setHealthServicesInCountyQuery(county);
		var callback = function(healthServices) {
			var locationNameHit = {
				locationName: county.get("Norsk"),
				locationType: "county",
				healthServices: healthServices
			};
			results.push(locationNameHit);

			// recursive call
			_this._searchHealthServicesInCounty(counties, results, response);
		};
		var error = function (error) {
			response.error(error);
		};
		_this.searchQuery.executeQueryWithCallbackAndError(callback, error);
	}
}

SearchModule.prototype._searchPlaceNames = function() {
	_this.searchQuery.setPlaceNameQuery(_this.searchString);
	var callback = function (placeNames) {
		_this._searchHealthServicesInPlaceName(placeNames, [], {
			success: function (results) {
				_this._addToLocationNameResults(results);
				_this._executeFromTopOfStack();
			},
			error: function (error) {
				_this._searchError(error);
			}
		});
	};
	var error = function () {
		var message = "Error promising place names by name.";
		console.log(message);
		_this._searchError(new Error(message));
	};
	_this.searchQuery.executeQueryWithCallbackAndError(callback, error);
}

SearchModule.prototype._searchHealthServicesInPlaceName = function(placeNames, results, response) {
	if (placeNames.length == 0) {
		response.success(results);
	} else {
		var placeName = placeNames.pop();
		var municipalityCode = placeName.get("municipalityCode").toString();
		_this.searchQuery.setMunicipalityByCodeQuery(municipalityCode);
		var callback = function (municipalities) {
			if (!municipalities.length)
				response.error(new Error("No municipalities by that code"));

			var municipality = municipalities[0];

			if(!municipality) {
				var message = "Failed to retrieve municipality by code.";
				console.log(message);
				_this._searchError(new Error(message));
			}

			_this._searchHealthServicesInPlaceNameMunicipality(placeName, municipality, {
				success: function(localResults) {
					results.push(localResults);

					// recursive call
					_this._searchHealthServicesInPlaceName(placeNames, results, response);
				},
				error: function (error) {
					_this._searchError(error);
				}
			});
		};
		var error = function() {
			var message = "Error promising municipality by code";
			console.log(message);
			_this._searchError(new Error(message));
		};
		_this.searchQuery.executeQueryWithCallbackAndError(callback, error);
	}
}

SearchModule.prototype._searchHealthServicesInPlaceNameMunicipality = function(placeName, municipality, response) {
	_this.searchQuery.setHealthServicesInPlaceNameQuery(placeName);
	var callback = function(healthServices) {
		var locationNameHit = {
			locationName: placeName.get("displayName")
				+ " i "
				+ municipality.get("Norsk")
				+ ", "
				+ municipality.get("Fylke"),
			locationType: "place",
			healthServices: healthServices
		};
		response.success(locationNameHit);
	};
	var error = function() {
		var message = "Error in 'searchHealthServicesInPlaceNameMunicipality'";
		console.log(message);
		_this._searchError(new Error(message));
	};
	_this.searchQuery.executeQueryWithCallbackAndError(callback, error);
}

/**
 * Finally export this module :-)
 */
module.exports = SearchModule;