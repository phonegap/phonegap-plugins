// HockeyApp.js

//  Created by Owen Brotherwood on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
 

var HockeyApp = (function() {  
	checkForUpdate = function() { 
            PhoneGap.exec("HockeyApp.checkForUpdate");
    },
    
    showUpdateView = function(){
            PhoneGap.exec("HockeyApp.showUpdateView");
    },
    
    isUpdateAvailable = function(cb) { // provide a function that can be called back with result: ''/1
        PhoneGap.exec("HockeyApp.isUpdateAvailable", GetFunctionName(cb)); 
    },
    
    initiateAppDownload = function(cb){ // provide a function that can be called back with result: ''/1
        PhoneGap.exec("HockeyApp.initiateAppDownload", GetFunctionName(cb));
    },
    
    crashTest = function() {
        PhoneGap.exec("HockeyApp.crashTest");
    },
                                                 
    init = function(args){ // args.appIdentifier 
        PhoneGap.exec("HockeyApp.init", args);
    };
    
    return{
        checkForUpdate :        checkForUpdate,         // causes a requester if new software is found
        showUpdateView:         showUpdateView,         // the HockeyKit Update View
        isUpdateAvailable :     isUpdateAvailable,      // checks if new software is available
        initiateAppDownload :   initiateAppDownload,    // causes an requester for download of new software
        crashTest :             crashTest,              // cause crash to test QuincyKit        
        init :                  init                    // called before use with the appIdentifier
    };

})();
