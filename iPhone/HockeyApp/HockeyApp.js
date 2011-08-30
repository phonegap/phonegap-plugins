// HockeyApp.js

var HockeyApp = {
	checkForUpdate: function() {
        PhoneGap.exec("HockeyApp.checkForUpdates");
	},
    
    crashTest: function() {
        PhoneGap.exec("HockeyApp.crashTest");
    }
};
