


function SearchPromise() {

}

SearchPromise.prototype.getPromise = function() {
	return function(query, callback, error) {
		Parse.Promise.when(query.find()).then(callback, error);
	};
}
module.exports = SearchPromise;