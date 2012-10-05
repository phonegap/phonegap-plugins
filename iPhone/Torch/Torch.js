//
//  Torch.js
//  PhoneGap Plugin
//
//  Only supported in iOS4, and flash capable device (currently iPhone 4 only)
//
// Created by Shazron Abdullah May 26th 2011
//

function Torch()
{
	this._isOn = false;
	this._isCapable = false;
	var self = this;
	
	cordova.exec(null, null, "Torch","isCapable", []);
	this.__defineGetter__("isOn", function() { return self._isOn; });	
}

Torch.prototype.turnOn = function()
{
    if (this.isCapable())
    {
        console.log("Torch on");

        cordova.exec("Torch.turnOn");
    }
};

Torch.prototype.turnOff = function()
{
	console.log("Torch off");
	
	cordova.exec("Torch.turnOff");
};

Torch.prototype.isCapable = function()
{
	console.log("Capable: " + this._isCapable);
	return this._isCapable;
}

Torch.install = function()
{
	if(!window.plugins) {
		window.plugins = {};
	}
	window.plugins.torch = new Torch();
};

cordova.addConstructor(Torch.install);
