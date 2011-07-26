VolumeSlider
============

Installation
------------

This plugin allows you to add a native volume slider (MPVolumeView) to your app.

Add the plugin much like any other:

1.      Add the VolumeSlider.h and VolumeSlider.m classes to your Plugins folder in Xcode
2.      Add the VolumeSlider.js file to your www folder
3.	Add the VolumeSlider.js to your html file. eg: `<script type="text/javascript" charset="utf-8" src="VolumeSlider.js"></script>`
4.      Add the plugin to the PhoneGap.plist
5.      Here is where it differs slightly, [add the MediaPlayer.framework to your project in Xcode](http://paikialog.wordpress.com/2011/03/09/xcode-4how-to-add-framework-into-project/ "Xcode 4–How to add Framework into project?") (this is where MPVolumeView comes from).

### Example

	function onDeviceReady()
	{
		var volumeSlider = window.plugins.volumeSlider;
		volumeSlider.createVolumeSlider(10,350,300,30); // origin x, origin y, width, height
		volumeSlider.showVolumeSlider();
	}

... now since this is a native control added more or less on top of your webView, you might have to show and hide it if you navigate away from the _page_ you want the VolumeSlider on:

	volumeSlider.hideVolumeSlider();

