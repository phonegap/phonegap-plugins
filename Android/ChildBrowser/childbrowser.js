/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2005-2010, Nitobi Software Inc.
 * Copyright (c) 2010, IBM Corporation
 */

/**
 * Constructor
 */
function ChildBrowser() {
}

/**
 * Display a new browser with the specified URL.
 * 
 * NOTE: If usePhoneGap is set, only trusted PhoneGap URLs should be loaded,
 *       since any PhoneGap API can be called by the loaded HTML page.
 *
 * @param url           The url to load
 * @param usePhoneGap   Load url in PhoneGap webview [optional] - Default: false
 */
ChildBrowser.prototype.showWebPage = function(url, usePhoneGap) {
    PhoneGap.exec(null, null, "ChildBrowser", "showWebPage", [url, usePhoneGap]);
};

ChildBrowser.install = function() {
    
}

/**
 * Load ChildBrowser
 */
PhoneGap.addConstructor(function() {
    PhoneGap.addPlugin("childBrowser", new ChildBrowser());
// @deprecated: No longer needed in PhoneGap 1.0. Uncomment the addService code for earlier 
// PhoneGap releases.
//    PluginManager.addService("ChildBrowser", "com.phonegap.plugins.childBrowser.ChildBrowser");
});
