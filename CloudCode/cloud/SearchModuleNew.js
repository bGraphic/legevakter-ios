/**
 * SearchModule.js - Parse Cloud Module for "Legevakter"
 * 
 * Copyright: Tom Erik Støwer 2013
 * E-mail: testower@gmail.com
 *
 * Usage:
 */

/*
 * Keep a module-wide private pointer to self (to avoid scope issues)
 */
var _this;

/**
 * Constructur for SearchModule
 * Possible options:
 *
 *
 */
function SearchModule (options) {
	// Copy self to module-wide pointer
	_this = this;

	// Reserve a pointer for response
	this.response;

	// Initialize options
	this.searchString = options.searchString.toLowerCase();
	this.skip = options.skip || 0;

	// Initialize dependencies
	var SearchQuery = require('cloud/SearchQuery.js');
	this.searchQuery = new SearchQuery();
	var SearchPromise = require('cloud/SearchPromise.js');
	this.searchPromise = new SearchPromise();

	// Initialize the call stack (determines order of search)
  	this.callStack = [
		_this.searchCountyNames,
		_this.searchMunicipalityNames,
		_this.searchHealthServiceNames
	];

	// Initialize arrays that will hold search results
	this.searchStringInNameHealthServices = [];
	this.searchStringInLocationNameHealthServices = [];
}

/**
 *	Public search method - starts the search from top of the call stack
 */
SearchModule.prototype.search = function (response) {
	_this.response = response;
	_this.executeFromTopOfStack();
}

/**
 * Private methods
 */
SearchModule.prototype.addToLocationNameResults = function(results) {
	_this.searchStringInLocationNameHealthServices.push.apply(
		_this.searchStringInLocationNameHealthServices, results);
}

SearchModule.prototype.searchSuccess = function () {
	var results = {
		searchStringInNameHealthServices: _this.searchStringInNameHealthServices,
		searchStringInLocationNameHealthServices: _this.searchStringInLocationNameHealthServices
	};
	_this.response.success(results);
}

SearchModule.prototype.searchError = function (error) {
	if (!error)
		error = new Error("Unknown error");
	_this.response.error(error);
}

SearchModule.prototype.executeFromTopOfStack = function () {
	if (_this.callStack.length) {
		var fn = _this.callStack.pop();
		fn();	
	} else {
		_this.searchSuccess();
	}
}

SearchModule.prototype.searchHealthServiceNames = function () {
	var query = _this.searchQuery.getHealthServiceNameQuery(_this.searchString);
	var callback = function (healthServices) {
		_this.searchStringInNameHealthServices = healthServices;
		_this.executeFromTopOfStack();
	};
	var error = function() {
		_this.searchError(new Error("Error promising health services by names."));
	};
	var promise = _this.searchPromise.getPromise();
	promise(query, callback, error);
}

SearchModule.prototype.searchMunicipalityNames = function () {
	var query = _this.searchQuery.getMunicipalityNameQuery(_this.searchString);
	var callback = function (municipalities) {
		_this.searchHealthServicesInMunicipality(municipalities, [], {
			success: function(results) {
				_this.addToLocationNameResults(results);
				_this.executeFromTopOfStack();
			},
			error: function(error) {
				_this.searchError(error);
			}
		});
	};
	var error = function() {
		_this.searchError(new Error("Error promising municipalities by name"));
	};
	var promise = _this.searchPromise.getPromise();
	promise(query, callback, error);
}

SearchModule.prototype.searchHealthServicesInMunicipality = function(municipalities, results, response) {
	if (municipalities.length == 0)
		response.success(results);
	else {
		var municipality = municipalities.pop();
		var query = _this.searchQuery.getHealthServicesInMunicipalityQuery(municipality);

		var callback = function(healthServices) {
			var locationNameHit = {
				locationName: municipality.get("Norsk") + " i " + municipality.get("Fylke"),
				locationType: "municipality",
				healthServices: healthServices
			};
			results.push(locationNameHit);

			_this.searchHealthServicesInMunicipality(municipalities, results, response);
		};

		var error = function (error) {
			response.error(error);
		};

		var promise = _this.searchPromise.getPromise();
		promise(query, callback, error);
	}
}

SearchModule.prototype.searchCountyNames = function() {
	var query = _this.searchQuery.getCountyNameQuery(_this.searchString);
	var callback = function (counties) {
		_this.searchHealthServicesInCounty(counties, [], {
			success: function (results) {
				_this.addToLocationNameResults(results);
				_this.executeFromTopOfStack();
			},
			error: function (error) {
				_this.searchError(error);
			}
		});
	};
	var error = function () {
		_this.searchError(new Error("Error promising counties by name"));
	};
	var promise = _this.searchPromise.getPromise();
	promise(query, callback, error);
}

SearchModule.prototype.searchHealthServicesInCounty = function(counties, results, response) {
		if (counties.length == 0)
			response.success(results);
		else {
			var county = counties.pop();
			var query = _this.searchQuery.getHealthServicesInCountyQuery(county);

			var callback = function(healthServices) {
				var locationNameHit = {
					locationName: county.get("Norsk"),
					locationType: "county",
					healthServices: healthServices
				};
				results.push(locationNameHit);

				_this.searchHealthServicesInCounty(counties, results, response);
			};

			var error = function (error) {
				response.error(error);
			};

			var promise = _this.searchPromise.getPromise();
			promise(query, callback, error);
		}
	};

module.exports = SearchModule;