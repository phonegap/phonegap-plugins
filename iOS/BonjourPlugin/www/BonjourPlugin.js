//
//  BonjourPlugin.js
//  BonjourPlugin -  PhoneGap/Cordova Plug-In
//
//  Created by Justin D'Arcangelo on 12/11/12.
//  Copyright (c) 2012 Entropi Software. All rights reserved.
//

(function(cordova) {
  var BonjourPlugin = function BonjourPlugin() {};
  
  BonjourPlugin.prototype = {
    constructor: BonjourPlugin,
    
    startServiceDiscovery: function(serviceType, searchDomain, callback) {
      cordova.exec(callback, null, 'BonjourPlugin', 'startServiceDiscovery', [serviceType, searchDomain]);
    },
    
    stopServiceDiscovery: function() {
      cordova.exec(null, null, 'BonjourPlugin', 'stopServiceDiscovery');
    }
  };
  
  cordova.addConstructor(function() {
    window.plugins = window.plugins || {};
    window.plugins.bonjourPlugin = new BonjourPlugin();
  });
})(window.cordova || window.Cordova);
