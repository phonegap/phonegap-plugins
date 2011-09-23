/*
 *  SplashScreen.js
 *
 *  Created by André Fiedler on 07.01.11.
 *  Copyright 2011 André Fiedler, <fiedler.andre at gmail dot com>
 *  MIT licensed
 */

function SplashScreen() {}

SplashScreen.prototype.show = function(image) {
    var imageSplit = image.split(".");
    var imageName = imageSplit[0];
    for(var i = 1, len = imageSplit.length-1;i < len;i++)
		imageName += '.' + imageSplit[i];
   
    PhoneGap.exec('SplashScreen.show',imageName,imageSplit[imageSplit.length-1]);
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