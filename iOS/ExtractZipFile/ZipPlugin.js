/**
 * ZipPlugin.js
 *  
 * Phonegap Extract Zip File plugin
 * Copyright (c) Pobl Creative Cyf. 2012
 *
 */
var ExtractZipFilePlugin = function(){
}

cordova.addConstructor(function(){
    if(!window.plugins) window.plugins = {};
    window.plugins.extractZipFile = new ExtractZipFilePlugin();
});

ExtractZipFilePlugin.prototype.extractFile = function(file, destination, successCallback, errorCallback) 
{
    return cordova.exec(successCallback, errorCallback, "ExtractZipFilePlugin", "extract", [file, destination]);
};