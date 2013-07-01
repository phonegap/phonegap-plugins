/**
 * CardIOPGPlugin.js
 * card.io phonegap plugin
 * @Copyright 2013 Cubet Technologies http://www.cubettechnologies.com
 * @author Robin <robin@cubettech.com>
 * @Since 28 June, 2013
 */

//Your response array contain these fields
// redacted_card_number, card_number, expiry_month,expiry_year, cvv, zip

//set your configurations here
var cardIOConfig = {
		'apiKey': 'YOUR_API_KEY_HERE',
		'expiry': true,
		'cvv': true,
		'zip':false,
};


var CardIOPGPlugin = function() {};
  
CardIOPGPlugin.prototype.scan = function(success, fail) {
    return cordova.exec(function(args) {
    	console.log("card.io scanning completed");
        success(args[0]);
    }, function(args) {
    	console.log("card.io scanning Failed");
        fail(args);
    }, "CardIOPGPlugin", "execute", [cardIOConfig]);
};

if(!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.CardIOPGPlugin) {
    window.plugins.CardIOPGPlugin = new CardIOPGPlugin();
}


//EOF
