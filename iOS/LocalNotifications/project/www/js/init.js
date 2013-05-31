// JavaScript Document
// PROJECT: Phonegap LocalNotifications
// AUTHOR: Drew Dahlman ( www.drewdahlman.com )
// DATE: 1.26.2012

// UPDATED BY: Dave Alden (www.workingedge.co.uk)
// DATE: 5.30.2013

/*
NOTES:
We will be creating LocalNotifications that can be set to fire while app is inactive, 
and create a callback for the JS to know when the app has come back from a notification.

One thing that is deceptive about the LocalNotifications plugin is that when it shows a notification
has been created it shows it based on the timezone +0000 which can throw you off.

in the call for setting the notification we simply call notification.local_timed("13:00") - note that I supplied a string.

The ability to set repeating notifications has been added! 
- daily
- weekly
- monthly
- yearly
*/

/*
2013 UPDATE NOTES:
- Updated from phonegap-1.2.0 to cordova-2.5.0
- Updated to use new plugin signature (Cordova 2.1.0+)
- Added support for silent alerts with sound='none'
- Added more examples
*/



// NOTIFICATION CENTER
/*
I like to set up one object that's only job is to manage notifications
*/
var notification = {
	init:function(){
		
	},
	// This will fire immediately
	local_now:function(){
		var d = new Date();
		d = d.getTime(); //now
		d = new Date(d);
		
		cordova.require('cordova/plugin/localnotification').add(
			function(){
				console.log("Successfully added local notification");
			},
			function(){
				console.log("Error adding local notification");
			},{
			date: d,
			repeat:'',
			message: '',
			hasAction: false,
			badge: 0,
			id: '1',
			background:'app.background',
			foreground:'app.running'
		});
	},
	
	// This will fire with a custom sound after 10 seconds
	local_custom:function(){
		var d = new Date();
		d = d.getTime() + 10*1000; //10 seconds from now
		d = new Date(d);
		
		cordova.require('cordova/plugin/localnotification').add(
			function(){
				console.log("Sucessfully added local notification");
			},
			function(){
				console.log("Error adding local notification");
			},{
			date: d,
			repeat:'',
			message: 'This notification has a custom sound',
			hasAction: false,
			badge: 0,
			id: '1',
			background:'app.background',
			foreground:'app.running',
      sound: 'horn.caf' // '' = default sound, 'none' = silent, 'mysound.caf' == custom sound
		});
	},
	
	// This will fire with a default sound after 10 seconds
	local_default:function(){
		var d = new Date();
		d = d.getTime() + 10*1000; //10 seconds from now
		d = new Date(d);
		
		cordova.require('cordova/plugin/localnotification').add(
			function(){
				console.log("Sucessfully added local notification");
			},
			function(){
				console.log("Error adding local notification");
			},{
			date: d,
			repeat:'',
			message: 'This notification has the default sound',
			hasAction: false,
			badge: 0,
			id: '1',
			background:'app.background',
			foreground:'app.running',
      sound: '' // '' = default sound, 'none' = silent, 'mysound.caf' == custom sound
		});
	},
	
	// This will fire a silent notification after 10 seconds
	local_silent:function(){
		var d = new Date();
		d = d.getTime() + 10*1000; //10 seconds from now
		d = new Date(d);
		
		cordova.require('cordova/plugin/localnotification').add(
			function(){
				console.log("Sucessfully added local notification");
			},
			function(){
				console.log("Error adding local notification");
			},{
			date: d,
			repeat:'',
			message: 'This notification has no sound',
			hasAction: false,
			badge: 0,
			id: '1',
			background:'app.background',
			foreground:'app.running',
      sound: 'none' // '' = default sound, 'none' = silent, 'mysound.caf' == custom sound
		});
	},
	
	// This will fire a audio/vibrate only notification (no banner) after 10 seconds
	local_beep:function(){
		var d = new Date();
		d = d.getTime() + 10*1000; //10 seconds from now
		d = new Date(d);
		
		cordova.require('cordova/plugin/localnotification').add(
			function(){
				console.log("Sucessfully added local notification");
			},
			function(){
				console.log("Error adding local notification");
			},{
			date: d,
			repeat:'',
			message: '',
			hasAction: true,
			badge: 0,
			id: '1',
			background:'app.background',
			foreground:'app.running',
      sound: '' // '' = default sound, 'none' = silent, 'mysound.caf' == custom sound
		});
	},	
	
	// This will fire based on the time provided.
	// Something to note is that the iPhone goes off of 24hr time
	// it defaults to no timezone adjustment so +0000 !IMPORTANT
	local_timed:function(){
		// If the time set as 13:00
		// This means the alarm will go off at 1pm +0000
		// how does this translate to your time? While the phone schedules 1pm +0000
		// it will still go off at your desired time base on your phones time.
		
		var hh = $('#hh').val();
		var mm = $('#mm').val();
		
		
		console.log(hh+" "+mm);
		// Now lets make a new date
		var d = new Date();
			d = d.setSeconds(00);
			d = new Date(d);
			d = d.setMinutes(mm);
			d = new Date(d);
			d = d.setHours(hh);
			d = new Date(d);
			
		cordova.require('cordova/plugin/localnotification').add(
			function(){
				console.log("Sucessfully added local notification");
			},
			function(){
				console.log("Error adding local notification");
			},{
			date: d,
			repeat:'daily',
			message: 'This went off just as expected!',
			hasAction: true,
			badge: 1,
			id: '2',
			background:'app.background',
			foreground:'app.running'
		});
	},
	clear:function(){
		cordova.require('cordova/plugin/localnotification').cancelAll(
			function(){
				console.log("Sucessfully cancelled all local notifications");
			},function(){
				console.log("Error cancelling all local notifications");
			}
		);
	}
	
}

// APP
var app = {
	bodyLoad:function(){
		document.addEventListener("deviceready", app.deviceReady, false);
	},
	deviceReady:function(){
		app.init();
	},
	init:function(){
		
	},
	background:function(id){
		console.log("I was in the background but i'm back now! ID="+id);
	},
	running:function(id){
		console.log("I am currently running, so I'll use a foreground notification: ID="+id);
        navigator.notification.beep();
        console.log("Beep!");
        navigator.notification.vibrate();
        console.log("BZZZ!");
	}
};