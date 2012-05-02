var Twitter = function(){};

Twitter.prototype.isTwitterAvailable = function(response){
    cordova.exec(response, null, "TwitterPlugin", "isTwitterAvailable", []);
};

Twitter.prototype.isTwitterSetup = function(response){
    cordova.exec(response, null, "TwitterPlugin", "isTwitterSetup", []);
};

Twitter.prototype.composeTweet = function(success, failure, tweetText, options){
    options = options || {};
    options.text = tweetText;
    cordova.exec(success, failure, "TwitterPlugin", "composeTweet", [options]);
};

Twitter.prototype.getPublicTimeline = function(success, failure){
    cordova.exec(success, failure, "TwitterPlugin", "getPublicTimeline", []);
};

Twitter.prototype.getMentions = function(success, failure){
    cordova.exec(success, failure, "TwitterPlugin", "getMentions", []);
};

Twitter.prototype.getTwitterUsername = function(response){
    cordova.exec(response, null, "TwitterPlugin", "getTwitterUsername", []);
};

cordova.addConstructor(function() {
					   
					   /* shim to work in 1.5 and 1.6  */
						if (!window.Cordova) {
						window.Cordova = cordova;
						};
						
					   
					   if(!window.plugins) window.plugins = {};
					   window.plugins.twitter = new Twitter();
					   });
