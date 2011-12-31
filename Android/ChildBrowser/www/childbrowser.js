/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2005-2010, Nitobi Software Inc.
 * Copyright (c) 2011, IBM Corporation
 */

/**
 * Constructor
 */
function ChildBrowser() {
};

ChildBrowser.CLOSE_EVENT = 0;
ChildBrowser.LOCATION_CHANGED_EVENT = 1;

/**
 * Display a new browser with the specified URL.
 * This method loads up a new web view in a dialog.
 *
 * @param url           The url to load
 * @param options       An object that specifies additional options
 */
ChildBrowser.prototype.showWebPage = function(url, options) {
    if (options === null || options === "undefined") {
        var options = new Object();
        options.showLocationBar = true;
    }
    PhoneGap.exec(this._onEvent, this._onError, "ChildBrowser", "showWebPage", [url, options]);
};

/**
 * Close the browser opened by showWebPage.
 */
ChildBrowser.prototype.close = function() {
    PhoneGap.exec(null, null, "ChildBrowser", "close", []);
};

/**
 * Display a new browser with the specified URL.
 * This method starts a new web browser activity.
 *
 * @param url           The url to load
 * @param usePhoneGap   Load url in PhoneGap webview [optional]
 */
ChildBrowser.prototype.openExternal = function(url, usePhoneGap) {
    if (usePhoneGap === true) {
        navigator.app.loadUrl(url);
    }
    else {
        PhoneGap.exec(null, null, "ChildBrowser", "openExternal", [url, usePhoneGap]);
    }
};

/**
 * Method called when the child browser has an event.
 */
ChildBrowser.prototype._onEvent = function(data) {
    if (data.type == ChildBrowser.CLOSE_EVENT && typeof window.plugins.childBrowser.onClose === "function") {
        window.plugins.childBrowser.onClose();
    }
    if (data.type == ChildBrowser.LOCATION_CHANGED_EVENT && typeof window.plugins.childBrowser.onLocationChange === "function") {
        window.plugins.childBrowser.onLocationChange(data.location);
    }
};

/**
 * Method called when the child browser has an error.
 */
ChildBrowser.prototype._onError = function(data) {
    if (typeof window.plugins.childBrowser.onError === "function") {
        window.plugins.childBrowser.onError(data);
    }
};

/**
 * Maintain API consistency with iOS
 */
ChildBrowser.prototype.install = function(){
};

/**
 * Load ChildBrowser
 */
PhoneGap.addConstructor(function() {
    PhoneGap.addPlugin("childBrowser", new ChildBrowser());
});
