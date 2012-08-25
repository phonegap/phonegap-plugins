# RemoteSound plugin for Phonegap (Android) #
By Olivier Brand

## Adding the Plugin to your project ##
1. To install the plugin, move `RemoteSound.js` to your project's www folder and include a reference to it 
in your html files. 

    &lt;script src="RemoteSound.js"&gt;&lt;/script&gt;

2. Create a folder called 'com/phonegap/plugin/remotesound' within your project's src folder.
3. And copy the java file into that new folder.

<pre>
    mkdir -p <your_project>/src/com/phonegap/plugin/remotesound
    cp ./RemoteSoundPlugin.java <your_project>/src/com/phonegap/plugin/remotesound
</pre>
    
4. Add a plugin line to `res/xml/plugins.xml`

    &lt;plugin name="RemoteSound" value="com.phonegap.plugin.remotesound.RemoteSoundPlugin" /&gt;

## Using the plugin ##

<pre>

<!-- Play a sound -->
window.plugins.remotesound.playRemoteSound({
               'soundURL': 'http://myserver/sounds/mysound.wav'
 });
 
<!-- Load remote sounds -->
window.plugins.remotesound.playRemoteSound({
               'soundURLs': ['http://myserver/sounds/mysound.wav', 'http://myserver/sounds/mysound2.wav']
 });
 
</pre>