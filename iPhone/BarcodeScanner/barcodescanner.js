/**
 * Phonegap Barcode Scanner plugin
 * Copyright (c) Matt Kane 2011
 *
 */
var BarcodeScanner = function() { 

}

/* That's your lot for the moment */

BarcodeScanner.Type = {
	QR_CODE: "QR_CODE"
}

/* Types are ignored at the moment until I implement any other than QR Code */

BarcodeScanner.prototype.scan = function(types, success, fail) {
    return PhoneGap.exec("BarcodeScanner.scan", GetFunctionName(success), GetFunctionName(fail), types);
};




PhoneGap.addConstructor(function() 
{
	if(!window.plugins)
	{
		window.plugins = {};
	}
	window.plugins.barcodeScanner = new BarcodeScanner();
});
