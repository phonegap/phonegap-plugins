<h1>MacAddress plugin for Phonegap (Cordova) </h1>
<p>By Joey Wong (Huang Jun Yan) Updated for Cordova 2.4.0</p>


This is the plugins to help you get the iOS WIFI MAC address 

The UDID API is deprecated in iOS 5. To get a unique identifier, maybe you need to turn to iPhones/iPad/iPod touch' MAC address instead.


<h1>INSTALL</h1>
=========================

1. Drag the <code>Macaddress.h, Macaddress.m </code>into the <code>"Plugins"</code> folder in Xcode.

2. Attach the <code>"macaddress.js"</code> to your <code>www</code> folder

3. Don't forget to enable the plugins in Cordova <code>config.xml</code> (for Cordova 2.3 or higher)

Add this:

<code>
&lt;plugin name="Macaddress" value="Macaddress" /&gt; 
</code>

For older version, please modify the PhoneGap.plist file of your application. Under the key "Plugins" add another one with key name
Macaddress and value Macaddress. 

<h1> How to use</h1>
==========================================
Get the WIFI MAC address by following script :

<pre>
plugins.macaddress.getMacAddress(function(response){
                                    alert('MAC Address:'+response);
                                  },function(errorMsg){
                                    alert('Error:'+errorMsg);
                                  });
</pre>

Voila !~
