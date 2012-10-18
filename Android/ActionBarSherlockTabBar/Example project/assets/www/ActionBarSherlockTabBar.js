// Usage: actionBarSherlockTabBar = cordova.require('cordova/plugin/actionBarSherlockTabBar');
cordova.define('cordova/plugin/actionBarSherlockTabBar', function(require, exports, module) {
	var exec = require('cordova/exec');

	var ActionBarSherlockTabBar = function() {}

    ActionBarSherlockTabBar.prototype.setTabSelectedListener = function(callback) {
        if(typeof callback != 'function')
            throw 'ActionBarSherlockTabBar.setTabSelectedListener: Callback not a function'

        exec(callback,
             function() { /* log error here?! */ },
             'ActionBarSherlockTabBar',
             'setTabSelectedListener',
             [])
    }

	module.exports = new ActionBarSherlockTabBar();

    exec(null,
         null,
         'ActionBarSherlockTabBar',
         '_init',
         [])
});