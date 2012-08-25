/**
 * cordova is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) Matt Kane 2010
 * Copyright (c) 2011, IBM Corporation
 */

var BarcodeScanner = function() {
};

//-------------------------------------------------------------------
BarcodeScanner.Encode = {
        TEXT_TYPE: "TEXT_TYPE",
        EMAIL_TYPE: "EMAIL_TYPE",
        PHONE_TYPE: "PHONE_TYPE",
        SMS_TYPE: "SMS_TYPE",
        //  CONTACT_TYPE: "CONTACT_TYPE",  // TODO:  not implemented, requires passing a Bundle class from Javascriopt to Java
        //  LOCATION_TYPE: "LOCATION_TYPE" // TODO:  not implemented, requires passing a Bundle class from Javascriopt to Java
};

//-------------------------------------------------------------------
BarcodeScanner.prototype.scan = function(successCallback, errorCallback) {
    if (errorCallback == null) { errorCallback = function() {}}

    if (typeof errorCallback != "function")  {
        console.log("BarcodeScanner.scan failure: failure parameter not a function");
        return
    }

    if (typeof successCallback != "function") {
        console.log("BarcodeScanner.scan failure: success callback parameter must be a function");
        return
    }

    cordova.exec(successCallback, errorCallback, 'BarcodeScanner', 'scan', []);
};

//-------------------------------------------------------------------
BarcodeScanner.prototype.encode = function(type, data, successCallback, errorCallback, options) {
    if (errorCallback == null) { errorCallback = function() {}}

    if (typeof errorCallback != "function")  {
        console.log("BarcodeScanner.scan failure: failure parameter not a function");
        return
    }

    if (typeof successCallback != "function") {
        console.log("BarcodeScanner.scan failure: success callback parameter must be a function");
        return
    }

    cordova.exec(successCallback, errorCallback, 'BarcodeScanner', 'encode', [{"type": type, "data": data, "options": options}]);
};

//-------------------------------------------------------------------
cordova.addConstructor(function() {
    cordova.addPlugin('barcodeScanner', new BarcodeScanner());
});