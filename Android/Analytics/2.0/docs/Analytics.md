Analytics
==========

Analytics is an object that allows you to track page views using Google Analytics framework.

Properties
----------

N/A

Methods
-------

- start: Initialize Google Analytics with the appropriate Google Analytics account.
- trackPageView: Track a page view on Google Analytics. 
- trackEvent: Track an event on Google Analytics. 
- stop: Stop Tracking with Google Analytics. 


Supported Platforms
-------------------

- Android

Quick Example
------------------------------
	
  	var onStartSuccess = function() {
  		alert("Google Analytics has started successfully");
	}
	
    var onStartFailure = function() {
        alert("Google Analytics failed to start");
    }
	
	var onTrackSuccess = function() {
  		alert("A page view has been successfully sent to Google Analytics.");
	}
	
    var onTrackFailure = function() {
        alert("A page view has failed to be submitted to Google Analytics");
    }
	
	var onEventSuccess = function() {
  		alert("An event has been successfully sent to Google Analytics.");
	}
	
    var onEventFailure = function() {
        alert("An event has failed to be submitted to Google Analytics");
    }

	// Get your account id from http://www.google.com/analytics/ and set it up in the analytics.xml file
    window.plugins.analytics.start(onStartSuccess, onStartFailure);
	window.plugins.analytics.trackPageView("page1.html", onTrackSuccess, onTrackFailure);
	window.plugins.analytics.trackEvent("category", "action", "event", 1, onEventSuccess, onEventFailure);
    window.plugins.analytics.stop(onStartSuccess, onStartFailure);
