# ZeroConf plugin for Cordova/Phonegap #
By [Matt Kane](https://github.com/ascorbic) / [Triggertrap Ltd](https://github.com/triggertrap). 

This plugin allows you to browse and publish ZeroConf/Bonjour/mDNS services.
It depends on [the JmDNS library](http://jmdns.sourceforge.net/).


## Adding the Plugin to your project ##

1. To install the plugin, move ZeroConf.js to your project's www folder and include a reference to it in your html files.
2. Create a folder called 'com/triggertrap/' within your project's src folder.
3. And copy the ZeroConf.java file into that new folder.
4. Download [the jmdns.jar file](https://github.com/twitwi/AndroidDnssdDemo/) 
and add it to your project's build path. In Eclipse, do this by right-clicking on it and choosing "Add to build path".
5. In your res/xml/plugins.xml file add the following line:

    `<plugin name="ZeroConf" value="com.triggertrap.ZeroConf"/>`

## Using the plugin ##

There are five static methods on the ZeroConf object, as follows:

### `watch(type, callback)`
Note that `type` is a fully-qualified service type, including the domain, e.g. `"_http._tcp.local."`

`callback` is a function that is called when services are added and removed. The function is passed 
an object with the following structure:

```javascript
{
	"service": {
		"port": 50930,
		"protocol": "tcp",
		"application": "http",
		"urls": ["http://192.168.2.2:50930", "http://fe80::7256:81ff:fe00:99e3:50930"],
		"description": "\\00",
		"name": "Black iPod",
		"domain": "local",
		"server": "",
		"addresses": ["192.168.2.2", "fe80::7256:81ff:fe00:99e3"],
		"type": "_http._tcp.local.",
		"qualifiedname": "Black iPod._http._tcp.local."
	},
	"action": "added"
}

```
For more information on the fields, see [the JmDNS docs](http://jmdns.sourceforge.net/apidocs/javax/jmdns/ServiceInfo.html).
If you edit ZeroConf.java, you can easily add more fields if you need them.

### `unwatch(type)`
Stops watching for services of the specified type.

### `close()`
Closes the service browser and stops watching.

### `register(type, name, port, text)`
Publishes a new service. The fields are as in the structure above. For more information, 
see [the JmDNS docs](http://jmdns.sourceforge.net/apidocs/javax/jmdns/ServiceInfo.html).

### `unregister()`
Unregisters all published services.
	
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