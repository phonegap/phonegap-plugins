/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2006-2011 Worklight, Ltd. 
 */


/**
 * Constructor
 */
function Analytics() {
}

/**
 * Initialize Google Analytics configuration
 * 
 * @param accountId			The Google Analytics account id 
 * @param successCallback	The success callback
 * @param failureCallback	The error callback
 */
Analytics.prototype.start = function(accountId, successCallback, failureCallback) {
	return PhoneGap.exec(
				successCallback,			 
				failureCallback,						
				'GoogleAnalyticsTracker',				
				'start',								
				[accountId]);
};

/**
 * Track a page view on Google Analytics
 * @param key				The name of the tracked item (can be a url or some logical name).
 * 							The key name will be presented in Google Analytics report.  
 * @param successCallback	The success callback
 * @param failureCallback	The error callback 
 */
Analytics.prototype.trackPageView = function(key, successCallback, failureCallback) {
	return PhoneGap.exec(
				successCallback,			
				failureCallback,		
				'GoogleAnalyticsTracker',
				'trackPageView',		
				[key]);					
};

/**
 * Load Analytics
 */
PhoneGap.addConstructor(function() {
	PhoneGap.addPlugin('analytics', new Analytics());
 	PluginManager.addService("GoogleAnalyticsTracker", "com.phonegap.plugins.analytics.GoogleAnalyticsTracker");
});