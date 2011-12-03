var Twitter = function(){};

Twitter.prototype.isTwitterAvailable = function(response){
    PhoneGap.exec(response, null, "com.phonegap.twitter", "isTwitterAvailable", []);
};

Twitter.prototype.isTwitterSetup = function(response){
    PhoneGap.exec(response, null, "com.phonegap.twitter", "isTwitterSetup", []);
};

Twitter.prototype.sendTweet = function(success, failure, tweetText, urlAttach, imageAttach){
    if(typeof urlAttach === "undefined") urlAttach = "";
    if(typeof imageAttach === "undefined") imageAttach = "";
    
    PhoneGap.exec(success, failure, "com.phonegap.twitter", "sendTweet", [tweetText, urlAttach, imageAttach]);
};

Twitter.prototype.composeTweet = function() {
    PhoneGap.exec(null, null, "com.phonegap.twitter", "composeTweet", []);
};

Twitter.prototype.getPublicTimeline = function(success, failure){
    PhoneGap.exec(success, failure, "com.phonegap.twitter", "getPublicTimeline", []);
};

Twitter.prototype.getMentions = function(success, failure){
    PhoneGap.exec(success, failure, "com.phonegap.twitter", "getMentions", []);
};

PhoneGap.addConstructor(function() {
    if(!window.plugins) window.plugins = {};
    window.plugins.twitter = new Twitter();
});
