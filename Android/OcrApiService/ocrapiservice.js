/*
 * Copyright (C) 2012 by Guillaume Charhon
 */
var ocrapiservice = { 

	// parameters 
	// - imageURI : URI of the image to convert
	// - language : 2 letter language code (ex : "en" for english)
	// - apikey : Your api key displayed in your http://ocrapiservice.com dashboard
	
    convert: function (success, fail, imageURI,language, apikey ) { 
      return cordova.exec( success, fail, 
                           "OcrApiServicePlugin", 
                           "convert", [imageURI, language, apikey]); 
    } 
};