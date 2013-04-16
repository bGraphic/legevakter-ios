
function SearchModule(options) {
	this.searchString = options.searchString.toLowerCase();
	this.skip = options.skip || 0;

	var SearchQuery = require('cloud/SearchQuery.js');
	this.searchQuery = new SearchQuery();

	var SearchPromise = require('cloud/SearchPromise.js');
	this.searchPromise = new SearchPromise();

	this.searchStringInNameHealthServices = [];
}

SearchModule.prototype.search = function(response) {
	this.response = response;

	this.searchStack = [
		this.searchHealthServiceNames
	]; 

	this.executeFromTopOfStack();
}

SearchModule.prototype.searchSuccess = function() {
	this.response.success(this.searchStringInNameHealthServices);
}

SearchModule.prototype.searchError = function(error) {
	if (!error)
		error = "Unknown error";
	this.response.error(error);
}

SearchModule.prototype.executeFromTopOfStack = function() {
	var fn = this.searchStack.pop();
	fn();
}

SearchModule.prototype.searchHealthServiceNames = function() {
	var query = searchQuery.getHealthServiceNameQuery(this.searchString);
	var module = this;
	var callback = function (healthServices) {
		this.searchStringInNameHealthServices = healthServices;

		if(searchStack) {
			module.executeFromTopOfStack();
		} else {
			module.searchComplete();
		}
	};

	var error = function() {
		module.searchError("Error in searchHealthServiceNames");
	};

	var promise = this.searchPromise(query, callback, error);

	promise.promise();
}

exports.SearchModule = SearchModule;