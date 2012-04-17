// JavaScript Document
// PROJECT: Phonegap LocalNotifications
// AUTHOR: Drew Dahlman ( www.drewdahlman.com )
// DATE: 1.26.2012

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


// NOTIFICATION CENTER
/*
I like to set up one object that's only job is to manage notifications
*/
var notification = {
	init:function(){
		
	},
	
	// This will fire after 60 seconds
	local_min:function(){
		var d = new Date();
		d = d.getTime() + 60*1000; //60 seconds from now
		d = new Date(d);
		plugins.localNotification.add({
			date: d,
			repeat:'daily',
			message: 'This just fired after a minute!',
			hasAction: true,
			badge: 1,
			id: '123',
			sound:'horn.caf',
			background:'app.background()',
			foreground:'app.running()'
		});
	},
	
	// This will fire based on the time provided.
	// Something to note is that the iPhone goes off of 24hr time
	// it defaults to no timezone adjustment so +0000 !IMPORTANT
	local_timed:function(hh,mm){
		// the example time we provide is 13:00
		// This means the alarm will go off at 1pm +0000
		// how does this translate to your time? While the phone schedules 1pm +0000
		// it will still go off at your desired time base on your phones time.
		
		console.log(hh+" "+mm);
		// Now lets make a new date
		var d = new Date();
			d = d.setSeconds(00);
			d = new Date(d);
			d = d.setMinutes(mm);
			d = new Date(d);
			d = d.setHours(hh);
			d = new Date(d);
		plugins.localNotification.add({
			date: d,
			repeat:'daily',
			message: 'This went off just as expected!',
			hasAction: true,
			badge: 1,
			id: '123',
			sound:'horn.caf',
			background:'app.background()',
			foreground:'app.running()'
		});
	},
	clear:function(){
		plugins.localNotification.cancelAll();
	},
	tomorrow:function(hh,mm,days){
		// Now lets make a new date
		var d = new Date();
			d = d.setSeconds(00);
			d = new Date(d);
			d = d.setMinutes(mm);
			d = new Date(d);
			d = d.setHours(hh);
			d = new Date(d);
			
			// add a day
			d = d.setDate(d.getDate()+days);
			d = new Date(d);
			
		plugins.localNotification.add({
			date: d,
			repeat:'daily',
			message: 'This went off just as expected!',
			hasAction: true,
			badge: 1,
			id: '123',
			sound:'horn.caf',
			background:'app.background()',
			foreground:'app.running()'
		});
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
	background:function(){
		console.log("I was in the background but i'm back now!");
	},
	running:function(){
		console.log("I am currently running, what should I do?");
	}
};