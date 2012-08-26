/**
 * @constructor
 */
var Twitter = function(){};
/**
 * Checks if the Twitter SDK is loaded
 * @param {Function} response callback on result
 * @param {Number} response.response is 1 for success, 0 for failure
 * @example
 *      window.plugins.twitter.isTwitterAvailable(function (response) {
 *          console.log("twitter available? " + response);
 *      });
 */
Twitter.prototype.isTwitterAvailable = function(response){
    cordova.exec(response, null, "TwitterPlugin", "isTwitterAvailable", []);
};
/**
 * Checks if the Twitter SDK can send a tweet
 * @param {Function} response callback on result
 * @param {Number} response.response is 1 for success, 0 for failure
 * @example
 *      window.plugins.twitter.isTwitterSetup(function (r) {
 *          console.log("twitter configured? " + r);
 *      });
 */
Twitter.prototype.isTwitterSetup = function(response){
    cordova.exec(response, null, "TwitterPlugin", "isTwitterSetup", []);
};
/**
 * Sends a Tweet to Twitter
 * @param {Function} success callback
 * @param {Function} failure callback
 * @param {String} failure.error reason for failure
 * @param {String} tweetText message to send to twitter
 * @param {Object} options (optional)
 * @param {String} options.urlAttach URL to embed in Tweet
 * @param {String} options.imageAttach Image URL to embed in Tweet
 * @param {Number} response.response - 1 on success, 0 on failure
 * @example
 *     window.plugins.twitter.composeTweet(
 *         function () { console.log("tweet success"); }, 
 *         function (error) { console.log("tweet failure: " + error); }, 
 *         "Text, Image, URL", 
 *         {
 *             urlAttach:"http://m.youtube.com/#/watch?v=obx2VOtx0qU", 
 *             imageAttach:"http://i.ytimg.com/vi/obx2VOtx0qU/hqdefault.jpg?w=320&h=192&sigh=QD3HYoJj9dtiytpCSXhkaq1oG8M"
 *         }
 * );
 */
Twitter.prototype.composeTweet = function(success, failure, tweetText, options){
    options = options || {};
    options.text = tweetText;
    cordova.exec(success, failure, "TwitterPlugin", "composeTweet", [options]);
};
/**
 * Gets Tweets from Twitter Timeline
 * @param {Function} success callback
 * @param {Object[]} success.response Tweet objects, see [Twitter Timeline Doc]
 * @param {Function} failure callback
 * @param {String} failure.error reason for failure
 * @example
 *     window.plugins.twitter.getPublicTimeline(
 *         function (response) { console.log("timeline success: " + JSON.stringify(response)); }, 
 *         function (error) { console.log("timeline failure: " + error); }
 *     );
 * 
 * [Twitter Timeline Doc]: https://dev.twitter.com/docs/api/1/get/statuses/public_timeline
 */
Twitter.prototype.getPublicTimeline = function(success, failure){
    cordova.exec(success, failure, "TwitterPlugin", "getPublicTimeline", []);
};
/**
 * Gets Tweets from Twitter Mentions
 * @param {Function} success callback
 * @param {Object[]} success.result Tweet objects, see [Twitter Mentions Doc]
 * @param {Function} failure callback
 * @param {String} failure.error reason for failure
 * @example
 *     window.plugins.twitter.getMentions(
 *         function (response) { console.log("mentions success: " + JSON.stringify(response)); },
 *         function (error) { console.log("mentions failure: " + error); }
 *     );
 * 
 * [Twitter Timeline Doc]: https://dev.twitter.com/docs/api/1/get/statuses/public_timeline
 */
Twitter.prototype.getMentions = function(success, failure){
    cordova.exec(success, failure, "TwitterPlugin", "getMentions", []);
};
/**
 * Gets Tweets from Twitter Mentions API
 * @param {Function} success callback
 * @param {String} success.response Twitter Username
 * @param {Object[]} success.result Tweet objects, see [Twitter Mentions Doc]
 * @param {Function} failure callback
 * @param {String} failure.error reason for failure
 * 
 * [Twitter Mentions Doc]: https://dev.twitter.com/docs/api/1/get/statuses/mentions
 */
Twitter.prototype.getTwitterUsername = function(success, failure) {
    cordova.exec(success, failure, "TwitterPlugin", "getTwitterUsername", []);
};
/**
 * Gets Tweets from Twitter Mentions API
 * @param {String} url of [Twitter API Endpoint]
 * @param {Object} params key-value map, matching [Twitter API Endpoint]
 * @param {Function} success callback
 * @param {Object[]} success.response objects returned from Twitter API (Tweets, Users,...)
 * @param {Function} failure callback
 * @param {String} failure.error reason for failure
 * @param {Object} options (optional) other options for the HTTP request
 * @param {String} options.requestMethod HTTP Request type, ex: "POST"
 * @example
 *     window.plugins.twitter.getTWRequest(
 *          'users/lookup.json',
 *          {user_id: '16141659,783214,6253282'},
 *          function (response) { console.log("usersLookup success: " + JSON.stringify(response)); }, 
 *          function (error) { console.log("usersLookup failure: " + error); },
 *          {requestMethod: 'POST'}
 *     );
 * 
 * [Twitter API Endpoints]: https://dev.twitter.com/docs/api
 */
Twitter.prototype.getTWRequest = function(url, params, success, failure, options){
    options = options || {};
    options.url = url;
    options.params = params;
    cordova.exec(success, failure, "TwitterPlugin", "getTWRequest", [options]);
};
// Plug in to Cordova
cordova.addConstructor(function() {
					   
					   /* shim to work in 1.5 and 1.6  */
						if (!window.Cordova) {
						window.Cordova = cordova;
						};
						
					   
					   if(!window.plugins) window.plugins = {};
					   window.plugins.twitter = new Twitter();
					   });
