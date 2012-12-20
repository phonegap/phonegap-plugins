//PDFViewer based on ChildBrowser

/* MIT licensed */
// (c) 2010 Jesse MacFadyen, Nitobi


(function() {
 
 var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks
 
 function PDFViewer() {
 // Does nothing
 }
 
 
 // Callback when the user chooses the 'Done' button
 // called from native
 PDFViewer._onClose = function()
 {
 window.plugins.PDFViewer.onClose();
 };
 
 
 
/* The interface that you will use to access functionality */
 
 // Show a webpage, will result in a callback to onLocationChange
 PDFViewer.prototype.showPDF = function(loc)
 {
 cordovaRef.exec("PDFViewerCommand.showPDF", loc);
 };
 
 // close the browser, will NOT result in close callback
 PDFViewer.prototype.close = function()
 {
 cordovaRef.exec("PDFViewerCommand.close");
 };
 
 // Not Implemented
 PDFViewer.prototype.jsExec = function(jsString)
 {
 // Not Implemented!!
 //PhoneGap.exec("PDFViewerCommand.jsExec",jsString);
 };
 
 // Note: this plugin does NOT install itself, call this method some time after deviceready to install it
 // it will be returned, and also available globally from window.plugins.PDFViewer
 PDFViewer.install = function()
 {
 if(!window.plugins) {
 window.plugins = {};
 }
 if ( ! window.plugins.PDFViewer ) {
 window.plugins.PDFViewer = new PDFViewer();
 }
 
 };
 
 
 if (cordovaRef && cordovaRef.addConstructor) {
 cordovaRef.addConstructor(PDFViewer.install);
 } else {
 console.log("PDFViewer Cordova Plugin could not be installed.");
 return null;
 }
 
 
 })();