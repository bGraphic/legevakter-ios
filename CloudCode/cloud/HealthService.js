var HealthService = Parse.Object.extend("HealthService", {
	// Instance methods
	setGeoPointFromMyLatLons: function() {
		var lat = this.get("HealthServiceLatitude");
		var lon = this.get("HealthServiceLongitude");
		if (lat && lon) {
			var geoPoint = new Parse.GeoPoint(lat,lon);
			this.set("geoPoint", geoPoint);
			this.save();	
		}
	}
}, {
	// Class methods
	allObjectsWithEmptyGeoPoint: function(response) {
		var query = new Parse.Query("HealthService");
		query.limit(999); // max query size
		var geoPoint = new Parse.GeoPoint(0,0);
		query.withinKilometers("geoPoint", geoPoint, 1);
		query.find({
			success: function(results) {
				response.success(results);
			},
			error: function(error) {
				response.error("Error retrieving objects: " + error.message);
			}
		});

	},
	setGeoPointsFromLatLons: function(objects, response) {
		var count = 0;
		for (i=0;i<objects.length;i++) {
			var object = objects[i];
			object.setGeoPointFromMyLatLons();
			object.save();
			count++;
		}
		response.success(count);
	},
	setEmptyGeoPointsFromAllObjects: function(response) {
		HealthService.allObjectsWithEmptyGeoPoint({
			success: function(objects) {
				if(objects.length > 0) {
					HealthService.setGeoPointsFromLatLons(objects, {
						success: function(count) {
							response.success(count);
						},
						error: function(message) {
							response.error(message);
						}
					});	
				} else {
					response.error("0 objects");
				}
				
			},
			error: function(message) {
				response.error(message);
			}
		});
	}

});
exports.HealthService = HealthService;