var PGExternalScreen = {
    
    setupScreenConnectionNotificationHandlers: function (success, fail) {
        return cordova.exec(success, fail, "PGExternalScreen", "setupScreenConnectionNotificationHandlers", []);
    },
    
    loadHTMLResource: function (url, success, fail) {
        return cordova.exec(success, fail, "PGExternalScreen", "loadHTMLResource", [url]);
    },
    
    loadHTML: function (url, success, fail) {
        return cordova.exec(success, fail, "PGExternalScreen", "loadHTML", [url]);
    },
    
    invokeJavaScript: function (scriptString, success, fail) {
        return cordova.exec(success, fail, "PGExternalScreen", "invokeJavaScript", [scriptString]);
    },
    
    checkExternalScreenAvailable: function (success, fail) {
        return cordova.exec(success, fail, "PGExternalScreen", "checkExternalScreenAvailable", []);
    }


};