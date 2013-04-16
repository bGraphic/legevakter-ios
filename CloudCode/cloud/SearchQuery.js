/**
 * Rewrite of SearchUtil.js
 */

 function SearchQuery() {
 // 	this.HealthService = Parse.Object.extend("HealthService");
 // 	this.Municipality = Parse.Object.extend("Municipality");
 // 	this.County = Parse.Object.extend("County");
 // 	this.PlaceName = Parse.Object.extend("PlaceName");

 // 	this.keys {
 // 		keyHealthServiceDisplayNameLowerCase : 
 // 	}
 // 	this.keyHealthServiceDisplayNameLowerCase = "HealthServiceDisplayNameLowerCase";
 // 	this.keyMunicipalityNameLowerCase = "NorskLowerCase";
 // 	this.keyCountyNameLowerCase = "NorskLowerCase";
 // 	this.keyPlaceNameDisplayNameLowerCase = "displayNameLowerCase";
 // 	this.keyHealthServiceAppliesToMunicipalityCodes = "";
	// this.keyHealthServiceAppliesToCountyCodes = "";
	// this.keyMunicipalityCode = "";
 }
 SearchQuery.prototype.getHealthServiceNameQuery = function(searchString) {
	var query = new Parse.Query("HealthService");
	query.contains("HealthServiceDisplayNameLowerCase", searchString);
	return query;
 }
 SearchQuery.prototype.getMunicipalityNameQuery = function(searchString) {
 	var query = new Parse.Query("Municipality");
 	query.startsWith("NorskLowerCase", searchString);
 	return query;
 }
 SearchQuery.prototype.getCountyNameQuery = function(searchString) {
 	var query = new Parse.Query("County");
 	query.startsWith("NorskLowerCase", searchString);
 	return query;
 }
 SearchQuery.prototype.getPlaceNameQuery = function(searchString) {
 	var query = new Parse.Query("PlaceName");
 	query.startsWith("displayNameLowerCase", searchString);
 	query.limit(25); // somewhat arbitrary limit - discuss
 	return query;
 }
 SearchQuery.prototype.getHealthServicesInMunicipalityQuery = function(municipality) {
 	var query = new Parse.Query("HealthService");
 	var municipalityCode = municipality.get("Kommunenummer");
 	if (municipalityCode.length < 4)
 		municipalityCode = "0" + municipalityCode;
 	query.contains("AppliesToMunicipalityCodes", municipalityCode);
 	return query;
 }
 SearchQuery.prototype.getHealthServicesInCountyQuery = function(county) {
 	var query = new Parse.Query("HealthService");
 	var countyCode = county.get("Fylkenummer");
 	if (countyCode.length < 2)
 		countyCode = "0" + countyCode;
 	query.contains("AppliesToCountyCodes", countyCode);
 	return query;
 }
 SearchQuery.prototype.getHealthServicesInPlaceNameQuery = function(placeName) {
 	var query = new Parse.Query("HealthService");
 	var municipalityCode = placeName.get("municipalityCode").toString();
 	if (municipalityCode.length < 4)
 		municipalityCode = "0" + municipalityCode;
 	query.contains("AppliesToMunicipalityCodes", municipalityCode);
 	return query;
 }
 SearchQuery.prototype.getMunicipalityByPlaceNameQuery = function(placeName) {
 	var municipalityCode = placeName.get("municipalityCode").toString();
 	var query = new Parse.Query("Municipality");
 	query.equalTo("Kommunenummer", municipalityCode);
 	return query;
 }
 module.exports = SearchQuery;