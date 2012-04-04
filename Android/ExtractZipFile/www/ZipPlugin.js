/*
 	Author: Vishal Rajpal
 	Filename: ZipPlugin.js
 	Created Date: 21-02-2012
 	Modified Date: 04-04-2012
*/

var ExtractZipFilePlugin=function(){
};

PhoneGap.addConstructor(function() 
{
	PhoneGap.addPlugin('ExtractZipFilePlugin', new ExtractZipFilePlugin());
});

ExtractZipFilePlugin.prototype.extractFile = function(file, successCallback, errorCallback) 
{
    return PhoneGap.exec(successCallback, errorCallback, "ZipPlugin", "extract", [file]);
};