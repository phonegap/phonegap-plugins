function GoogleAnalyticsPlugin() {}

GoogleAnalyticsPlugin.prototype.startTrackerWithAccountID = function(id) {
	Cordova.exec("GoogleAnalyticsPlugin.startTrackerWithAccountID",id);
};

GoogleAnalyticsPlugin.prototype.trackPageview = function(pageUri) {
	Cordova.exec("GoogleAnalyticsPlugin.trackPageview",pageUri);
};

GoogleAnalyticsPlugin.prototype.trackEvent = function(category,action,label,value) {
	var options = {category:category,
		action:action,
		label:label,
		value:value};
	Cordova.exec("GoogleAnalyticsPlugin.trackEvent",options);
};

GoogleAnalyticsPlugin.prototype.setCustomVariable = function(index,name,value) {
	var options = {index:index,
		name:name,
		value:value};
	Cordova.exec("GoogleAnalyticsPlugin.setCustomVariable",options);
};

GoogleAnalyticsPlugin.prototype.hitDispatched = function(hitString) {
	//console.log("hitDispatched :: " + hitString);
};
GoogleAnalyticsPlugin.prototype.trackerDispatchDidComplete = function(count) {
	//console.log("trackerDispatchDidComplete :: " + count);
};

Cordova.addConstructor(function() {
  if(!window.plugins) window.plugins = {};
  window.plugins.googleAnalyticsPlugin = new GoogleAnalyticsPlugin();
});
