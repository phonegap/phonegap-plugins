PowerManagement
===============
Plugin for Cordova (1.6+)

The PowerManagement plugin offers access to the devices power-management functionality.
It should be used for applications which keep running for a long time without any user interaction.

For details on power functionality see:

* Android: [PowerManager](http://developer.android.com/reference/android/os/PowerManager.html)
* iOS: [idleTimerDisabled](http://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplication_Class/Reference/Reference.html#//apple_ref/occ/instp/UIApplication/idleTimerDisabled)

Platforms
---------
Currently available on:

### Android
Copy the *PowerManagement.java* file to your *src/* directory.

Edit your *AndroidManifest.xml* and add the following permission:
`<uses-permission android:name="android.permission.WAKE_LOCK" />`

In addition you have to edit your *res/xml/plugins.xml* file to let PhoneGap know about the plugin:
`<plugin name="PowerManagement" value="org.apache.cordova.plugin.PowerManagement"/>`

### iOS
Copy the *PowerManagement.h* and *PowerManagement.m* files to your project.

Add the PowerManagement plugin to the *PhoneGap.plist*:
See http://wiki.phonegap.com/w/page/41733808/PhoneGap-iOS-Plugins-Problems


License
=======
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
