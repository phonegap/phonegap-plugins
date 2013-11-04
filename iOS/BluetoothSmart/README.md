Bluetooth-Smart-Plugin
======================
by Kristina Heyerdahl Elfving


---
### [This plugin is hosted by the author](https://github.com/KristinaHeyerdahlElfving/Bluetooth-Smart-Plugin)
---



DESCRIPTON
======================

This is a Bluetooth Low Energy (Bluetooth version 4, also called Bluetooth Smart) Plugin to use in Cordova (PhoneGap) projects targeted for the iOS platform. The plugin allow use of Bluetooth Smart in Cordova applications for iOS, and using the plugin require using Cordova. Some parts of the native code in the plugin is based on the Bluetooth Smart Health Thermometer profile, but can still be used with other Bluetoth Smart devices with some modification.

Bluetooth Smart is not yet (April 2013) supported by the Android operating system.

The plugin can be used for the following Bluetooth Smart actions:
- Search for Bluetooth Smart peripherals
- Connect to a discovered peripheral
- Discover services for peripheral
- Receive data from peripheral
- Disconnect from the connected peripheral


SAMPLE APPLICATION
======================

A sample application using the plugin is included in the "Sample Application" folder. The application can be run on an iPhone 4s or iPhone 5, and a Bluetooth Smart peripheral is needed for testing. 


PLUGIN SETUP FOR IOS
======================

Make sure Cordova is installed.

Copy the files in the www and blePlugin folders into your Cordova project. The www folder contains a cordova file, a plugin file, pluginFile.js, and a index.html file. The index.html is used for the interface, and can be replaced, but contains some examples showing how to use the plugin. pluginFile.js contains the JavaScript mappings for the plugin. 

Call the native code from the JavaScript interface in index.html. This is done using the mapping functions. An example:

search.callBlePSearch( blePSearchResultHandler, blePSearchErrorHandler, returnSuccess );

To retrieve data from the peripheral, some parts of the native code in the plugin may have to be changed. The Objective-C function blePNotify in blePluginClass.m is used for setting notification for Bluetooth Smart services, and here the UUID of the service and characteristic must be specified:

[self.CBP setNotificationForCharacteristic:self.CBP.currentPeripheral sUUID:@"1809" cUUID:@"2a1c" enable:TRUE];



FEEDBACK AND IMPROVEMENTS
======================

Please give feedback! The code will be improved if somebody have any suggestions or find bugs.


