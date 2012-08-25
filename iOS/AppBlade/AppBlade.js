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
    cordova.exec("AppBlade.setupAppBlade", [project, token, secret, timestamp]);
};
    
AppBlade.prototype.catchAndReportCrashes = function() {
    cordova.exec("AppBlade.catchAndReportCrashes");
};
    
AppBlade.prototype.checkAuthentication = function() {
    cordova.exec("AppBlade.checkAuthentication");
};
    
AppBlade.prototype.allowFeedbackReporting = function() {
    cordova.exec("AppBlade.allowFeedbackReporting");
};

// --------------------------------------------------------

cordova.addConstructor(function() {
    if (!window.Cordova) {
    window.Cordova = cordova;
    };
                       
    if(!window.plugins) window.plugins = {};
    window.plugins.appBlade = new AppBlade();
});