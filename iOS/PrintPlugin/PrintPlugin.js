/**
 * Printer Plugin
 * Copyright (c) 2011 Ian Tipton (github.com/itip)
 * MIT licensed
 */

var PrintPlugin = function() {

}

PrintPlugin.prototype.callbackMap = {};
PrintPlugin.prototype.callbackIdx = 0;

/*
 print      - html string or DOM node (if latter, innerHTML is used to get the contents). REQUIRED.
 success    - callback function called if print successful.     {success: true}
 fail       - callback function called if print unsuccessful.  If print fails, {error: reason}. If printing not available: {available: false}
 options    -  {dialogOffset:{left: 0, right: 0}}. Position of popup dialog (iPad only).
 */
PrintPlugin.prototype.print = function(printHTML, success, fail, options) {
    if (typeof printHTML != 'string'){
        console.log("Print function requires an HTML string. Not an object");
        return;
    }


    //var printHTML = "";

    var dialogLeftPos = 0;
    var dialogTopPos = 0;


    if (options){
        if (options.dialogOffset){
            if (options.dialogOffset.left){
                dialogLeftPos = options.dialogOffset.left;
                if (isNaN(dialogLeftPos)){
                    dialogLeftPos = 0;
                }
            }
            if (options.dialogOffset.top){
                dialogTopPos = options.dialogOffset.top;
                if (isNaN(dialogTopPos)){
                    dialogTopPos = 0;
                }
            }
        }
    }

    var key = 'print' + this.callbackIdx++;
    window.plugins.printPlugin.callbackMap[key] = {
        success: function(result) {
            delete window.plugins.printPlugin.callbackMap[key];
            success(result);
        },
        fail: function(result) {
            delete window.plugins.printPlugin.callbackMap[key];
            fail(result);
        },
    };

    var callbackPrefix = 'window.plugins.printPlugin.callbackMap.' + key;
    return Cordova.exec("PrintPlugin.print", printHTML, callbackPrefix + '.success', callbackPrefix + '.fail', dialogLeftPos, dialogTopPos);
};

/*
 * Callback function returns {available: true/false}
 */
PrintPlugin.prototype.isPrintingAvailable = function(callback) {
    var key = 'isPrintingAvailable' + this.callbackIdx++;
    window.plugins.printPlugin.callbackMap[key] = function(result) {
        delete window.plugins.printPlugin.callbackMap[key];
        callback(result);
    };

    var callbackName = 'window.plugins.printPlugin.callbackMap.' + key;
    Cordova.exec("PrintPlugin.isPrintingAvailable", callbackName);
};

Cordova.addConstructor(function() {
    if(!window.plugins){
        window.plugins = {};
    }
    window.plugins.printPlugin = new PrintPlugin();
});