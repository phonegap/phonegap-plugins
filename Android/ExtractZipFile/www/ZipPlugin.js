/*
 	Author: Vishal Rajpal
 	Filename: ZipPlugin.js
 	Date: 21-02-2012
*/

var ExtractZipFilePlugin=function(){
};

PhoneGap.addConstructor(function() 
{
	PhoneGap.addPlugin('ExtractZipFilePlugin', new ZipPlugin());
});

ExtractZipFilePlugin.prototype.extractFile = function(file, successCallback, errorCallback) 
{
	alert(file);
    return PhoneGap.exec(successCallback, errorCallback, "ZipPlugin", "extract", [file]);
};