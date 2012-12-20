	    Copyright 2012 Bruno Carreira - Lucas Farias - Rafael Luna - Vinícius Fonseca. 

		Licensed under the Apache License, Version 2.0 (the "License");
		you may not use this file except in compliance with the License.
		You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

		Unless required by applicable law or agreed to in writing, software
		distributed under the License is distributed on an "AS IS" BASIS,
		WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
		See the License for the specific language governing permissions and
   		limitations under the License.  

Foreground Camera Plugin for Phonegap (Cordova).

Originally by: 	- Bruno Carreira
				- Lucas Farias
				- Rafael Luna
				- Vinicius Fonseca

The default Phonegap (Cordova) Camera Plugin calls the native camera and this makes Android Garbage Collector to kill background applications. This plugin avoid your application to go background and be killed by Garbage Collector with other applications. We used the Phonegap source code and modified it to avoid this problem. This plugin works only with File URI. 

Adding the plugin to your project

    1) To install the plugin, move the file camera.js to your project's www folder and include a reference to it in your html files.
    2) Put the Java files in your src/ folder.
    3) Change the default Camera Plugin into res/xml/plugins.xml file to <plugin name="Camera" value="<path to your ForegroundCameraLauncher.java>"/>.
	4) Put the strings.xml in your res/values folder.
	5) Put the foregroundcameraplugin.xml in your res/layout folder.
	6) In you AndroidManifest.xml, put this permissions:
		    <uses-feature android:name="android.hardware.camera" />
			<uses-feature android:name="android.hardware.camera.autofocus" />
		And declare the Camera Activity:
			<activity
				android:name=".CameraActivity"
				android:label="ForegroundCameraPlugin"
				android:screenOrientation="landscape" >
			</activity>

Using the plugin

	See the index.xhtml.