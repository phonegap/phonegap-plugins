/*
 *  SplashScreen.js
 *
 *  Created by André Fiedler on 07.01.11.
 *  Copyright 2011 André Fiedler, <fiedler.andre at gmail dot com>
 *  MIT licensed
 */

function SplashScreen() {}

SplashScreen.prototype.show = function() {
    PhoneGap.exec('SplashScreen.show');
};

SplashScreen.prototype.hide = function() {
    PhoneGap.exec('SplashScreen.hide');
};

PhoneGap.addConstructor(function() {
	if(!window.plugins) {
		window.plugins = {};
	}
	window.plugins.splashScreen = new SplashScreen();
});