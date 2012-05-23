/**
 * AppBlade.js
 *  
 * Phonegap AppBlade Instance plugin
 * Copyright (c) AppBlade 2012
 *
 */
  
// --------------------------------------------------------
  
var AppBlade = function(){};

// --------------------------------------------------------
  
AppBlade.prototype.setupAppBlade = function(project, token, secret, timestamp) {
    cordova.exec(null, null, "AppBlade", "setupAppBlade", [project, token, secret, timestamp]);
};
    
AppBlade.prototype.catchAndReportCrashes = function() {
	// Automatically set with Register on Android
    //cordova.exec("AppBlade.catchAndReportCrashes");
};
    
AppBlade.prototype.checkAuthentication = function() {
	console.log("Checking authentication");
    cordova.exec(null, null, "AppBlade", "checkAuthentication", []);
};
    
AppBlade.prototype.allowFeedbackReporting = function() {
	// Not supported yet
    //cordova.exec("AppBlade.allowFeedbackReporting");
};

// --------------------------------------------------------

cordova.addConstructor(function() {

    if (!window.Cordova) {
    window.Cordova = cordova;
    };
                       
    if(!window.plugins) window.plugins = {};
    window.plugins.appBlade = new AppBlade();
});