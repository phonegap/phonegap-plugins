# BinaryFileWriter plugin for Android/Phonegap
Antonio Hernández <ahernandez@emergya.com>

## Using the plugin

* Add java code to your project's build source

* Add javascript code to your project's www directory

* Include the javascript in your HTML

```
<script type="text/javascript" src="binaryfilewriter.js"></script>
```

* Register the plugin in the plugins.xml file

```xml
<plugin name="BinaryFileWriter" value="com.phonegap.plugins.binaryfilewriter.BinaryFileWriter" />
```

* The plugin extends PhoneGap FileWriter object with FileWriter.writeBinaryArray() method, so you can use it
the same way you use the FileWriter.write() method.

```javascript
var data = /* Some kind of typed array like Uint8Array ... */;

function win(writer) {

    writer.onwrite = function(evt) {
        console.log("write success");
    };

    writer.writeBinaryArray(data);
};

var fail = function(evt) {
    console.log(error.code);
};

entry.createWriter(win, fail);
```

## License

The MIT License

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
