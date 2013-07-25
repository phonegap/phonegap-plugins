(function() {
  
function applicationPreferences() {}

applicationPreferences.prototype.get = function(key,success,fail) 
{
    cordova.exec(success,fail,"applicationPreferences","getSetting",[key]);
};

applicationPreferences.prototype.set = function(key,value,success,fail) 
{
    cordova.exec(success,fail,"applicationPreferences","setSetting",[key,value]);
};


if(!window.plugins) {
    window.plugins = {};
}
if ( ! window.plugins.applicationPreferences ) {
    window.plugins.applicationPreferences = new applicationPreferences();
}

})();

