(function(){
	var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks

	function GoogleAnalyticsPlugin() {}

	GoogleAnalyticsPlugin.prototype.startTrackerWithAccountID = function(id) {
		cordovaRef.exec("GoogleAnalyticsPlugin.startTrackerWithAccountID",id);
	};

	GoogleAnalyticsPlugin.prototype.trackPageview = function(pageUri) {
		cordovaRef.exec("GoogleAnalyticsPlugin.trackPageview",pageUri);
	};

	GoogleAnalyticsPlugin.prototype.trackEvent = function(category,action,label,value) {
		var options = {category:category,
			action:action,
			label:label,
			value:value};
		cordovaRef.exec("GoogleAnalyticsPlugin.trackEvent",options);
	};

	GoogleAnalyticsPlugin.prototype.setCustomVariable = function(index,name,value) {
		var options = {index:index,
			name:name,
			value:value};
		cordovaRef.exec("GoogleAnalyticsPlugin.setCustomVariable",options);
	};

	GoogleAnalyticsPlugin.prototype.hitDispatched = function(hitString) {
		//console.log("hitDispatched :: " + hitString);
	};
	GoogleAnalyticsPlugin.prototype.trackerDispatchDidComplete = function(count) {
		//console.log("trackerDispatchDidComplete :: " + count);
	};

	cordovaRef.addConstructor(function() {
		if(!window.plugins) window.plugins = {};
		window.plugins.googleAnalyticsPlugin = new GoogleAnalyticsPlugin();
	});

})();