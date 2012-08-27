/*
 	Author: Vishal Rajpal
 	Filename: ZipPlugin.js
 	Created Date: 21-02-2012
 	Modified Date: 06-08-2012
*/

var ExtractZipFilePlugin=function(){
};

cordova.addConstructor(function() 
{
	cordova.addPlugin('ExtractZipFilePlugin', new ExtractZipFilePlugin());
});

ExtractZipFilePlugin.prototype.extractFile = function(file, successCallback, errorCallback) 
{
    return cordova.exec(successCallback, errorCallback, "ZipPlugin", "extract", [file]);
};