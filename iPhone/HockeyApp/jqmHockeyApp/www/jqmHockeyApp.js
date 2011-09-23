// jqmHockeyApp.js

//  Created by Owen Brotherwood on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


var jqmHockeyApp = (function() {  
    args = {},
    args.appIdentifier = 'xxxx', //another place to put in your App ID or modify index.html, HockeyApp.js or HockeyApp.m       
    
    cbPreventBehavior = function(e) { 
        e.preventDefault(); 
    },
    
    cbOnDeviceReady = function(){
        HockeyApp.init(args);
    },
    
    cbIsUpdateAvailable = function(update){
        if (update){
            alert("update available");
        }else{
            alert("no update available");
        }
    },
    
    cbInitiateAppDownload = function(wentWell){
        if (wentWell){
            alert("App Downloaded");
        }else{
            alert("App Download problem");
        }
    },
    
    cbMobileInit = function(){
        $.mobile.page.prototype.options.addBackBtn = true;
    },
    
    init = function(appIdentifier){
        $(document).bind("onDeviceReady", cbOnDeviceReady);
        $(document).bind("touchmove", cbPreventBehavior, false);
        $(document).bind("mobileinit", cbMobileInit);
        if (appIdentifier) {
            args.appIdentifier = appIdentifier;
        }
        HockeyApp.init(args);
    };
    
    return{
        cbIsUpdateAvailable:    cbIsUpdateAvailable,
        cbInitiateAppDownload:  cbInitiateAppDownload,
        init :                  init
    };
    
})();
