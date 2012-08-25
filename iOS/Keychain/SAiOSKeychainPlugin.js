// //////////////////////////////////////
// Keychain PhoneGap Plugin
// by Shazron Abdullah
// Nov 5th 2010
// 


// ///////////////////
(function(){
// ///////////////////

// get local ref to global PhoneGap/Cordova/cordova object for exec function
var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks

/**
 * Constructor
 */
function SAiOSKeychainPlugin()
{
	this._getCallbacks = {};
	this._setCallbacks = {};
	this._removeCallbacks = {};
}

//MARK: Get

SAiOSKeychainPlugin.prototype._onGetCallbackSuccess = function(key, value)
{
	if (this._getCallbacks[key] && this._getCallbacks[key].onSuccess) {
		this._getCallbacks[key].onSuccess(key, value);
	}
	delete this._getCallbacks[key];
}

SAiOSKeychainPlugin.prototype._onGetCallbackFail = function(key, error)
{
	if (this._getCallbacks[key] && this._getCallbacks[key].onFail) {
		this._getCallbacks[key].onFail(key, error);
	}
	delete this._getCallbacks[key];
}


SAiOSKeychainPlugin.prototype.getForKey = function(key, servicename, onSuccess, onFail)
{
	this._getCallbacks[key] = { onSuccess:onSuccess, onFail:onFail };
	
	cordovaRef.exec("SAiOSKeychainPlugin.getForKey", key, servicename);
}

//MARK: Set

SAiOSKeychainPlugin.prototype._onSetCallbackSuccess = function(key)
{
	if (this._setCallbacks[key] && this._setCallbacks[key].onSuccess) {
		this._setCallbacks[key].onSuccess(key);
	}
	delete this._setCallbacks[key];
}

SAiOSKeychainPlugin.prototype._onSetCallbackFail = function(key, error)
{
	if (this._setCallbacks[key] && this._setCallbacks[key].onFail) {
		this._setCallbacks[key].onFail(key, error);
	}
	delete this._setCallbacks[key];
}

SAiOSKeychainPlugin.prototype.setForKey = function(key, value, servicename, onSuccess, onFail)
{
	this._setCallbacks[key] = { onSuccess:onSuccess, onFail:onFail };
	
	cordovaRef.exec("SAiOSKeychainPlugin.setForKey", key, value, servicename);
}

//MARK: Remove

SAiOSKeychainPlugin.prototype._onRemoveCallbackSuccess = function(key)
{
	if (this._removeCallbacks[key] && this._removeCallbacks[key].onSuccess) {
		this._removeCallbacks[key].onSuccess(key);
	}
	delete this._removeCallbacks[key];
}

SAiOSKeychainPlugin.prototype._onRemoveCallbackFail = function(key, error)
{
	if (this._removeCallbacks[key] && this._removeCallbacks[key].onFail) {
		this._removeCallbacks[key].onFail(key, error);
	}
	delete this._removeCallbacks[key];
}

SAiOSKeychainPlugin.prototype.removeForKey = function(key, servicename, onSuccess, onFail)
{
	this._removeCallbacks[key] = { onSuccess:onSuccess, onFail:onFail };
	
	cordovaRef.exec("SAiOSKeychainPlugin.removeForKey", key, servicename);
}

//MARK: Install

SAiOSKeychainPlugin.install = function()
{
	if ( !window.plugins ) {
		window.plugins = {};
	} 
	if ( !window.plugins.keychain ) {
		window.plugins.keychain = new SAiOSKeychainPlugin();
	}
}

/**
 * Add to Cordova constructor
 */
if (cordovaRef && cordovaRef.addConstructor) {
	cordovaRef.addConstructor(SAiOSKeychainPlugin.install);
} else {
	console.log("Keychain Cordova Plugin could not be installed.");
	return null;
}

// ///////////////////
})();
// ///////////////////

