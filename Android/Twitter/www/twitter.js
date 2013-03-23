/*
	Twitter Plugin
*/

cordova.define("cordova/plugin/twitter",
  function(require, exports, module) {
    var exec = require("cordova/exec");
    var Twitter = function () {};

    Twitter.prototype.isTwitterAvailable = function( success, failure ) {
        if (typeof failure != "function")  {
            console.log("Twitter.scan failure: failure parameter not a function");
            return
        }

        if (typeof success != "function") {
            console.log("Twitter.scan failure: success callback parameter must be a function");
            return
        }
        cordova.exec(success, failure, "Twitter", "isTwitterAvailable", []);
    };

    Twitter.prototype.composeTweet = function( success, failure, tweetText, options) {
        if (typeof failure != "function")  {
            console.log("Twitter.scan failure: failure parameter not a function");
            return
        }

        if (typeof success != "function") {
            console.log("Twitter.scan failure: success callback parameter must be a function");
            return
        }
        cordova.exec(success, failure, "Twitter", "composeTweet", [tweetText]);
    };

    var twitter = new Twitter();
    module.exports = twitter;
});

if (!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.twitter) {
    window.plugins.twitter = cordova.require("cordova/plugin/twitter");
}
