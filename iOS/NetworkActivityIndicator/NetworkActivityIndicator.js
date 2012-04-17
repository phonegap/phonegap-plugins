(function(window) {

	var cordovaRef = window.PhoneGap || window.Cordova || window.cordova;

	var NetworkActivityIndicator = function() {};

	NetworkActivityIndicator.prototype = {

		set: function(value)  {
			value = (value) ? 'true' : 'false';
			cordovaRef.exec('NetworkActivityIndicator.setIndicator', value);
		},
		
		show: function() {
			this.set(true);
		},
		
		hide: function() {
			this.set(false);
		}

	};

	window.plugins = window.plugins || {};
	window.plugins.networkActivityIndicator = new NetworkActivityIndicator();

}(window));