# MacAddress plugin for Phonegap (Android) #
By Olivier Brand

## Adding the Plugin to your project ##
1. To install the plugin, move `MacAddress.js` to your project's www folder and include a reference to it 
in your html files. 

    &lt;script src="MacAddress.js"&gt;&lt;/script&gt;

2. Create a folder called 'com/phonegap/plugin/macaddress' within your project's src folder.
3. And copy the java file into that new folder.


<pre>
    mkdir -p <your_project>/src/com/phonegap/plugin/macaddress
    cp ./ResourcesPlugin.java <your_project>/src/com/phonegap/plugin/macaddress
</pre>
    
4. Set the permissions into the Android Manifest for accessing the mac address.

<pre>
	&lt;uses-permission android:name="android.permission.ACCESS_WIFI_STATE" /&gt;
</pre>
    
5. Add a plugin line to `res/xml/plugins.xml`

    &lt;plugin name="MacAddress" value="com.phonegap.plugin.macaddress.MacAddressPlugin" /&gt;

## Using the plugin ##

<pre>
	
 var networkInterface = {};
 // Get network interface   
 networkInterface = window.plugins.macaddress.getMacAddress();
            
 
console.log(networkInterface.mac);
 
</pre>