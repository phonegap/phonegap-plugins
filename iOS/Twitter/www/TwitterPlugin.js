var Twitter = function(){};

Twitter.prototype.isTwitterAvailable = function(response){
    Cordova.exec(response, null, "com.phonegap.twitter", "isTwitterAvailable", []);
};

Twitter.prototype.isTwitterSetup = function(response){
    Cordova.exec(response, null, "com.phonegap.twitter", "isTwitterSetup", []);
};

Twitter.prototype.composeTweet = function(success, failure, tweetText, options){
    options = options || {};
    options.text = tweetText;
    Cordova.exec(success, failure, "com.phonegap.twitter", "composeTweet", [options]);
};

Twitter.prototype.getPublicTimeline = function(success, failure){
    Cordova.exec(success, failure, "com.phonegap.twitter", "getPublicTimeline", []);
};

Twitter.prototype.getMentions = function(success, failure){
    Cordova.exec(success, failure, "com.phonegap.twitter", "getMentions", []);
};

Cordova.addConstructor(function() {
    if(!window.plugins) window.plugins = {};
    window.plugins.twitter = new Twitter();
});
