
(function(){
    // get local ref to global PhoneGap/Cordova/cordova object for exec function
    var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks


    function applicationPreferences() {
    }

    applicationPreferences.prototype.get = function(key,success,fail) 
    {
        var args = {};
        args.key = key;
        cordovaRef.exec(success,fail,"applicationPreferences","getSetting",[args]);
    };

    applicationPreferences.prototype.set = function(key,value,success,fail) 
    {
        var args = {};
        args.key = key;
        args.value = value;
        cordovaRef.exec(success,fail,"applicationPreferences","setSetting",[args]);
    };

    /**
     * Add to Cordova constructor
     */
    if (cordovaRef && cordovaRef.addConstructor) {
        cordovaRef.addConstructor(function() 
        {
            if(!window.plugins)
            {
                window.plugins = {};
            }
            window.plugins.applicationPreferences = new applicationPreferences();
        });
    } else {
        console.log("Application Preferences Plugin could not be installed.");
        return null;
    }
})();
