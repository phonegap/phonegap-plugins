(function() {
  
function applicationPreferences() {}

applicationPreferences.prototype.get = function(key,success,fail) 
{
    var args = {};
    args.key = key;
    cordova.exec(success,fail,"applicationPreferences","getSetting",[args]);
};

applicationPreferences.prototype.set = function(key,value,success,fail) 
{
    var args = {};
    args.key = key;
    args.value = value;
    cordova.exec(success,fail,"applicationPreferences","setSetting",[args]);
};


if(!window.plugins) {
    window.plugins = {};
}
if ( ! window.plugins.applicationPreferences ) {
    window.plugins.applicationPreferences = new applicationPreferences();
}

})();

