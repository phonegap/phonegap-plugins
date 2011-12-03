//
//  	VolumeSlider.js
//  	Volume Slider PhoneGap Plugin
//
//  	Created by Tommy-Carlos Williams on 20/07/25.
//  	Copyright 2011 Tommy-Carlos Williams. All rights reserved.
//      MIT Licensed
//

var VolumeSlider = function(){ 
    
}

/**
 * Create a volume slider.
 */
VolumeSlider.prototype.createVolumeSlider = function(originx,originy,width,height) {
    PhoneGap.exec(null, null, "VolumeSlider","createVolumeSlider", [originx, originy, width, height]);
};

/**
 * Show the volume slider
 */
VolumeSlider.prototype.showVolumeSlider = function() {
    PhoneGap.exec(null, null, "VolumeSlider","showVolumeSlider", []);
};
/**
 * Hide the volume slider
 */
VolumeSlider.prototype.hideVolumeSlider = function() {
    PhoneGap.exec(null, null, "VolumeSlider","hideVolumeSlider", []);
};


PhoneGap.addConstructor(function(){
	if(!window.plugins)
	{
		window.plugins = {};
	}
	window.plugins.volumeSlider = new VolumeSlider();
});
