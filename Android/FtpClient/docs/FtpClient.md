FtpClient
==========

FtpClient is an object that allows you to upload/download files from a FTP server.

Properties
----------

N/A

Methods
-------

- __get__: downloads a file from a server. 
- __put__: sends a file to a server. 

Details
-------

The `FtpClient` object is a way to upload/download files to a server using the FTP protocol.

The first parameter is the name of the file to upload or download.
The second parameter is the URL of the FTP server.
The third parameter is the success callback
The fourth parameter is the error callback [optional]

Supported Platforms
-------------------

- Android

Quick Example
------------------------------
	
  	var win = function() {
  		alert("yay");
	}
	
    var fail = function() {
        alert("boo");
    }
	
    var paths = navigator.fileMgr.getRootPaths();
    var ftpClient = new FtpClient();
    ftpClient.put(paths[0]+"/putfile.txt", "ftp://username:password@server.com:21/putfile.txt;type=i", win, fail);
    ftpClient.get(paths[0]+"/getfile.txt", "ftp://username:password@server.com:21/putfile.txt", win, fail);
    
Full Example
------------

    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
                          "http://www.w3.org/TR/html4/strict.dtd">
    <html>
      <head>
        <title>Contact Example</title>

        <script type="text/javascript" charset="utf-8" src="phonegap.js"></script>
        <script type="text/javascript" charset="utf-8">

        // Wait for PhoneGap to load
        //
        function onLoad() {
            document.addEventListener("deviceready", onDeviceReady, false);
        }

        // PhoneGap is ready
        //
    	function putFile() {
	        var ftpClient = new FtpClient();
		    ftpClient.put(paths[0]+"/putfile.txt", "ftp://username:password@server.com:21/putfile.txt;type=i", win, fail);
    	}
    
    	function getFile() {
	        var ftpClient = new FtpClient();
		    ftpClient.get(paths[0]+"/getfile.txt", "ftp://username:password@server.com:21/putfile.txt", win, fail);
    	}
		
	  	function win(r) {
        	alert("Yay!");
		}
	
    	function fail(args) {
        	alert("BOO!");
    	}
    	
        </script>
      </head>
      <body onload="onLoad()">
        <h1>Example</h1>
	    <a href="#" onclick="putFile();">Put Files</a>
    	<a href="#" onclick="getFile();">Get Files</a>
      </body>
    </html>
