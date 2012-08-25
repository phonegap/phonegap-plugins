var AppPreferences = function () {};

var AppPreferencesError = function(code, message) {
    this.code = code || null;
    this.message = message || '';
};

AppPreferencesError.NO_PROPERTY = 0;
AppPreferencesError.NO_PREFERENCE_ACTIVITY = 1;

AppPreferences.prototype.get = function(key,success,fail) {
    cordova.exec(success,fail,"applicationPreferences","get",[key]);
};

AppPreferences.prototype.set = function(key,value,success,fail) {
    cordova.exec(success,fail,"applicationPreferences","set",[key, value]);
};

AppPreferences.prototype.load = function(success,fail) {
    cordova.exec(success,fail,"applicationPreferences","load",[]);    
};

AppPreferences.prototype.show = function(activity,success,fail) {
    cordova.exec(success,fail,"applicationPreferences","show",[activity]);    
};

cordova.addConstructor(function() {
    cordova.addPlugin("applicationPreferences", new AppPreferences());
});