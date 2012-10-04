# Application Preferences plugin for Phonegap #
Originally by Simon MacDonald (@macdonst)

Please note that the following steps are for PhoneGap 2.0

Information on writing plugins for PhoneGap 2.0 was taken from [this blog](http://simonmacdonald.blogspot.com/2012/08/so-you-wanna-write-phonegap-200-android.html) by Simon MacDonald (@macdonst)

## Adding the Plugin to your project ##

1) To install the plugin, move applicationPreferences.js to your project's www folder and include a reference to it in your html files.

`<script type="text/javascript" charset="utf-8" src="applicationPreferences.js"></script>`

2) Create a folder called 'com/simonmacdonald/prefs' within your project's src folder.
3) And copy the AppPreferences.java file into that new folder.

`mkdir <your_project>/src/com/simonmacdonald/prefs`

`cp ./src/com/simonmacdonald/prefs/AppPreferences.java <your_project>/src/com/simonmacdonald/prefs`

4) In your `res/xml/config.xml` file add the following element as a child to the `<plugins>` element.

   `<plugin name="applicationPreferences" value="com.simonmacdonald.prefs.AppPreferences"/>`

## Using the plugin ##

Create an object to be used to call the defined plugin methods.

    var preferences = cordova.require("cordova/plugin/applicationpreferences");

The `preferences` object created above will be used in the following examples.

### get ###

In order to get the value a property you would call the get method.

    /**
      * Get the value of the named property.
      *
      * @param key           
      */
    get(key, success, fail)

Sample use:

    preferences.get("myKey", function(value) {
			alert("Value is " + value);
		}, function(error) {
			alert("Error! " + JSON.stringify(error));
	});

### set ###

In order to set the value a property you would call the set method.

    /**
      * Set the value of the named property.
      *
      * @param key
      * @param value           
      */
    set(key, value, success, fail)

Sample use:

    preferences.set("myKey", "myValue", function() {
			alert("Successfully saved!");
		}, function(error) {
			alert("Error! " + JSON.stringify(error));
	});


### remove ###

In order to remove a key along with the value, you would call the remove method.

    /**
	  * Remove the key along with the value
	  *
	  * @param key      
      */
     remove(key, success, fail)

Sample use:

		preferences.remove("myKey", function(value) {
			alert("Value removed!");
		}, function(error) {
			alert("Error! " + JSON.stringify(error));
		});

### clear ###

In order to remove all shared preferences, you would call the clear method.

     /**
	  * Clear all shared preferences
	  *	       
	  */
     clear(success, fail)

Sample use:

		preferences.clear(function() {
			alert("Cleared all preferences!");
		}, function(error) {
			alert("Error! " + JSON.stringify(error));
		});

### load ###

In order to get all the properties you can call the load method. The success callback of the load method will be called with a JSONObject which contains all the preferences.

    /**
      * Get all the preference values.
      *
      */
    load(success, fail)

Sample use:

    preferences.load(function(prefs) {
			alert(JSON.stringify(prefs));
		}, function() {
			alert("Error! " + JSON.stringify(error));
	});

### show ###

If you want to load the PreferenceActivity of your application that displays all the preferences you can call the show method with the class name.

    /**
      * Get all the preference values.
      *
      */
    show(activity, success, fail)

Sample use:
    
    function showPreferenceActivity() {
		preferences.show("com.ranhiru.apppreferences.PreferenceActivity", function() {
			alert("Showing Preferences Activity!");
		}, function(error) {
			alert("Error! " + JSON.stringify(error));
		});
	  }
	
## Licence ##

The MIT License

Copyright (c) 2012 Simon MacDonald

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.