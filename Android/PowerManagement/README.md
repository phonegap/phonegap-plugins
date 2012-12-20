PowerManagement
===============
Plugin for Cordova (2.0+)

The PowerManagement plugin offers access to the devices power-management functionality.
It should be used for applications which keep running for a long time without any user interaction.

For details on power functionality see:

* Android: [PowerManager](http://developer.android.com/reference/android/os/PowerManager.html)

Installation
---------
Copy the **PowerManagement.java** file to your *src/org/apache/cordova/plugin* directory.

Copy the **powermanagement.js** file to your *assets/www/js* directory.

Edit your **AndroidManifest.xml** and add the following permission:
`<uses-permission android:name="android.permission.WAKE_LOCK" />`

Edit your **res/xml/config.xml** and add the following plugin:
`<plugin name="PowerManagement" value="org.apache.cordova.plugin.PowerManagement"/>`

Usage
---------

Add this script tag to your **index.html** file, *after* calling your Cordova .js file:
`<script type="text/javascript" charset="utf-8" src="js/powermanagement.js"></script>`

Add the following code to your app's .js file, inside the function called by [deviceready](http://docs.phonegap.com/en/2.0.0/cordova_events_events.md.html#deviceready):
<pre>
var powerman = window.plugins.powerManagement;
</pre>

There are three available methods to call:

<pre>powerman.acquire(successCallback, failureCallback)</pre>
Acquires a 'wake-lock', preventing the device screen from going to sleep.

<pre>powerman.dim(successCallback, failureCallback)</pre>
Acquires a partial 'wake-lock', allowing the screen to dim but preventing the device from going to sleep.

<pre>powerman.release(successCallback, failureCallback)</pre>
Release an acquired 'wake-lock'. Device able to sleep again.

License
---------
Copyright (C) 2011-2012 Wolfgang Koller

This file is part of GOFG Sports Computer - http://www.gofg.at/.

GOFG Sports Computer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

GOFG Sports Computer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GOFG Sports Computer.  If not, see <http://www.gnu.org/licenses/>.
