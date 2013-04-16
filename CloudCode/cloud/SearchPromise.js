


function SearchPromise() {

}

SearchPromise.prototype.getPromise = function(query, callback, error) {
	var promise = function(query, callback, error) {
		Parse.Promise.when(query.find()).then(callback, error);
	};
	return promise;
}
exports.SearchPromise = SearchPromise;