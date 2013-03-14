/**
 * Geofencing.js
 *  
 * Phonegap Geofencing Plugin
 * Copyright (c) Dov Goldberg 2012
 * http://www.ogonium.com
 * dov.goldberg@ogonium.com
 *
 */
var DGGeofencing = {
	/*
	Params:
	#define KEY_REGION_ID       @"fid"
	#define KEY_REGION_LAT      @"latitude"
    #define KEY_REGION_LNG      @"longitude"
    #define KEY_REGION_RADIUS   @"radius"
    #define KEY_REGION_ACCURACY @"accuracy"
	*/
     addRegion: function(params, success, fail) {
          return Cordova.exec(success, fail, "DGGeofencing", "addRegion", [params]);
     },

     /*
	Params:
	#define KEY_REGION_ID      @"fid"
	#define KEY_REGION_LAT     @"latitude"
    #define KEY_REGION_LNG     @"longitude"
	*/
     removeRegion: function(params, success, fail) {
          return Cordova.exec(success, fail, "DGGeofencing", "removeRegion", [params]);
     },

     /*
	Params:
	NONE
	*/
	getWatchedRegionIds: function(success, fail) {
		return Cordova.exec(success, fail, "DGGeofencing", "getWatchedRegionIds", []);
	},
	
	/*
	Params:
	NONE
	*/
	getPendingRegionUpdates: function(success, fail) {
		return Cordova.exec(success, fail, "DGGeofencing", "getPendingRegionUpdates", []);
	},
	
	/*
	Params:
	NONE
	*/
	startMonitoringSignificantLocationChanges: function(success, fail) {
		return Cordova.exec(success, fail, "DGGeofencing", "startMonitoringSignificantLocationChanges", []);
	},
	
	/*
	Params:
	NONE
	*/
	stopMonitoringSignificantLocationChanges: function(success, fail) {
		return Cordova.exec(success, fail, "DGGeofencing", "stopMonitoringSignificantLocationChanges", []);
	},
	
	/* 
	This is used so the JavaScript can be updated when a region is entered or exited
	*/
	regionMonitorUpdate: function(regionupdate) {
		console.log("regionMonitorUpdate: " + regionupdate);
		var ev = document.createEvent('HTMLEvents');
		ev.regionupdate = regionupdate;
		ev.initEvent('region-update', true, true, arguments);
		document.dispatchEvent(ev);
	},
	
	/* 
	This is used so the JavaScript can be updated when a significant change has occured
	*/
	locationMonitorUpdate: function(locationupdate) {
		console.log("locationMonitorUpdate: " + locationupdate);
		var ev = document.createEvent('HTMLEvents');
		ev.locationupdate = locationupdate;
		ev.initEvent('location-update', true, true, arguments);
		document.dispatchEvent(ev);
	}
};