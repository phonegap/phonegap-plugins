// HockeyApp.js

//  Created by Owen Brotherwood on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
 
/*
 Experimental:
 change BWHockeyManager.m defaults and use isUpdateAvailable and initiateAppDownload for another type of user experience
 
 self.alwaysShowUpdateReminder = NO;
 self.checkForUpdateOnLaunch = NO;
 self.updateSetting = HockeyUpdateCheckManually;
*/


var HockeyApp = (function() {  
	checkForUpdate = function() { // only works with default HockeyKit defaults and not the experimental above
        PhoneGap.exec("HockeyApp.checkForUpdate");
    },
    
    isUpdateAvailable = function(cb) { // provide a function that can be called back with result: ''/1
        PhoneGap.exec("HockeyApp.isUpdateAvailable", GetFunctionName(cb)); 
    },
    
    initiateAppDownload = function(){   // has a return boolean which could be used
        PhoneGap.exec("HockeyApp.initiateAppDownload");
    },
    
    crashTest = function() {
        PhoneGap.exec("HockeyApp.crashTest");
    },
                                
    init = function(args){
        PhoneGap.exec("HockeyApp.init", args);
    };
    
    return{
        checkForUpdate :        checkForUpdate,         // causes a requester if new software is found
        crashTest :             crashTest,              // cause crash to test QuincyKit
        isUpdateAvailable :     isUpdateAvailable,      // checks if new software is available
        initiateAppDownload :   initiateAppDownload,    // causes an requester for download of new software
        init :                  init                    // called before use
    };

})();
