/**
 * Phonegap Torch plugin 
 * Copyright (c) Arne de Bree 2011
 *
 */

/**
 *  
 * @return Object literal singleton instance of Torch
 */
var Torch = function() {};

/**
  * @param success The callback for success
  * @param error The callback for error
  */
Torch.prototype.isCapable = function( success, error ) 
{
    return cordova.exec( success, error, "Torch", "isCapable", [] );   
};

/**
 * @param success The callback for success
 * @param error The callback for error
 */
Torch.prototype.isOn = function( success, error ) 
{
   return cordova.exec( success, error, "Torch", "isOn", [] );   
};

/**
 * @param success The callback for success
 * @param error The callback for error
 */
Torch.prototype.turnOn = function( success, error ) 
{
   return cordova.exec( success, error, "Torch", "turnOn", [] );   
};

/**
 * @param success The callback for success
 * @param error The callback for error
 */
Torch.prototype.turnOff = function( success, error ) 
{
   return cordova.exec( success, error, "Torch", "turnOff", [] );   
};

/**
 * @param success The callback for success
 * @param error The callback for error
 */
Torch.prototype.toggle = function( success, error ) 
{
   return cordova.exec( success, error, "Torch", "toggle", [] );   
};
 
/**
 * Load Analytics
 */

if(!window.plugins) {
    window.plugins = {};
}

if (!window.plugins.Torch) {
    window.plugins.Torch = new Torch();
}