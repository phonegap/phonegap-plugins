/**
 * Base of the Android version for Twitter 
 * @see https://github.com/phonegap/phonegap-plugins/tree/master/iPhone/Twitter
 */
var Twitter = 
{
	/**
     * Check if the serrvice is available
     */
	isTwitterAvailable: function( success, failure )
	{
	    PhoneGap.exec( success, failure, "Twitter", "isTwitterAvailable", []);
	},
		
	/**
	 * Try to open Twitter for sending the message
	 */
	composeTweet: function( success, failure, tweetText, options) 
	{
		PhoneGap.exec(success, failure, "Twitter", "composeTweet", [tweetText]);
	}
};
