/* Copyright (c) 2011 - Zitec COM
 * 
 * @author: Ionut Voda <ionut.voda@zitec.ro>
 */
 
/**
 * @return the Hmac class instance
 */
var Hmac = function() {}

/**
 * Define the sha1 function under HMAC class
 *
 * @param stringToHash The string to be hashed
 * @param hashKey The hash key
 * @param successCallback The callback which will be called when directory listing is successful
 * @param failureCallback The callback which will be called when directory listing encouters an error
 */
Hmac.prototype.sha1 = function(stringToHash, hashKey, successCallback, failureCallback) {
	return PhoneGap.exec(successCallback, failureCallback, 'HmacPlugin',
		'sha1', [stringToHash, hashKey]
	);
}

/**
 * Define the md5 function under HMAC class
 *
 * @param stringToHash The string to be hashed
 * @param hashKey The hash key
 * @param successCallback The callback which will be called when directory listing is successful
 * @param failureCallback The callback which will be called when directory listing encouters an error
 */
Hmac.prototype.md5 = function(stringToHash, hashKey, successCallback, failureCallback) {
	return PhoneGap.exec(successCallback, failureCallback, 'HmacPlugin',
		'md5', [stringToHash, hashKey]
	);
}

/**
 * Register the Directory Listing Javascript plugin
 * Also register native call which will be called when this plugin runs
 */
PhoneGap.addConstructor(function() {
	//Register the javascript plugin with PhoneGap
	PhoneGap.addPlugin('hmac', new Hmac());
	 
	//Register the native class of plugin with PhoneGap
	PluginManager.addService("HmacPlugin", "com.phonegap.plugin.hmac.HmacPlugin");
});