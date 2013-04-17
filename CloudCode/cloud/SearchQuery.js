/**
 * SearchQuery.js - Parse Cloud Module for "Legevakter"
 *
 * Helper module for SearchModule.js - Handles Parse Queries
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
 * Constructur for SearchQuery - Sets up internal state
 */
 function SearchQuery() {

	_this = this;
	_this.query = undefined;

 	_this.HealthService = Parse.Object.extend("HealthService");
 	_this.Municipality = Parse.Object.extend("Municipality");
 	_this.County = Parse.Object.extend("County");
 	_this.PlaceName = Parse.Object.extend("PlaceName");

 	_this.keys = {
 		healthServiceDisplayName    	 	: "HealthServiceDisplayNameLowerCase",
 		municipalityName 					: "NorskLowerCase",
 		countyName 							: "NorskLowerCase",
 		placeNameDisplayName 				: "displayNameLowerCase",
 		appliesToMunicipalityCodes 			: "AppliesToMunicipalityCodes",
 		appliesToCountyCodes 				: "AppliesToCountyCodes",
 		municipalityCode 					: "Kommunenummer",
 		countyCode 							: "Fylkenummer",
 		placeNameMunicipalityCode			: "municipalityCode"
 	};
 }

/**
 * Call this method with callback and error after setting a query type
 * This method unsets the current query after dispatching the query
 */
 SearchQuery.prototype.executeQueryWithCallbackAndError = function(callback, error) {
 	if (_this.query && callback && error)
 		Parse.Promise.when(_this.query.find()).then(callback, error).then(function() {
 			_this.query = undefined;
 		});
 }

 /*
  *	Methods that set the current query
  */

 // Search health service by their display name
 SearchQuery.prototype.setHealthServiceNameQuery = function(searchString) {
	var query = new Parse.Query(_this.HealthService);
	query.contains(_this.keys.healthServiceDisplayName, searchString);
	_this.query = query;
 }

 // Search municipalities by their name
 SearchQuery.prototype.setMunicipalityNameQuery = function(searchString) {
 	var query = new Parse.Query(_this.Municipality);
 	query.startsWith(_this.keys.municipalityName, searchString);
 	_this.query = query;
 }

 // Search municipalities by their numeric code
 SearchQuery.prototype.setMunicipalityByCodeQuery = function(municipalityCode) {
 	var query = new Parse.Query(_this.Municipality);
 	query.equalTo(_this.keys.municipalityCode, municipalityCode);
 	_this.query = query;
 }

 // Search counties by their name
 SearchQuery.prototype.setCountyNameQuery = function(searchString) {
 	var query = new Parse.Query(_this.County);
 	query.startsWith(_this.keys.countyName, searchString);
 	_this.query = query;
 }

 // Search place names by their display name
 SearchQuery.prototype.setPlaceNameQuery = function(searchString) {
 	var query = new Parse.Query(_this.PlaceName);
 	query.startsWith(_this.keys.placeNameDisplayName, searchString);
 	query.limit(25); // somewhat arbitrary limit - discuss
 	_this.query = query;
 }

 // Search health services by applicable municipality
 SearchQuery.prototype.setHealthServicesInMunicipalityQuery = function(municipality) {
 	var query = new Parse.Query(_this.HealthService);
 	var municipalityCode = municipality.get(_this.keys.municipalityCode);
 	if (municipalityCode.length < 4)
 		municipalityCode = "0" + municipalityCode;
 	query.contains(_this.keys.appliesToMunicipalityCodes, municipalityCode);
 	_this.query = query;
 }

 // Search health services by applicable county
 SearchQuery.prototype.setHealthServicesInCountyQuery = function(county) {
 	var query = new Parse.Query(_this.HealthService);
 	var countyCode = county.get(_this.keys.countyCode);
 	if (countyCode.length < 2)
 		countyCode = "0" + countyCode;
 	query.contains(_this.keys.appliesToCountyCodes, countyCode);
 	_this.query = query;
 }

 // Search health services by applicable municipality for a place name
 SearchQuery.prototype.setHealthServicesInPlaceNameQuery = function(placeName) {
 	var query = new Parse.Query(_this.HealthService);
 	var municipalityCode = placeName.get(_this.keys.placeNameMunicipalityCode).toString();
 	if (municipalityCode.length < 4)
 		municipalityCode = "0" + municipalityCode;
 	query.contains(_this.keys.appliesToMunicipalityCodes, municipalityCode);
 	_this.query = query;
 }

 // Search municipality by place name
 SearchQuery.prototype.setMunicipalityByPlaceNameQuery = function(placeName) {
 	var municipalityCode = placeName.get(_this.keys.placeNameMunicipalityCode).toString();
 	var query = new Parse.Query(_this.Municipality);
 	query.equalTo(_this.keys.municipalityCode, municipalityCode);
 	_this.query = query;
 }

 /**
  * Export the module
  */
 module.exports = SearchQuery;