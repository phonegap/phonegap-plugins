# HeadsetWatcher plugin for Cordova/Phonegap #
By Matt Kane / Triggertrap Ltd. 

This plugin allows you to watch for headphones being plugged or unplugged from a device.
It does this by registering for ACTION_HEADSET_PLUG notifications.


## Adding the Plugin to your project ##

1. To install the plugin, move HeadsetWatcher.js to your project's www folder and include a reference to it in your html files.
2. Create a folder called 'com/triggertrap/' within your project's src folder.
3. And copy the HeadsetWatcher.java file into that new folder.
4. In your res/xml/plugins.xml file add the following line:

    `<plugin name="HeadsetWatcher" value="com.triggertrap.HeadsetWatcher"/>`

## Using the plugin ##

There is a single method to call: `HeadsetWatcher.watch(callback)`. 
The callback is a function, which is passed an object with the single boolean 
property `plugged`, which indicates whether the headset is currently plugged in. 
It is a persistent callback, and will be called whenever the action occurs.
The callback will also be called immediately when first registered.

The static property HeadsetWatcher.plugged is also set once watch has been called.

```javascript
 
  HeadsetWatcher.watch(function(result) {
    if(result.plugged) {
      alert("The headphones have been plugged in!");
    } else {
      alert("The headphones have been unplugged!");
    }

  })


```
	
## Licence ##

The MIT License

Copyright © 2012 Triggertrap Ltd.

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