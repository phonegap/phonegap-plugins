/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 * 
 * Copyright (c) 2005-2010, Nitobi Software Inc., Brett Rudd, Jesse MacFadyen
 */

function MapKitPlug() {
	this.options = {
		// Default options 
		"buttonCallback": "window.plugins.mapKit.onMapCallback",
		"height":460,
		"diameter":1000,
		"atBottom":true,
		// ( nitobi HQ, if you have issues, send missles here )
		"lat":49.281468,
		"lon":-123.104446
	};
}

MapKitPlug.Pin = function() {
//	this.lat = 
//	this.lon = 
//	this.title = 
//	this.pinColor = 
//	this.index = 
//	this.selected = false;
};

MapKitPlug.prototype.onMapCallback = function(pindex) {
	alert("You selected pin : " + pindex);
};


MapKitPlug.prototype.showMap = function() {
	PhoneGap.exec("MapKitView.showMap");
};

MapKitPlug.prototype.setMapData = function(options) {
  /*
   buttonCallback: String, string callback function
   height: Number, - pixels
   diameter: Number, - meters
   atBottom: Bool,
   lat: Number,
   lon: Number
  */
	for (var v in options) {
		if (options.hasOwnProperty(v)) {
			this.options[v] = options[v];
		}
	}
	
	PhoneGap.exec("MapKitView.setMapData",this.options);
};

MapKitPlug.prototype.addMapPins = function(pins) {
  var pinStr = "[]";
  if(pins) pinStr = JSON.stringify(pins);
  PhoneGap.exec("MapKitView.addMapPins", pinStr);
}

MapKitPlug.prototype.clearMapPins = function() {
  PhoneGap.exec("MapKitView.clearMapPins");
}

MapKitPlug.prototype.hideMap = function() {
	PhoneGap.exec("MapKitView.hideMap", {});
};

// Coming Soon!!
//MapKitPlug.prototype.destroyMap = function() {
//	PhoneGap.exec("MapKitView.destroyMap", {});
//};

PhoneGap.addConstructor(function() {
  if(!window.plugins) window.plugins = {};
  window.plugins.mapKit = new MapKitPlug();
});