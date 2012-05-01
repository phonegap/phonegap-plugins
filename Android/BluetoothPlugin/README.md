Bluetooth
===============
Plugin for PhoneGap

The Bluetooth plugin offers access to the devices bluetooth functionality.
Useful for any application requiring interaction with the bluetooth stack.

Platforms
---------
Currently available on:

### Android
Copy the *BluetoothPlugin.java* file to your *src/* directory.

Edit your *AndroidManifest.xml* and add the following permissions:
`<uses-permission android:name="android.permission.BLUETOOTH" />`
`<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />`

In addition you have to edit your *res/xml/plugins.xml* file to let PhoneGap know about the plugin:
`<plugin name="BluetoothPlugin" value="com.phonegap.plugin.BluetoothPlugin"/>`


License
=======
   Copyright 2012 Wolfgang Koller - http://www.gofg.at/

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
