OcrApiService.com plugin for Cordova
---------------
This plug-in exposes OcrApiService.com optical character recognition api. 
Tested with Cordova 2.0

## Integration instruction ##

* Sign up for an account at http://ocrapiservice.com to get an api key
* Copy in your "src" folder :
    * the "com" folder
    * the "org" folder
* Add "ocrapiservice.js" to your www folder 
    * include it in your index.html file `<script type="text/javascript" charset="utf-8" src="ocrapiservice.js"></script> 
`
* Open your config.xml and add `<plugin name="OcrApiServicePlugin" value="com.ocrapiservice.OcrApiServicePlugin"/>`

## Usage functions ##

### ocrapiservice.convert ###
Returns a text from an image 

**ocrapiservice.convert ( success, error, imageURI, languageCode, apiKey );**

**Parameters**

* success : The callback that is called with the extracted text.
* error : The callback that is called if there was an error.
* imageURI : A URI containing the image. 
* languageCode : Two letters language code
* apiKey : Private api key provided in your ocrapiservice.com dashboard

### Quick example ####
<pre>   
function successCallback(result) {    
   // display the extracted text   
   alert(result);    
}    
function errorCallback(error) {
   alert(error); 
} 

function onSuccess(imageURI) {
	ocrapiservice.convert( successCallback, errorCallback, "content://media/external/images/media/5", "en", "DdfJmSnWjK" ); 
    
}
</pre>
 

### Full example ###
<pre>  

function testExample() { 
	navigator.camera.getPicture(onSuccess, onFail, { quality: 50, 
	sourceType : Camera.PictureSourceType.PHOTOLIBRARY, 
        destinationType: Camera.DestinationType.FILE_URI }); 
} 

function successCallback (result) { 
   alert(result); 
} 
function errorCallback (error) { 
   alert(error); 
} 

function onSuccess(imageURI) {
	alert(imageURI);
	ocrapiservice.convert( successCallback, errorCallback, imageURI, "en", "DdfJmSnWjK" ); 
}

function onFail(message) {
    alert('Failed because: ' + message);
}

testExample();

</pre>

### MIT License ###

Copyright (c) 2012 Smart Mobile Software

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
