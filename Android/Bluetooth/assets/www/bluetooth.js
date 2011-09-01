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


var Bluetooth = { 

	
/**
 * @param argument Argument that we are going to pass to the plugin - for this method no arguments are needed
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
listDevices : function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'listDevices', [argument]);       
},



/**
 * @param argument Argument that we are going to pass to the plugin - for this method no arguments are needed
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
isBTEnabled : function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'isBTEnabled', [argument]);       
},



/**
 * @param argument Argument that we are going to pass to the plugin - for this method no arguments are needed
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
enableBT : function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'enableBT', [argument]);       
},



/**
 * @param argument Argument that we are going to pass to the plugin - for this method no arguments are needed
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
disableBT : function(argument,successCallback, failureCallback) {

    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'disableBT', [argument]);       
},


/**
 * @param argument Argument that we are going to pass to the plugin, you need pass the MAC address of the bluetooth device with wich you want to pair
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
pairBT : function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'pairBT', [argument]);    
},


/**
 * @param argument Argument that we are going to pass to the plugin, you need pass the MAC address of the bluetooth device that you want unpair
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
unPairBT : function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'unPairBT', [argument]);    
},


/**
 * @param argument Argument that we are going to pass to the plugin - for this method no arguments are needed
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
listBoundDevices : function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'listBoundDevices', [argument]);      
},



/**
 * @param argument Argument that we are going to pass to the plugin - for this method no arguments are needed
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
stopDiscovering : function(argument,successCallback, failureCallback) {

    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'stopDiscovering', [argument]);      
},


/**
 * @param argument Argument that we are going to pass to the plugin, you need pass the MAC address of the mobile that you want to know if it is bound
 * @param successCallback The callback which will be called when listDevices is successful
 * @param failureCallback The callback which will be called when listDevices encouters an error
 */
isBound : function(argument,successCallback, failureCallback) {
	
    return PhoneGap.exec(successCallback, failureCallback, 'BluetoothPlugin', 'isBound', [argument]);   
}

};


PhoneGap.addConstructor(function() {
PhoneGap.addPlugin('Bluetooth', new Bluetooth());
});