# Downlaoder plugin for Phonegap #

A plugin that downloads file from the web (http) to the device.

## Adding the plugin to your project ##

1. To install the plugin, move downloader.js to your project's www folder and include a reference to it in your html files. 
2. Create a folder called 'com/phonegap/plugins/downloader' within your project's src/ folder.
3. And copy the java file into that new folder.
4. Add the following to res/xml/plugins.xml file `<plugin name="Downloader" value="com.phonegap.plugins.downloader.Downloader"/>`

## Using the plugin ##

The plugin creates the object `window.plugins.downloader` with one method `downloadFile(url, params, success, fail)`

`url` is the url of the file to be downloaded. i.e. http://server/file.ext

`params` is a json object containing optional parameters that Downloader accepts, it can be:

* dirName: Name of the directory to download the file to. By default "sdcard/download"
* fileName: Name of the file to be downloaded. By default the same as the one in `url`.
* overwrite: If the file already exists, download it again.
 
`success` and `fail` are callback functions. Success will be called when there is a progress in the download. The passed object is:

    {
        status: 0,        //0 means progress, 1 means download is complete.
        progress: 46,     //In percent
        total: 1000,      //The total number of bytes to download.
        file: "file.ext"  //Name of the file
    }

An example could be:

    window.plugins.downloader.downloadFile("http://server/file.txt", {overwrite: true}, 
	      function(res) {
            alert(JSON.stringify(result));
        }, function(error) {
		    alert(error);
	    }
	);
	
I will be happy to receive any comment, patch,  bug report or insult!


## Reference ##

http://www.toforge.com/2011/02/phonegap-android-plugin-for-download-files-from-url-on-sd-card/

## Licence ##

The MIT License

Copyright (c) 2011 Phillip Neumann

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.