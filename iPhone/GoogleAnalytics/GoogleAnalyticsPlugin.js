
function GoogleAnalyticsPlugin()
{

}

GoogleAnalyticsPlugin.prototype.startTrackerWithAccountID = function(id)
{
	PhoneGap.exec("GoogleAnalyticsPlugin.startTrackerWithAccountID",id);
};

GoogleAnalyticsPlugin.prototype.trackPageview = function(pageUri)
{
	PhoneGap.exec("GoogleAnalyticsPlugin.trackPageview",pageUri);
};
														

GoogleAnalyticsPlugin.prototype.trackEvent = function(category,action,label,value)
{
	var options = {category:category,
		action:action,
		label:label,
		value:value};
	PhoneGap.exec("GoogleAnalyticsPlugin.trackEvent",options);
};

GoogleAnalyticsPlugin.prototype.trackerDispatchDidComplete = function(count)
{
	//console.log("trackerDispatchDidComplete :: " + count);
};

/**
 * Install function
 */
GoogleAnalyticsPlugin.install = function()
{
	if ( !window.plugins ) 
	{
		window.plugins = {}; 
	}
	if ( !window.plugins.googleAnalyticsPlugin ) 
	{
		window.plugins.googleAnalyticsPlugin = new GoogleAnalyticsPlugin();
	}
}

/**
 * Add to PhoneGap constructor
 */
PhoneGap.addConstructor(GoogleAnalyticsPlugin.install);

