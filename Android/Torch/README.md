# Torch plugin for Phonegap (Android) #
By Arne de Bree

## Adding the Plugin to your project ##
1. To install the plugin, move `Torch.js` to your project's www folder and include a reference to it 
in your html files. 

    &lt;script src="Torch.js"&gt;&lt;/script&gt;

2. Create a folder called 'nl/debree/phonegap/plugin/torch' within your project's src folder.
3. And copy the java file into that new folder.

<pre>
    mkdir -p <your_project>/src/nl/debree/phonegap/plugin/torch/
    cp ./TorchPlugin.java <your_project>/src/nl/debree/phonegap/plugin/torch/
</pre>
    
4. Add a plugin line to `res/xml/plugins.xml`

    &lt;plugin name="Torch" value="nl.debree.phonegap.plugin.torch.TorchPlugin" /&gt;

## Using the plugin ##
The plugin creates the object `window.plugins.Torch` within your DOM. This object
exposes the following functions:

- isOn
- isCapable
- toggle
- turnOn
- turnOff

<pre>
    window.plugins.Torch.isOn( 
        function( result ) { console.log( "isOn: " + result.on ) }      // success
    ,   function() { console.log( "error" ) }                           // error
    );
    
    window.plugins.Torch.isCapable( 
        function( result ) { console.log( "isCapable: " + result.capable ) }      // success
    ,   function() { console.log( "error" ) }                           // error
    );
    
    window.plugins.Torch.toggle( 
        function() { console.log( "toggle" ) }                          // success
    ,   function() { console.log( "error" ) }                           // error
    );

    window.plugins.Torch.turnOn( 
        function() { console.log( "turnOn" ) }                          // success
    ,   function() { console.log( "error" ) }                           // error
    );

    window.plugins.Torch.turnOff( 
        function() { console.log( "turnOff" ) }                         // success
    ,   function() { console.log( "error" ) }                           // error
    );
</pre>
 
	
## BUGS AND CONTRIBUTIONS ##
The latest bleeding-edge version is available [on GitHub](http://github.com/adebrees/phonegap-plugins/tree/master/Android/)
If you have a patch, fork my repo baby and send me a pull request. Submit bug reports on GitHub, please.
	
## Licence ##

The MIT License

Copyright (c) 2011 Arne de Bree

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




	