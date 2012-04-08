# File Uploader plugin for Phonegap - iPhone version #
By Matt Kane

Enables multipart/mime file uploads.

## Adding the Plugin to your project ##

Copy the .h and .m file to the Plugins directory in your project. Copy the .js file to your www directory and reference it from your html file(s).


## Using the plugin ##
The plugin creates the object `window.plugins.fileUploader` with two methods, `upload` and `uploadByUri`. 
These are identical except for the format of the reference to the file to upload. `upload` takes an
absolute path, e.g. `/var/tmp/photo_001.jpg`, while `uploadByUri` takes a file:// Uri,
e.g. `file://localhost/var/tmp/photo_001.jpg`.
The full params are as follows:

* server URL of the server that will receive the file
* file Absolute path or uri of the file to upload
* params Object with key: value params to send to the server
* fileKey Parameter name of the file
* fileName Filename to send to the server. Defaults to image.jpg
* mimeType Mimetype of the uploaded file. Defaults to image/jpeg
* success Success callback. Passed the response data from the server as a string.
* fail Error callback. Passed the error message.
* progress Called on upload progress. Signature should be function(bytesUploaded, totalBytes)

Here is a simple example usage.

    window.plugins.fileUploader.uploadByUri('http://example.com/upload', 'file://path/to/file.jpg', {foo: 'bar'}, 'myPhoto', 'anImage.jpg', 'image/jpeg', 
    			function(result) {
    				console.log('Done: ' + result);
    			}, 
    			function(result) {
    			    console.log("Error: " + result);
    			}, 
    			function(loaded, total) {
    				var percent = 100 / total * loaded;
    				console.log('Uploaded  ' + percent);

    			}
    		);


    


This is under development, and the API is likely to change.

	
## BUGS AND CONTRIBUTIONS ##
The latest bleeding-edge version is available [on GitHub](http://github.com/ascorbic/phonegap-plugins/)
If you have a patch, fork my repo and send me a pull request. Submit bug reports on GitHub, please.
	
## Licence ##

The MIT License

Copyright (c) 2011 Matt Kane

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




