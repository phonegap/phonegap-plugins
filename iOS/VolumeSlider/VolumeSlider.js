//
//	VolumeSlider.js
//	Volume Slider Cordova Plugin
//
//	Created by Tommy-Carlos Williams on 20/07/11.
//	Copyright 2011 Tommy-Carlos Williams. All rights reserved.
//      MIT Licensed
//
(function(){
	var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks
	var VolumeSlider = function(){
	};
	
	/**
	 * Create a volume slider.
	 */
	VolumeSlider.prototype.createVolumeSlider = function(originx,originy,width,height) {
		cordovaRef.exec(null, null, "VolumeSlider","createVolumeSlider", [originx, originy, width, height]);
	};
	
	/**
	 * Show the volume slider
	 */
	VolumeSlider.prototype.showVolumeSlider = function() {
		cordovaRef.exec(null, null, "VolumeSlider","showVolumeSlider", []);
	};
	/**
	 * Hide the volume slider
	 */
	VolumeSlider.prototype.hideVolumeSlider = function() {
		cordovaRef.exec(null, null, "VolumeSlider","hideVolumeSlider", []);
	};
	
	
	cordovaRef.addConstructor(function(){
		if(!window.plugins)
		{
			window.plugins = {};
		}
		window.plugins.volumeSlider = new VolumeSlider();
	});
})();