# Application Preferences plugin for Phonegap #
Originally by Simon MacDonald (@macdonst)

## Adding the Plugin to your project ##

1) To install the plugin, move applicationPreferences.js to your project's www folder and include a reference to it in your html files.

`<script type="text/javascript" charset="utf-8" src="applicationPreferences.js"></script>`

2) Create a folder called 'com/simonmacdonald/prefs' within your project's src folder.
3) And copy the AppPreferences.java file into that new folder.

`mkdir <your_project>/src/com/simonmacdonald/prefs`

`cp ./src/com/simonmacdonald/prefs/AppPreferences.java <your_project>/src/com/simonmacdonald/prefs`

4) In your res/xml/plugins.xml file add the following line:

    `<plugin name="applicationPreferences" value="com.simonmacdonald.prefs.AppPreferences"/>`

## Using the plugin ##
The plugin creates the object `window.plugins.applicationPreferences`

### get ###

In order to get the value a property you would call the get method.

    /**
      * Get the value of the named property.
      *
      * @param key           
      */
    get(key, success, fail)

Sample use:

    window.plugins.applicationPreference.get("key", success, fail);

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

    window.plugins.applicationPreference.set("key", "value", success, fail);

### load ###

In order to get all the properties you can call the load method. The success callback of the load method will be called with a JSONObject which contains all the preferences.

    /**
      * Get all the preference values.
      *
      */
    load(success, fail)

Sample use:

    window.plugins.applicationPreference.load(success, fail);

### show ###

If you want to load the PreferenceActivity of your application that displays all the preferences you can call the show method with the class name.

    /**
      * Get all the preference values.
      *
      */
    show(activity, success, fail)

Sample use:
    
    window.plugins.applicationPreference.show("com.simonmacdonald.prefs.PreferenceActivity", success, fail);
	
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