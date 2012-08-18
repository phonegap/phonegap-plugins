/*
   Copyright 2012 Wolfgang Koller - http://www.gofg.at/
   
   Modified and improved Agust, 2012 Hüseyin Kozan http://huseyinkozan.com.tr

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

cordova.define("cordova/plugin/bluetooth", function(require, exports, module) {
	var exec = require('cordova/exec');
	
	var Bluetooth = function() {};
	
	/**
	 * Check if Bluetooth API is supported on this platform
	 * @returns true if Bluetooth API is supported, false otherwise
	 */
	Bluetooth.prototype.isSupported = function(successCallback,failureCallback) {
		return exec(successCallback, failureCallback, 'BluetoothPlugin', 'isSupported', []);
	}
	
	/**
	 * Enable Bluetooth
	 * 
	 * @param successCallback function to be called when enabling of Bluetooth was successful
	 * @param errorCallback function to be called when enabling was not possible / did fail
	 */
	Bluetooth.prototype.enable = function(successCallback,failureCallback) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'enable', []);
	}
	
	/**
	 * Disable Bluetooth
	 * 
	 * @param successCallback function to be called when disabling of Bluetooth was successful
	 * @param errorCallback function to be called when disabling was not possible / did fail
	 */
	Bluetooth.prototype.disable = function(successCallback,failureCallback) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'disable', []);
	}
	
	/**
	 * Checks if Bluetooth is enabled
	 * 
	 * @param successCallback function to be called after successful return.
	 * @param errorCallback function to be called due to failure
	 */
	Bluetooth.prototype.isEnabled = function(successCallback,failureCallback) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'isEnabled', []);
	}
	
	/**
	 * Returns device address as string.
	 * 
	 * For example, "00:11:22:AA:BB:CC".
	 * 
	 * @param successCallback function to be called when getting the adapter address. \
	 * Passed parameter is a string that denotes own adapter address.
	 * @param errorCallback function to be called due to failure
	 */
	Bluetooth.prototype.getAddress = function(successCallback,failureCallback) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'getAddress', []);
	}
	
	/**
	 * Returns device name as string.
	 * 
	 * @param successCallback function to be called when getting the adapter's friendly name. \
	 * Passed parameter is a string that denotes own adapter name.
	 * @param errorCallback function to be called due to failure
	 */
	Bluetooth.prototype.getName = function(successCallback,failureCallback) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'getName', []);
	}
	
	/**
	 * Request discoverable from user for given duration
	 * 
	 * @param successCallback function to be called after user confirms request. \
	 * Passed parameter is an integer which denotes given duration by the system.
	 * @param errorCallback function to be called when there was a problem while requesting
	 * @param duration default is 120, maximum is 300 seconds
	 */
	Bluetooth.prototype.requestDiscoverable = function(successCallback,failureCallback, duration) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'requestDiscoverable', [duration]);
	}
	
	/**
	 * Search for devices  and list them
	 * 
	 * @param successCallback function to be called when discovery of other devices has finished. \
	 * Passed parameter is a JSONArray containing JSONObjects with 'name', 'address' and 'isBonded' property.
	 * @param errorCallback function to be called when there was a problem while discovering devices
	 */
	Bluetooth.prototype.startDiscovery = function(successCallback,failureCallback) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'startDiscovery', []);
	}
	
	/**
	 * Cancels ongoing discovery
	 * 
	 * @param successCallback function to be called after successfully canceled.
	 * @param errorCallback function to be called due to failure
	 */
	Bluetooth.prototype.cancelDiscovery = function(successCallback,failureCallback) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'cancelDiscovery', []);
	}
	
	
	/**
	 * Return bonded (paired) devices
	 * 
	 * @param successCallback function to be called after success. \
	 * Passed parameter is a JSONArray containing JSONObjects with 'name', 'address' and 'isBonded' property.
	 * @param errorCallback function to be called due to failure
	 */
	Bluetooth.prototype.getBondedDevices = function(successCallback,failureCallback) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'getBondedDevices', []);
	}
	
	/**
	 * Return list of available UUIDs for a given device
	 * 
	 * Needs minimum SDK API 15
	 * 
	 * @param successCallback function to be called when listing of UUIDs has finished. \
	 * Passed parameter is a JSONArray containing strings which represent the UUIDs
	 * @param errorCallback function to be called when there was a problem while listing UUIDs
	 * @param address address of the remote
	 */
	Bluetooth.prototype.fetchUUIDs = function(successCallback,failureCallback,address) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'fetchUUIDs', [address]);
	}
	
	/**
	 * Open an RFComm channel for a given device & uuid endpoint
	 * 
	 * @param successCallback function to be called when the connection was successful. \
	 * Passed parameter is an integer containing the socket id for the connection
	 * @param errorCallback function to be called when there was a problem while opening the connection
	 */
	Bluetooth.prototype.connect = function(successCallback,failureCallback,address,uuid) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'connect', [address, uuid]);
	}
	
	/**	
	* Open an insecure RFComm channel for a given device & uuid endpoint
	* 
	* Needs minimum SDK API 10
	*
	* @param successCallback function to be called when the connection was successful. \
	* Passed parameter is an integer containing the socket id for the connection
	* @param errorCallback function to be called when there was a problem while opening the connection
	*/
	Bluetooth.prototype.connectInsecure = function(successCallback,failureCallback,address,uuid) {
		return exec(successCallback, failureCallback, 'BluetoothPlugin', 'connectInsecure', [address, uuid]);
	}
	
	/**
	 * Close a RFComm channel for a given socket-id
	 * 
	 * @param successCallback function to be called when the connection was closed successfully
	 * @param errorCallback function to be called when there was a problem while closing the connection
	 */
	Bluetooth.prototype.disconnect = function(successCallback,failureCallback,socketid) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'disconnect', [socketid]);
	}
	
	
	// TODO : not implemented
	/**
	 * Listens incoming connections
	 * 
	 * @param successCallback function to be called when the connection was closed successfully
	 * @param errorCallback function to be called when there was a problem while closing the connection
	 */
	Bluetooth.prototype.listen = function(successCallback,failureCallback,name,uuid) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'listen', [name,uuid]);
	}
	
	
	/**
	 * Read from a connected socket
	 * 
	 * @param successCallback function to be called when reading was successful. \
	 * Passed parameter is a string containing the read content
	 * @param errorCallback function to be called when there was a problem while reading
	 */
	Bluetooth.prototype.read = function(successCallback,failureCallback,socketid) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'read', [socketid]);
	}
	
	/**
	 * Write to a connected socket
	 * 
	 * For example, write(function(){success;},function(error){},1,{10,20,30,40});
	 * 
	 * @param successCallback function to be called when writing was successful.
	 * @param errorCallback function to be called when there was a problem while writing
	 */
	Bluetooth.prototype.write = function(successCallback,failureCallback,socketid,jsonarray) {
	    return exec(successCallback, failureCallback, 'BluetoothPlugin', 'write', [socketid,jsonarray]);
	}
	
	var bluetooth = new Bluetooth();
	module.exports = bluetooth;
});
