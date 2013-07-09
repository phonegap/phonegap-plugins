
(function(window) {

	/*
	* PhoneGap is available under *either* the terms of the modified BSD license *or* the
	* MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
	*
	* Copyright (c) 2005-2010, Nitobi Software Inc., Brett Rudd, Jesse MacFadyen
	*/

	var cordovaRef = window.PhoneGap || window.Cordova || window.cordova;

	var MapKit = function() {
		this.options = {
			buttonCallback: 'window.plugins.mapKit.onMapCallback',
			height: 460,
			diameter: 1000,
			atBottom: true,
			lat: 49.281468,
			lon: -123.104446
		};
	}

	MapKit.prototype = {

		onMapCallback: function(pindex) {
			alert('You selected pin : ' + pindex);
		},

		showMap: function(success, error) {
			cordovaRef.exec(success, error, 'MapKitView', 'showMap', []);
		},

		setMapData: function(options, success, error) {
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
			cordovaRef.exec(success, error, 'MapKitView', 'setMapData', [this.options]);
		},

		addMapPins: function(pins, success, error) {
			cordovaRef.exec(success, error, 'MapKitView', 'addMapPins', [pins]);
		},

		clearMapPins: function(success, error) {
			cordovaRef.exec(success, error, 'MapKitView', 'clearMapPins', []);
		},

		hideMap: function() {
			cordovaRef.exec(null, null, 'MapKitView', 'hideMap', []);
		}


	};

	cordovaRef.addConstructor(function() {
		window.plugins = window.plugins || {};
		window.plugins.mapKit = new MapKit();
		
		// dummy stuff to silence calls from mapView regionDidChangeAnimated in .m
		  window.geo = window.geo || {};
		  window.geo.onMapMove = function(currentLat,currentLon,latitudeDelta,longitudeDelta) {
		  // console.log([currentLat,currentLon,latitudeDelta,longitudeDelta]);
		  };
	});

})(window);