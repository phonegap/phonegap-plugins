/**
 * Phonegap Torch plugin 
 * Copyright (c) Arne de Bree 2011
 * Sebastian Greco modification
 * BothMedia SRL
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
    return PhoneGap.exec( success, error, "Torch", "isCapable", [] );   
};

/**
 * @param success The callback for success
 * @param error The callback for error
 */
Torch.prototype.isOn = function( success, error ) 
{
   return PhoneGap.exec( success, error, "Torch", "isOn", [] );   
};

/**
 * @param success The callback for success
 * @param error The callback for error
 */
Torch.prototype.turnOn = function( success, error ) 
{
   return PhoneGap.exec( success, error, "Torch", "turnOn", [] );   
};

/**
 * @param success The callback for success
 * @param error The callback for error
 */
Torch.prototype.turnOff = function( success, error ) 
{
   return PhoneGap.exec( success, error, "Torch", "turnOff", [] );   
};

/**
 * @param success The callback for success
 * @param error The callback for error
 */
Torch.prototype.toggle = function( success, error ) 
{
   return PhoneGap.exec( success, error, "Torch", "toggle", [] );   
};

/** Release camera resource, use it onPause method
 * @param success The callback for success
 * @param error The callback for error
 */
Torch.prototype.release = function( success, error ) 
{
   return PhoneGap.exec( success, error, "Torch", "release", [] );   
};
 
PhoneGap.addConstructor( function() 
{
	PhoneGap.addPlugin( "Torch", new Torch() );
} );