# Downlaoder plugin for Phonegap #

A plugin that downloads file from the web (http) to the device.

## Adding the plugin to your project ##

1. To install the plugin, move downloader.js to your project's www folder and include a reference to it in your html files. 
2. Create a folder called 'com/phonegap/plugins/downloader' within your project's src/ folder.
3. And copy the java file into that new folder.

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
