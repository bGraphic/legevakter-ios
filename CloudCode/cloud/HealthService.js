var HealthService = Parse.Object.extend("HealthService", {
	// Instance methods
	latitude: function() {
		return this.get("HealthServiceLatitude");
	},

	longitude: function() {
		return this.get("HealthServiceLongitude");
	},

	geoPoint: function() {
		return this.get("geoPoint");
	},

	setGeoPoint: function(geoPoint) {
		this.set("geoPoint", geoPoint);
	},

	setGeoPointWithLatLon: function(lat,lon) {
		var geoPoint = new Parse.GeoPoint(lat,lon);
		this.setGeoPoint(geoPoint);
	},

	setGeoPointFromMyLatLons: function() {
		if (this.latitude != null && this.longitude != null)
			this.setGeoPointWithLatLon(this.latitude, this.longitude);
	}
}, {
	// Class methods
	allObjects: function() {
		var query = new Parse.Query(this);
		query.limit(1000); // max query size
		query.find({
			success: function(objects) {
				return objects;
			}
		})
	},
	setGeoPointsFromLatLons: function(objects) {
		for (i=0;i<objects.length;i++) {
			var object = objects[i];
			object.setGeoPointFromMyLatLons();
			object.save();
		}
	},
	setEmptyGeoPointsFromLatLons: function(objects) {
		for(i=0;objects.length;i++) {
			var object = objects[i];
			if (object.geoPoint != null) {
				object.setGeoPointFromMyLatLons();
				object.save();
			}
		}
	}
});
exports.HealthService = HealthService;