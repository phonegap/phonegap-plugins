var Twitter = function(){};

Twitter.prototype.isTwitterAvailable = function(response){
    Cordova.exec(response, null, "org.apache.cordova.twitter", "isTwitterAvailable", []);
};

Twitter.prototype.isTwitterSetup = function(response){
    Cordova.exec(response, null, "org.apache.cordova.twitter", "isTwitterSetup", []);
};

Twitter.prototype.composeTweet = function(success, failure, tweetText, options){
    options = options || {};
    options.text = tweetText;
    Cordova.exec(success, failure, "org.apache.cordova.twitter", "composeTweet", [options]);
};

Twitter.prototype.getPublicTimeline = function(success, failure){
    Cordova.exec(success, failure, "org.apache.cordova.twitter", "getPublicTimeline", []);
};

Twitter.prototype.getMentions = function(success, failure){
    Cordova.exec(success, failure, "org.apache.cordova.twitter", "getMentions", []);
};

Cordova.addConstructor(function() {
    if(!window.plugins) window.plugins = {};
    window.plugins.twitter = new Twitter();
});
