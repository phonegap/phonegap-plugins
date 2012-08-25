PhonegapOCRPlugin
=================

ocr plugin for phonegap using tesseract

drag the tessdata folder to your phonegap project
mark the checkbox "copy items into destination group"
Choose the radio-button "Create folder references for any added folders"

drag the dependencies folder to your phonegap project
mark the checkbox "copy items into destination group"
Choose the radio-button "Created groups for any added folders" 

drag OCRPlugin.h, OCRPlugin.m, claseAuxiliar.h and claseAuxiliar.mm 

drag OCRPlugin.js to your www folder

Add the plugin to cordova.xml

com.jcesarmobile.OCRPlugin   OCRPlugin


Thanks to suzuki for compiling tesseract in this post
http://tinsuke.wordpress.com/2011/11/01/how-to-compile-and-use-tesseract-3-01-on-ios-sdk-5

I have included an index.html with an example.

It uses the camera function with destinationType.FILE_URI (IMPORTANT!!!)


            // A button will call this function
            //
            function capturePhoto() {
                // Take picture using device camera and retrieve image as base64-encoded string
                navigator.camera.getPicture(onPhotoURISuccess, onFail, { quality: 100,
                                            destinationType: destinationType.FILE_URI });
            }
            
            // Call the plugin when a photo is successfully retrieved
            //
            function onPhotoURISuccess(imageURI) {
                callNativePlugin({url_imagen: imageURI});
            }
            

            function callNativePlugin( returnSuccess ) { 
                OCRPlugin.callNativeFunction( nativePluginResultHandler, nativePluginErrorHandler, returnSuccess ); 
            } 
            
            function nativePluginResultHandler (result) { 
                alert("ok: "+result);
            } 
            
            function nativePluginErrorHandler (error) { 
                alert("error: "+error);
            }

