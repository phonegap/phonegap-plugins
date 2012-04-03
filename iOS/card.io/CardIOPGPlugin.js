/**
 * CardIOPGPlugin.js
 *
 * Copyright 2012 Lumber Labs (card.io)
 * MIT licensed
 */

/**
 * This class exposes card.io's card scanning functionality to JavaScript.
 *
 * @constructor
 */
function CardIO() {
}

/**
 * Scan a credit card with card.io.
 *
 * @parameter appToken: a string; get it from https://www.card.io/.
 *
 * @parameter options: an object; may be {}. Sample options object:
 *  {"collect_expiry": true, "collect_cvv": false, "collect_zip": false,
 *   "shows_first_use_alert": true, "disable_manual_entry_buttons": false}
 * Omit any key from options to get the default value. For more detail on
 * each of the options, look at CardIOPaymentViewController.h.
 *
 * @parameter onSuccess: a callback function that accepts a response object; response keys
 * include card_type, redacted_card_number, expiry_month, card_number, expiry_year,
 * and, if requested, cvv and zip.
 *
 * @parameter onFailure: a zero argument callback function that will be called if the user
 * cancels card scanning.
 */
CardIO.prototype.scan = function(appToken, options, onSuccess, onFailure) {
  Cordova.exec(onSuccess, onFailure, "CardIOPGPlugin", "scan", [appToken, options]);
};

/**
 * Check whether card scanning is currently available. (May vary by
 * device, OS version, network connectivity, etc.)
 *
 * @parameter callback: a callback function accepting a boolean.
 */
CardIO.prototype.canScan = function(callback) {
  var failureCallback = function() {
    console.log("Could not detect whether card.io card scanning is available.");
  };
  var wrappedSuccess = function(response) {
    callback(response != 0);
  }
  Cordova.exec(wrappedSuccess, failureCallback, "CardIOPGPlugin", "canScan", []);
};

/**
 * Retrieve the version of the card.io library. Useful when contacting support.
 *
 * @parameter callback: a callback function accepting a string.
 */
CardIO.prototype.version = function(callback) {
  var failureCallback = function() {
    console.log("Could not retrieve card.io library version");
  };

  Cordova.exec(callback, failureCallback, "CardIOPGPlugin", "version", []);
};


/**
 * Plugin setup boilerplate.
 */
Cordova.addConstructor(function() {
  if(!window.plugins) {
    window.plugins = {};
  }
  if(!window.plugins.card_io) {
    window.plugins.card_io = new CardIO();
  }
});
