if (typeof window.wifi == 'undefined') {
	window.wifi = {
		getSSID: function(callback) {
		    cordova.exec(callback, function(err) {
	                 callback('Could not get Wifi SSID.');
	        }, "Wifi", "getSSID", []);
		}
	};
}