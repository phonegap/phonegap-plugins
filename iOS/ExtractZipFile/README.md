# ExtractZipFile Phonegap Plugin for iOS #
by Shaun Rowe (@shakie), Pobl Creative Cyf. (@poblcreative)

This plugin allows you to extract a zip file

## Adding the Plugin to your project ##

To install the plugin, copy ZipPlugin.js to your project's www folder and include a reference to it in your html files.

<script type="text/javascript" src="ZipPlugin.js"></script>

Add SSZipArchive directory (but delete the Tests directory), ExtractZipFilePlugin.h and ExtractZipFilePlugin.m to the Plugins directory of your phonegap project.

In the Cordova.plist section, you need to add the plugin with the key/pair value of:

ExtractZipFilePlugin ExtractZipFilePlugin

## Using the plugin ##

    <script type="text/javascript">
        function extractFile(fileName, destination)
        {
            window.plugins.extractZipFile.extractFile(fileName,destination,win,fail);
        }

        function win(status) 
        {
            alert('Success'+status);
        }
  
        function fail(error) 
        { 
            alert(error);
        }
    </script>

    <input type="button" value="Extract Zip File" onClick="extractFile('/path/to/ZipFile.zip', '/path/to/extract/to');"/>
