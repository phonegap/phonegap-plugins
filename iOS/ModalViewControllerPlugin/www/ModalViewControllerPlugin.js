//
//  ModalViewControllerPlugin.js
//  ModalViewControllerPlugin -  PhoneGap/Cordova Plug-In
//
//  Created by Justin D'Arcangelo on 12/11/12.
//  Copyright (c) 2012 Entropi Software. All rights reserved.
//

(function(cordova) {
  var ModalViewControllerPlugin = function ModalViewControllerPlugin() {};
  
  var _defaultPresentOptions = {
    viewControllerName: null,
    nibName: '',
    useNavigationController: false,
    animated: true
  };
  
  var _defaultDismissOptions = {
    animated: true
  };
  
  ModalViewControllerPlugin.prototype = {
    constructor: ModalViewControllerPlugin,
    
    presentModalViewController: function(options, callback) {
      options = options || {};
      cordova.exec(callback, null, 'ModalViewControllerPlugin', 'presentModalViewController', [{
        viewControllerName:      options.viewControllerName      || _defaultPresentOptions.viewControllerName,
        nibName:                 options.nibName                 || _defaultPresentOptions.nibName,
        useNavigationController: options.useNavigationController === false ? false : options.useNavigationController || _defaultPresentOptions.useNavigationController,
        animated:                options.animated                === false ? false : options.animated                || _defaultPresentOptions.animated
      }]);
    },
    
    dismissModalViewController: function(options, callback) {
      options = options || {};
      cordova.exec(callback, null, 'ModalViewControllerPlugin', 'dismissModalViewController', [{
        animated: options.animated === false ? false : options.animated || _defaultDismissOptions.animated
      }]);
    }
  };
  
  cordova.addConstructor(function() {
    window.plugins = window.plugins || {};
    window.plugins.modalViewControllerPlugin = new ModalViewControllerPlugin();
  });
})(window.cordova || window.Cordova);
