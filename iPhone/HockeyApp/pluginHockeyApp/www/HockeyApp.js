// HockeyApp.js

/*
 
 The next step, remove the code from the AppDelegate.m that init's the Kits so these are done via js so that no alterations are needed in base PhoneGap code.
 
 [[BWHockeyManager sharedHockeyManager] setAppIdentifier:@"xxx"];
 [[BWQuincyManager sharedQuincyManager] setAppIdentifier:@"xxx"];
 
 There are other structures in the Hockey Kit that could be prep'ed as well, so need some strange little js structure with reasonable defaults
 
 */

var HockeyApp = {
	checkForUpdate: function() {
        PhoneGap.exec("HockeyApp.checkForUpdates");
	},
    
    crashTest: function() {
        PhoneGap.exec("HockeyApp.crashTest");
    }
};
