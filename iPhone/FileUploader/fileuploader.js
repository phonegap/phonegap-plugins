/**
 * Phonegap File Upload plugin
 * iPhone version
 * Copyright (c) Matt Kane 2011
 *
 */
var FileUploader = function() { 

}


/**
 * Given a file:// url, uploads the file to the server as a multipart/mime request
 *
 * @param server URL of the server that will receive the file
 * @param file file:// uri of the file to upload
 * @param params Object with key: value params to send to the server
 * @param fileKey Parameter name of the file
 * @param fileName Filename to send to the server. Defaults to image.jpg
 * @param mimeType Mimetype of the uploaded file. Defaults to image/jpeg
 * @param success Success callback. Passed the response data from the server as a string.
 * @param fail Error callback. Passed the error message.
 * @param progress Called on upload progress. Signature should be function(bytesUploaded, totalBytes)
 */
FileUploader.prototype.uploadByUri = function(server, file, params, fileKey, fileName, mimeType, success, fail, progress) {
	this._doUpload('uploadByUri', server, file, params, fileKey, fileName, mimeType, success, fail, progress);
};

/**
 * Given absolute path, uploads the file to the server as a multipart/mime request
 *
 * @param server URL of the server that will receive the file
 * @param file Absolute path of the file to upload
 * @param params Object with key: value params to send to the server
 * @param fileKey Parameter name of the file
 * @param fileName Filename to send to the server. Defaults to image.jpg
 * @param mimeType Mimetype of the uploaded file. Defaults to image/jpeg
 * @param success Success callback. Passed the response data from the server as a string.
 * @param fail Error callback. Passed the error message.
 * @param progress Called on upload progress. Signature should be function(bytesUploaded, totalBytes)
 */
FileUploader.prototype.upload = function(server, file, params, fileKey, fileName, mimeType, success, fail, progress) {
	this._doUpload('upload', server, file, params, fileKey, fileName, mimeType, success, fail, progress);
};

FileUploader.prototype._doUpload = function(method, server, file, params, fileKey, fileName, mimeType, success, fail, progress) {
	if (!params) {
		params = {}	
	}
	
	var key = 'f' + this.callbackIdx++;
	window.plugins.fileUploader.callbackMap[key] = {
		success: function(result) {
					success(result);
					delete window.plugins.fileUploader.callbackMap[key]
		},
		fail: function(result) {
					fail(result);
					delete window.plugins.fileUploader.callbackMap[key]
		},
		progress: progress
	}
	var callback = 'window.plugins.fileUploader.callbackMap.' + key;
	
    return Cordova.exec('FileUploader.' + method, callback + '.success', callback + '.fail', callback + '.progress', server, file, fileKey, fileName, mimeType, params);
}

FileUploader.prototype.callbackMap = {};
FileUploader.prototype.callbackIdx = 0;

Cordova.addConstructor(function()  {
	if(!window.plugins) {
		window.plugins = {};
	}
	window.plugins.fileUploader = new FileUploader();
});
