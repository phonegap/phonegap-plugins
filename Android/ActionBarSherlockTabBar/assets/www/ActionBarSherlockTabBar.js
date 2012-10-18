/*
    MIT licensed (http://www.opensource.org/licenses/mit-license.html)

    See https://github.com/AndiDog/phonegap-plugins
*/

// Usage: actionBarSherlockTabBar = cordova.require('cordova/plugin/actionBarSherlockTabBar');
cordova.define('cordova/plugin/actionBarSherlockTabBar', function(require, exports, module) {
    var exec = require('cordova/exec')

    var ActionBarSherlockTabBar = function() {}

    ActionBarSherlockTabBar.prototype.hide = function() {
        exec(null,
             null,
             'ActionBarSherlockTabBar',
             'hide',
             [])
    }

    ActionBarSherlockTabBar.prototype.show = function() {
        exec(null,
             null,
             'ActionBarSherlockTabBar',
             'show',
             [])
    }

    ActionBarSherlockTabBar.prototype.setTabSelectedListener = function(callback) {
        if(typeof callback != 'function')
            throw 'ActionBarSherlockTabBar.setTabSelectedListener: Callback not a function'

        exec(callback,
             function() {},
             'ActionBarSherlockTabBar',
             'setTabSelectedListener',
             [])
    }

    module.exports = new ActionBarSherlockTabBar()

    exec(null,
         null,
         'ActionBarSherlockTabBar',
         '_init',
         [])
});