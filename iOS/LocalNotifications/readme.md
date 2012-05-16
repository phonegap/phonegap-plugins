PHONEGAP LOCALNOTIFICATION 
The Phonegap LocalNotification plugin is great, but the documentation is lacking - also explanation of how to do more than set a 60 second timer.

This example goes through in detail how to set a timer for the future based on hours and minutes, as well as days in the future - also setting up repeat events for daily, weekly, monthly, yearly.

It also explains how to create a callback to your app when it is launched from that notification.

the full write up is here:<br>
http://www.drewdahlman.com/meusLabs/?p=117


<b>NOTES</b>:<br>
A breakdown of options - <br>
- date ( this expects a date object )<br>
- message ( the message that is displayed )<br>
- repeat ( has the options of 'weekly','daily','monthly','yearly')<br>
- badge ( displays number badge to notification )<br>
- foreground ( a javascript function to be called if the app is running )<br>
- background ( a javascript function to be called if the app is in the background )<br>
- sound ( a sound to be played, the sound must be located in your project's resources and must be a caf file )<br>

<b>ADJUSTING AppDelegate</b><br>
After you've added LocalNotifications to your plugins you need to make a minor addition to AppDelegate.m

<b>Cordova 1.7+</b>
<pre>
	// ADD OUR NOTIFICATION CODE
	- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification 
	{

	    UIApplicationState state = [application applicationState];
	    if (state == UIApplicationStateActive) {
			// WAS RUNNING
		    NSLog(@"I was currently active");

		    NSString *notCB = [notification.userInfo objectForKey:@"foreground"];
		    NSString *notID = [notification.userInfo objectForKey:@"notificationId"];

		    NSString * jsCallBack = [NSString 
		                             stringWithFormat:@"%@(%@)", notCB,notID];  


		    [self.viewController.webView  stringByEvaluatingJavaScriptFromString:jsCallBack];

		    application.applicationIconBadgeNumber = 0;
	    }
	    else {
	        // WAS IN BG
	        NSLog(@"I was in the background");

	        NSString *notCB = [notification.userInfo objectForKey:@"background"];
	        NSString *notID = [notification.userInfo objectForKey:@"notificationId"];

		    NSString * jsCallBack = [NSString 
		                             stringWithFormat:@"%@(%@)", notCB,notID]; 
	        [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsCallBack];         

	        application.applicationIconBadgeNumber = 0;
	    }                 
	}
</pre>
<b>Phonegap</b>
<pre>
	// ADD OUR NOTIFICATION CODE
	- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification 
	{

	    UIApplicationState state = [application applicationState];
	    if (state == UIApplicationStateActive) {
			// WAS RUNNING
		    NSLog(@"I was currently active");

		    NSString *notCB = [notification.userInfo objectForKey:@"foreground"];
		    NSString *notID = [notification.userInfo objectForKey:@"notificationId"];

		    NSString * jsCallBack = [NSString 
		                             stringWithFormat:@"%@(%@)", notCB,notID];  


		    [self.webView  stringByEvaluatingJavaScriptFromString:jsCallBack];

		    application.applicationIconBadgeNumber = 0;
	    }
	    else {
	        // WAS IN BG
	        NSLog(@"I was in the background");

	        NSString *notCB = [notification.userInfo objectForKey:@"background"];
	        NSString *notID = [notification.userInfo objectForKey:@"notificationId"];

		    NSString * jsCallBack = [NSString 
		                             stringWithFormat:@"%@(%@)", notCB,notID]; 

	        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];         

	        application.applicationIconBadgeNumber = 0;
	    }                 
	}
</pre>
Add this code to the end of your AppDelegate.m file in order for the callback functions to work properly!

<b>EXAMPLE</b><br>
<pre>
var d = new Date();
	d = d.getTime() + 60*1000; //60 seconds from now
	d = new Date(d);

window.plugins.localNotification.add({
	date: d, // your set date object
	message: 'Hello world!',
	repeat: 'weekly', // will fire every week on this day
	badge: 1,
	foreground:'foreground',
	background:'background',
	sound:'sub.caf'
});

function foreground(id){
	console.log("I WAS RUNNING ID="+id);
}
function background(id){
	console.log("I WAS IN THE BACKGROUND ID="+id)
}

</pre>
<br>

<b>UPDATES:</b>
<i>5.16.2012</i>
- Added Notification ID's to callback.
- Fixed spelling error for 'foreground'
- Notice that you no longer have to call your background or foreground functions with the (). This is now added by the plugin on the objective-c side of things.

