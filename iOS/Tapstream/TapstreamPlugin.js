/**
 * Cordova TapStream Plugin
 * Copyright (c) 2012 Stephan Bönnemann
 *
 */
 
(function() {
  
var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks

function TapstreamPlugin() {};

TapstreamPlugin.prototype.fireEvent = function(eventName /* String */, oneTimeOnly /* Boolean*/) {
  var options = {
    eventName: eventName,
    oneTimeOnly: typeof oneTimeOnly != 'undefined' ? !!oneTimeOnly : false
  };
  return cordovaRef.exec("TapstreamPlugin.fireEvent",options);
};

cordovaRef.addConstructor(function() {
  if(!window.plugins) {
    window.plugins = {};
  }
  if (!window.plugins.TapstreamPlugin) {
    window.plugins.TapstreamPlugin = new TapstreamPlugin();
  }
});

})();