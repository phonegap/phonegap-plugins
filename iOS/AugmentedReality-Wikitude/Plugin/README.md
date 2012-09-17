# Augmented Reality - Wikitude SDK Plugin
by Wikitude GmbH - [www.wikitude.com](http://www.wikitude.com)

Interested in advanced usage of the plugin and need assistance? 
[Register as a Wikitude developer](http://developer.wikitude.com) and get support in our forum.

For further questions visit us on www.wikitude.com or contact us via `phonegap <at> wikitude.com`

#### Important: This plugin runs on latest [PhoneGap 2.x](http://docs.phonegap.com/en/2.0.0/guide_getting-started_android_index.md.html#Getting%20Started%20with%20Android) only


## DESCRIPTION 


The Wikitude PhoneGap Plugin enables web developers to embed an Augmented Reality view into their PhoneGap project. One can create a fully featured app with advanced Augmented Reality features, including Image Recognition, purely using HTML, CSS and Javascript.

###The Wikitude PhoneGap Plugin

* Available for iOS and Android
* Simple and seamless native PhoneGap integration
* Fully customizable Augmented Realty view
* Includes the full feature set of the Wikitude SDK
* AR content is purely written in HTML and JavaScript

![image](http://www.wikitude.com/wp-content/uploads/2012/09/Plugin_Phonegap.png)

###The Augmented Reality View
From a technical point of view the SDK adds a UI component, similar to a web view. In contrast to a standard web view this AR view can render Augmented Reality content.

Note: Content developed for this AR View is written in JavaScript and HTML. The .html and .js files for this view are different from the PhoneGap .js and .html files. The AR engine working in the background is called ARchitect Engine and is powering the SDK.

###Further developer resources
* [Full documentation and additional tutorials](http://forum.wikitude.com/documentation)
* [Developer Forum](http://forum.wikitude.com/home)
* [Wikitude SDK Download](http://forum.wikitude.com/download)
* [Google+ Page for News](https://plus.google.com/u/0/103004921345651739447/posts)
* [Developer Newsletter](http://www.wikitude.com/developer/newsletter)



## SETUP

* Create a new PhoneGap project with the command line tool provided by PhoneGap.
* After your created the project, switch to Finder and copy the WikitudePlugin.h and .m file into the Plugins folder of your PhoneGap project. Afterwards, you have to add the files to the Plugins Group in your Xcode project.
* Add a new entry with key ``` WikitudePlugin ``` and value ``` WTWikitudePlugin ``` to ``` Plugins ``` in ``` Cordova.plist ```
* Copy the Wikitude SDK for iOS (which you can downloaded from [our website](http://www.wikitude.com/developer/sdk)) into a folder like ```[ProjectFolder/"AppName"/WikitudeSDK] ```in your Xcode project. Make sure that you not only copy the files into the correct destination but that you also add the files to the Xcode project.

	* if you want to use Image Recognition within your App, you need to copy the Vuforia SDK folder into a folder like ```[ProjectFolder/"AppName"/Vuforia]```. Also dont forget to add the files to your Xcode project. You can download the Vuforia SDK from [Qualcomm](https://ar.qualcomm.at/sdk/ios).

	
* Add the Following Frameworks to your project:
 
	* CoreMotion.framework

	* CoreVideo.framework

	* libz.dylib

	* libsqlite3.dylib

	* OpenGLES.framework

	* Security.framework

* You need to change one linker flag in order to run your App with the WikitudeSDK. Go to your project settings and change the other linker flag ```'-all_load'``` to ```'-force_load $(BUILT_PRODUCTS_DIR)/libCordova.a'```. After that, please add the following linker flag: ```-lstdc++```.

* If you want to test your application on the iPhone Simulator, you'll need to change an additional Library Serach Path in your Xcode project settings. 
	
	 Change ```"$(SRCROOT)/HelloWorld/WikitudeSDK/SDK/lib/Release-iphoneos" ```	
	 To ```"$(SRCROOT)/HelloWorld/WikitudeSDK/SDK/lib/Release$(EFFECTIVE_PLATFORM_NAME)"```
	 
	 And delete ```"$(SRCROOT)/HelloWorld/WikitudeSDK/SDK/lib/Release-iphonesimulator"```


* The last step is to edit the whitelist entries. Open the Cordova.plist and add a new entry to the 'ExternalHosts' Array: * (single Asterisk)


## JAVASCRIPT INTERFACE
	
Its simple to use the Wikitude Plugin within your PhoneGap application.

We wrapped all ``` cordova.exec	 ``` calls into a separate JavaScript wrapper which handles location updates and some more functionality behind the scenes.

You will mainly work with the ``` WikitudePlugin ``` where all you have to do is to call ```Wikitude.isDeviceReady(successCallback, errorCallback)``` and in your successCallback, you can call ```WikitudePlugin.loadARchitectWorld(successCallback, errorCallback, "path/to/your/world")```.

If you want to communicate directly via the ```cordova.exec``` JavaScript calls, have a look at the ```Documentation``` folder which includes more information about that.
	

## Getting STARTED

To get started, we prepared two sample projects. You can read through this samples to understand how to use the JavaScript wrapper and how you add your ARchitect World into the project. There is also a ReadMe for both projects which explain you what you have to do to get them running.

Note:
If you have purchased a Wikitude SDK license, you can enter you SDK Key in the ```WikitudePlugin.js``` file at line 9.


## LICENSE

   Copyright 2012 [Wikitude GmbH ](http://www.wikitude.com)

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.