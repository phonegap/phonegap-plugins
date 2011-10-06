/**
 * Phonegap Barcode Scanner plugin
 * Copyright (c) Matt Kane 2011
 *
 */
var BarcodeScanner = function() { 

}

BarcodeScanner.prototype.callbackMap = {};
BarcodeScanner.prototype.callbackIdx = 0;

/* That's your lot for the moment */

BarcodeScanner.Type = {
	QR_CODE: "QR_CODE"
}

/* Types are ignored at the moment until I implement any other than QR Code */

BarcodeScanner.prototype.scan = function(types, success, fail) {
    
    var plugin = window.plugins.barcodeScanner,
        cbMap = plugin.callbackMap,
        key = 'scan' + plugin.callbackIdx++;
    
    cbMap[key] = {
        success: function(result) {
            delete cbMap[key];
            success(result);
        },
        fail: function(result) {
            delete cbMap[key];
            fail(result);
        }
    };
        
    var cbPrefix = 'window.plugins.barcodeScanner.callbackMap.' + key;
    
    return PhoneGap.exec("BarcodeScanner.scan", cbPrefix + ".success", cbPrefix + ".fail", types);
};

PhoneGap.addConstructor(function() 
{
	if(!window.plugins)
	{
		window.plugins = {};
	}
	window.plugins.barcodeScanner = new BarcodeScanner();
});
