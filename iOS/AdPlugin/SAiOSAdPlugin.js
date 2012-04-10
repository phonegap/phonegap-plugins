/*     

Cordova v1.5.0 Support added 2012 @RandyMcMillan
README.md for install notes

Cordova v1.6.0 Support added @shazron
*/

// /////////////////////////
(function() {
// /////////////////////////

// get local ref to global PhoneGap/Cordova/cordova object for exec function
var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks

/**
 * Constructor
 */
function SAiOSAdPlugin()
{
}

/**
 * show - true to show the ad, false to hide the ad
 */
SAiOSAdPlugin.prototype.orientationChanged = function()
{
    cordovaRef.exec("SAiOSAdPlugin.orientationChanged", window.orientation);
}

/**
 * show - true to show the ad, false to hide the ad
 */
SAiOSAdPlugin.prototype.showAd = function(show)
{
    cordovaRef.exec("SAiOSAdPlugin.showAd", show);
}

/**
 * atBottom - true to put the ad at the bottom, false to put the ad at the top
 */
SAiOSAdPlugin.prototype.prepare = function(atBottom)
{
	if (!atBottom) {
		atBottom = false;
	}
    
	cordovaRef.exec("SAiOSAdPlugin.prepare", atBottom);
}

/**
 * Install function
 */
SAiOSAdPlugin.install = function()
{
	if ( !window.plugins ) {
		window.plugins = {};
	} 
	if ( !window.plugins.iAdPlugin ) {
		window.plugins.iAdPlugin = new SAiOSAdPlugin();
	}
}

/**
 * Add to Cordova constructor
 */
if (cordovaRef && cordovaRef.addConstructor) {
	cordovaRef.addConstructor(SAiOSAdPlugin.install);
} else {
	console.log("iAd Cordova Plugin could not be installed.");
	return null;
}


// /////////////////////////
})();
// /////////////////////////
