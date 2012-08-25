# Resources plugin for Phonegap (Android) #
By Olivier Brand

## Adding the Plugin to your project ##
1. To install the plugin, move `Resources.js` to your project's www folder and include a reference to it 
in your html files. 

    &lt;script src="Resources.js"&gt;&lt;/script&gt;

2. Create a folder called 'com/phonegap/plugin/resources' within your project's src folder.
3. And copy the java file into that new folder.

<pre>
    mkdir -p <your_project>/src/com/phonegap/plugin/resources
    cp ./ResourcesPlugin.java <your_project>/src/com/phonegap/plugin/resources
</pre>
    
4. Add a plugin line to `res/xml/plugins.xml`

    &lt;plugin name="Resources" value="com.phonegap.plugin.resources.ResourcesPlugin" /&gt;

## Using the plugin ##

<pre>

res/values/strings.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="login">mylogin</string>
    <string name="base_uri">/someuri</string>
</resources>


	
this.resources = window.plugins.resources.getStringResources({
              'resources': [
                   'base_uri', 'login'
               ],
               'package': 'com.androidapp.app'
 });
 
console.log(this.resources.base_uri);
 
</pre>