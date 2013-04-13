
var SSRImporter = function() {
	var importFromFile = function(fileName, response) {
		var fs = require("fs");
		fs.readFile(fileName, 'utf8', function(err, data) {
			if(err) {
				response.error(err);
			} else {

				var Parse = require('parse').Parse;
				Parse.initialize("b8miWZyVIuwxB47cjOTa6ik6B5DiaO4bnZeVQgNA", "Xo3H0UKj36YYTZCo3fNmIvaOP5eAwIdr5XMUeZkH");
				var parsedData = JSON.parse(data);

				console.log('Data entries: ' + parsedData.features.length);

				var qualifiedPlacesCount = 0;
				var placeNames = [];

				parsedData.features.forEach(function(place) {

					var nameTypeGroup = place.properties.nty_gruppenr;

					if (nameTypeGroup == 5) {

						qualifiedPlacesCount++;

						var ssrID = place.properties.enh_ssr_id;
						var nameTypeCode = place.properties.enh_navntype;
						var placeDisplayName = place.properties.enh_snavn;
						var municipalityCode = place.properties.enh_komm;
						var coordinates = place.geometry.coordinates;

						var log = placeDisplayName
							+ '\n Kommunenummer: ' + municipalityCode 
							+ '\n Navnetype: ' + nameTypeCode
							+ '\n Koordinater ' + coordinates;
						
						// console.log(log);

						var placeName = new Parse.Object("PlaceName");
						var geoPoint = new Parse.GeoPoint(coordinates);
						placeName.set("geoPoint", geoPoint);
						placeName.set("municipalityCode", municipalityCode);
						placeName.set("ssrID", ssrID);
						placeName.set("displayName", placeDisplayName);
						placeName.set("displayNameLowerCase", placeDisplayName.toLowerCase());

						placeNames.push(placeName);
						
					}
				});

				console.log('qualifiedPlacesCount: ' + qualifiedPlacesCount);

				Parse.Object.saveAll(placeNames, {
					success: function(placeNames) {
						response.success("Saved " + placeNames.length + " place names!");
					},
					error: function(error) {
						response.error(error);
					}
				});
				
			}
		});
	};

	return {
		importFromFile: importFromFile
	};
}
exports.SSRImporter = SSRImporter;

/*
var SSRImporter = function() {

	var importPlaceNamesFromURL = function(request, response) {
		console.log("entered importPlaceNamesFromURL");
		Parse.Cloud.httpRequest({
			url: request.importURL,
			success: function(httpResponse) {
				console.log("before calling importPlaceNamesFromData");
				this.importPlaceNamesFromData(httpResponse.data);
				response.success();
			},
			error: function(httpResponse) {
				console.log("Parse.Cloud.httpRequest failed with status: " + httpResponse.status);
				response.error(httpResponse.status);
			}
		});

	};

	var importPlaceNamesFromData = function(data) {

		var PlaceName = Parse.Object.extend('PlaceName');

		parsedData = JSON.parse(data);
		console.log('Data entries: ' + parsedData.features.length);

		qualifiedPlacesCount = 0;

		parsedData.features.forEach(function(place) {

			
			var nameTypeGroup = place.properties.nty_gruppenr;

			if (nameTypeGroup == 5) {

				qualifiedPlacesCount++;

				var nameTypeCode = place.properties.enh_navntype;
				var placeDisplayName = place.properties.enh_snavn;
				var municipalityCode = place.properties.enh_komm;
				var coordinates = place.geometry.coordinates;

				var log = placeDisplayName
					+ '\n Kommunenummer: ' + municipalityCode 
					+ '\n Navnetype: ' + nameTypeCode
					+ '\n Koordinater ' + coordinates;
				
				// console.log(log);

				var placeName = new PlaceName();

				var geoPoint = new Parse.GeoPoint(coordinates);

				placeName.set("geoPoint", geoPoint);
				placeName.set("displayName", placeDisplayName);
				placeName.set("municipalityCode", municipalityCode);

				placeName.save({}, {
					success: function(placeNameAgain) {
						// console.log("Saved " + placeNameAgain.get("displayName"));
					}
				});
				
			}
		});


	};

	return {
		importPlaceNamesFromURL: importPlaceNamesFromURL,
		importPlaceNamesFromData: importPlaceNamesFromData
	};

}
exports.SSRImporter = SSRImporter;
 */