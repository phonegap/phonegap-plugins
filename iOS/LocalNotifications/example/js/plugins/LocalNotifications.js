/*
 TestFlight Plugin for cordova.
 Created by Shazron Abdullah, Nitobi Software Inc.

 Updated by Will Froelich Apr-10-2012

 See README for install/use information

 */
(function() {

    var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks


    TestFlight = function() {
        this.serviceName = "TestFlightSDK";
    };

    /*
     Add custom environment information
     If you want to track a user name from your application you can add it here

     @param successCallback function
     @param failureCallback function
     @param key string
     @param information string
     */
    TestFlight.prototype.addCustomEnvironmentInformation = function(successCallback, failureCallback, key, information) {
        cordovaRef.exec(successCallback, failureCallback, this.serviceName, "addCustomEnvironmentInformation", [{
            key: key,
            information: information
        }]);
    };

    /*
     Starts a TestFlight session

     @param successCallback function
     @param failureCallback function
     @param teamToken string
     */
    TestFlight.prototype.takeOff = function(successCallback, failureCallback, teamToken) {
        cordovaRef.exec(successCallback, failureCallback, this.serviceName, "takeOff", [{
            teamToken: teamToken
        }]);
    };

    /*
     Sets custom options

     @param successCallback function
     @param failureCallback function
     @param options object i.e { reinstallCrashHandlers : true }
     */
    TestFlight.prototype.setOptions = function(successCallback, failureCallback, options) {
        if (!(null !== options && 'object' == typeof(options))) {
            options = {};
        }
        cordovaRef.exec(successCallback, failureCallback, this.serviceName, "setOptions", [options]);
    };

    /*
     Track when a user has passed a checkpoint after the flight has taken off. Eg. passed level 1, posted high score

     @param successCallback function
     @param failureCallback function
     @param checkpointName string
     */
    TestFlight.prototype.passCheckpoint = function(successCallback, failureCallback, checkpointName) {
        cordovaRef.exec(successCallback, failureCallback, this.serviceName, "passCheckpoint", [{
            checkpointName: checkpointName
        }]);
    };

    /*
     Opens a feeback window that is not attached to a checkpoint

     @param successCallback function
     @param failureCallback function
    */
    TestFlight.prototype.openFeedbackView = function(successCallback, failureCallback) {
        cordovaRef.exec(successCallback, failureCallback, this.serviceName, "openFeedbackView", []);
    };

    /*
     Sets up the device identifier used for tracking TestFlight QA users

     @param successCallback function
     @param failureCallback function
     @param deviceIdentifier string
    */
    TestFlight.prototype.setDeviceIdentifier = function(successCallback, failureCallback, deviceIdentifier) {
        cordovaRef.exec(successCallback, failureCallback, this.serviceName, "setDeviceIdentifier", [{
	        deviceIdentifier: deviceIdentifier
        }]);
    };

    TestFlight.install = function(){
        if( !window.plugins){
            window.plugins = {};
        }
        if( !window.plugins.testFlight ){
            window.plugins.testFlight = new TestFlight();
        }
    };

    if (cordovaRef && cordovaRef.addConstructor) {
        cordovaRef.addConstructor(TestFlight.install);
    } else {
        console.log("TestFlight Cordova Plugin could not be installed.");
        return null;
    }
   
})();
