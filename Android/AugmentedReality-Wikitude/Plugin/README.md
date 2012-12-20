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



##Prerequisites
* Having set-up [PhoneGap 2.x](http://docs.phonegap.com/en/2.0.0/guide_getting-
	started_android_index.md.html#Getting%20Started%20with%20Android) project.
* In case you didn't set `<uses-sdk android:minSdkVersion="8"/>` or higher in `AndroidManifest.xml` be aware that the Wikitude SDK runs only on Android 2.2+ devices (=Android SDK v8); you must not call the plugin on devices with lower SDK version.

## SETUP - 'Basic' Plugin


1. Create a folder called `com/wikitude/phonegap` within your project's `src`- folder and copy `WikitudePlugin.java` into it

2. Add following line to your `res/xml/config.xml`

    `<plugin name="WikitudePlugin" value="com.wikitude.phonegap.WikitudePlugin"/>`
    
3. Copy `WikitudePlugin.js` in `assets/www`-folder and ensure to include it in the related HTMLs.
    
        
4. Download the [Wikitude SDK](http://www.wikitude.com), copy the wikitudesdk.jar in the Android-folder to your projects `libs`-folder and add it to your project's build path
 
5. Visit [Wikitude Developer Site](http://developer.wikitude.com) to find Samples and license your app to get rid of the watermarking 



## Optional SETUP - 'Extended' Plugin (incl. Vuforia ImageRecognition)

####In case you use ImageRecognition in your project, you need to use this Extended Plugin instead of the Basic One.

Prerequisites: Having already set-up your [PhoneGap 2.x](http://docs.phonegap.com/en/2.0.0/guide_getting-started_android_index.md.html#Getting%20Started%20with%20Android) project.

1. Create a folder called `com/wikitude/phonegap` within your project's `src/` folder and opy `WikitudePlugin.java` and `WikitudePluginVuforia.java` into it.

2. Add following line to your `res/xml/config.xml`

3. Copy `WikitudePlugin.js` in `assets/www`-folder and ensure to include it in the related HTMLs.

	`<plugin name="WikitudePlugin" value="com.wikitude.phonegap.WikitudePluginVuforia"/>`
4. Download the [Wikitude SDK](http://www.wikitude.com), copy the wikitudesdk.jar in the Android-folder to your projects `libs`-folder and add it to your project's build path. Also copy the `libExtensionVuforia.so` into `libs/armeabi`

5.  Download Vuforia SDK from [Qualcomm Vuforia Website](https://ar.qualcomm.at/qdevnet/) and copy `QCAR.jar` to your projects `libs`-folder and add it to your project's build. Also copy Vuforia's `libQCAR.so`  to your `libs/armeabi`-folder

6. Visit [Wikitude Developer Site](http://developer.wikitude.com) to find Samples and license your app to get rid of the watermarking

## JAVASCRIPT INTERFACE
	
Its simple to use the Wikitude Plugin within your PhoneGap application.

We wrapped all ``` cordova.exec	``` calls into a separate JavaScript wrapper which handles location updates and some more functionality behind the scenes.

You will mainly work with the ``` WikitudePlugin ``` where all you have to do is to call ```Wikitude.isDeviceReady(successCallback, errorCallback)``` and in your successCallback, you can call ```WikitudePlugin.loadARchitectWorld(successCallback, errorCallback, "path/to/your/world")```.


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

