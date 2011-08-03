/* Copyright (c) 2011 - Andago
 * 
 * author: Daniel Tizón
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */



/**
 *  
 * @return Instance of Bluetooth
 */
var Bluetooth = function() { 

}

/**
 * @param argument Argument that we are going to pass to the plugin - for this method no arguments are needed
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
Bluetooth.prototype.listDevices = function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'listDevices', [argument]);       
};



/**
 * @param argument Argument that we are going to pass to the plugin - for this method no arguments are needed
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
Bluetooth.prototype.isBTEnabled = function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'isBTEnabled', [argument]);       
};



/**
 * @param argument Argument that we are going to pass to the plugin - for this method no arguments are needed
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
Bluetooth.prototype.enableBT = function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'enableBT', [argument]);       
};



/**
 * @param argument Argument that we are going to pass to the plugin - for this method no arguments are needed
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
Bluetooth.prototype.disableBT = function(argument,successCallback, failureCallback) {

    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'disableBT', [argument]);       
};


/**
 * @param argument Argument that we are going to pass to the plugin, you need pass the MAC address of the mobile with wich you want to pair
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
Bluetooth.prototype.pairBT = function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'pairBT', [argument]);    
};



/**
 * @param argument Argument that we are going to pass to the plugin - for this method no arguments are needed
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
Bluetooth.prototype.listBoundDevices = function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'listBoundDevices', [argument]);      
};



/**
 * @param argument Argument that we are going to pass to the plugin - for this method no arguments are needed
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
Bluetooth.prototype.stopDiscovering = function(argument,successCallback, failureCallback) {

    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'stopDiscovering', [argument]);      
};


/**
 * @param argument Argument that we are going to pass to the plugin, you need pass the MAC address of the mobile that you want to know if it is bound
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
Bluetooth.prototype.isBound = function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'isBound', [argument]);   
};



/**
 * <ul>
 * <li>Register the Bluetooth Javascript plugin.</li>
 * <li>Also register native call which will be called when this plugin runs</li>
 * </ul>
 */
PhoneGap.addConstructor(function() {
	//Register the javascript plugin with PhoneGap
	PhoneGap.addPlugin('bluetooth', new Bluetooth());
	
	//Register the native class of plugin with PhoneGap
	navigator.app.addService("BluetoothPlugin","com.phonegap.plugin.bluetooth.BluetoothPlugin");
	//PluginManager.addService("BluetoothPlugin","com.phonegap.plugin.bluetooth.BluetoothPlugin");
});