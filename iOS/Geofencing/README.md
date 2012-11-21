PhoneGap-Geofencing
===================

Geofencing And Significant Location Change Monitoring Plugin For PhoneGap.

## DESCRIPTION ##

* This plugin provides a simple way to use iOS Region Monitoring in PhoneGap applications.
* Significant location changes API is exposed.
* Simple JS interface is exposed to allow the adding and removing of regions to monitor.
* Included ability to receive realtime region notifications when regions are entered and exited.

## WHAT IS GEOFENCING ##

Geofencing is a way to monitor geographic regions.  In iOS it allows an app to be informed when a specified geographic region is entered or exited.

## SETUP ##

Using this plugin requires [Cordova iOS](https://github.com/apache/incubator-cordova-ios).

1. Make sure your Xcode project has been [updated for Cordova](https://github.com/apache/incubator-cordova-ios/blob/master/guides/Cordova%20Upgrade%20Guide.md)
2. Drag and drop the DGGeofencing.h and DGGeofencing.m files from the DGGeofencing folder in Finder to your Plugins folder in XCode.
3. Add the .js files to your `www` folder on disk, and add reference(s) to the .js files using <script> tags in your html file(s)

    <script type="text/javascript" src="/js/plugins/Geofencing.js"></script>

4. Add new entry with key `DGGeofencing` and value `DGGeofencing` to `Plugins` in `Cordova.plist/Cordova.plist`

## INCLUDED FUNTIONS ##

DGGeofencing.js contains the following functions:

1. addRegion - Adds a new region to be monitored.
2. removeRegion - Clears an existing region from being monitored.
3. getWatchedRegionIds - Returns a list of currently monitored region identifiers.
4. startMonitoringSignificantLocationChanges - Starts monitoring significant location changes.
5. stopMonitoringSignificantLocationChanges - Stops monitoring significant location changes.

## PLUGIN CODE EXAMPLE ##

To add a new region to be monitored use the DGGeofencing addRegion function.
The parameters are:

1. fid - String - This is a unique identifier.
2. radius - Integer - Specifies the radius in meters of the region.
3. latitude - String - latitude of the region.
4. longitude - String - latitude of the region.

Example:

    var params = {"fid": location.id, "radius": 15, "latitude": location.lat, "longitude": location.lng};
	console.log(params);
	DGGeofencing.addRegion(
		params,
		function(result) { 
			console.log("add success");
      	},
      	function(error) {   
	  		alert("failed to add region");
      	}
	);

To remove an existing region use the DGGeofencing removeRegion function.
The parameters are:
1. fid - String - This is a unique identifier.
2. latitude - String - latitude of the region.
3. longitude - String - latitude of the region.

Example:

	var params = {"fid": item.fid, "latitude": item.latitude, "longitude": item.longitude};
	DGGeofencing.removeRegion(
		params,
		function(result) { 
			alert("delete success"); 				   
		},
		function(error) {  
			alert("delete error");   
		}
	);

To retrieve the list of identifiers of currently monitored regions use the DGGeofencing getWatchedRegionIds function.
No parameters.

The result object contains an array of strings in regionids 

Example:

	DGGeofencing.getWatchedRegionIds(
		function(result) { 
			alert("success: " + result.regionids); 				   
		},
		function(error) {  
			alert("error");   
		}
	);

To start monitoring signifaction location changes use the DGGeofencing startMonitoringSignificantLocationChanges function.
No parameters.

Example:

	DGGeofencing.startMonitoringSignificantLocationChanges(
		function(result) { 
			console.log("Location Monitor Success: " + result);				   
		},
		function(error) {  
			console.log("failed to monitor location changes");   
		}
	);

To start monitoring signifaction location changes use the DGGeofencing startMonitoringSignificantLocationChanges function.
No parameters.

Example:

	DGGeofencing.stopMonitoringSignificantLocationChanges(
		function(result) { 
			console.log("Stop Location Monitor Success: " + result);				   
		},
		function(error) {  
			console.log("failed to stop monitor location changes");   
		}
	);
	
## HOW TO SETUP REGION AND LOCATION NOTIFICATIONS ##

Of course adding and removing monitored regions would be useless without the ability to receive real time notifications when region boundries are crossed.
This setup will allow the JavaScript to receive updates both when the app is running and not running.

Follow these steps to setup region notifications when the app is running:

1. Drag and drop the DGGeofencingHelper.h and DGGeofencingHelper.m files from the DGGeofencing folder in Finder to your Plugins folder in XCode.
2. Add the following code to the viewDidLoad function in the MainViewController.m file after [super viewDidLoad];
	
	<pre>[[DGGeofencingHelper sharedGeofencingHelper] setWebView:self.webView];</pre>

3. Make sure to import DGGeofencingHelper.h in the MainViewController.m file.
4. In your JavaScript add the following code in the same place where you process the documentReady event.

	<pre>document.addEventListener("region-update", function(event) {
		var fid = event.regionupdate.fid;
		var status = event.regionupdate.status;
	});</pre>

5. For location changes add the following code in your JavaScript code in the same place where you process the documentReady event.

	<pre>document.addEventListener('location-update', function(event) {
		var new_timestamp = event.locationupdate.new_timestamp;
		var new_speed = event.locationupdate.new_speed;
		var new_course = event.locationupdate.new_course;
		var new_verticalAccuracy = event.locationupdate.new_verticalAccuracy;
		var new_horizontalAccuracy = event.locationupdate.new_horizontalAccuracy;
		var new_altitude = event.locationupdate.new_altitude;
		var new_latitude = event.locationupdate.new_latitude;
		var new_longitude = event.locationupdate.new_longitude;
			
		var old_timestamp = event.locationupdate.old_timestamp;
		var old_speed = event.locationupdate.old_speed;
		var old_course = event.locationupdate.old_course;
		var old_verticalAccuracy = event.locationupdate.old_verticalAccuracy;
		var old_horizontalAccuracy = event.locationupdate.old_horizontalAccuracy;
		var old_altitude = event.locationupdate.old_altitude;
		var old_latitude = event.locationupdate.old_latitude;
		var old_longitude = event.locationupdate.old_longitude;
			
		console.log("Location Update Event: " + event);	
	});</pre>

When the app is not running, even in the background,  region notifications are saved as they come in.
In order to retrieve these pending region notifications follow these instructions.

1. Add the following code in the app delegate - (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions

<pre>if ([[launchOptions allKeys] containsObject:UIApplicationLaunchOptionsLocationKey]) {
    [[DGGeofencingHelper sharedGeofencingHelper] setDidLaunchForRegionUpdate:YES];
} else {
    [[DGGeofencingHelper sharedGeofencingHelper] setDidLaunchForRegionUpdate:NO];
}</pre>

2. In the JavaScript you will need to use the following code to retrieve these notifications.

    <pre>    DGGeofencing.getPendingRegionUpdates(
			function(result) { 
				var updates = result.pendingupdates;
				$(updates).each(function(index, update){
					var fid = update.fid;
					var status = update.status;
					var timestamp = update.timestamp;
					console.log("fid: " + fid + " status: " + status + " timestamp: " + timestamp);
				});   
	      	},
	      	function(error) {   
		  		alert("failed");
	      	}
		);</pre>
	
## USAGE SAMPLE CODE ##

Feel free to take a look at a project I have made that uses the above plugin.
You can find this project in my github repository [Phonegap-Geofencing](https://github.com/radshag/PhoneGap-Geofencing/tree/master/iOS/Sample). 

## QUESTIONS AND COMMENTS ##

All questions and comments are welcome.  Please do so on my [GitHub Page](https://github.com/radshag/PhoneGap-Geofencing/issues).

The latest version of the DGGeofencing plugin can always be found [here](https://github.com/radshag/PhoneGap-Geofencing/tree/master/iOS/DGGeofencing).

## LICENSE ##

The MIT License

Copyright (c) 2012 Dov Goldberg
EMAIL: dov.goldberg@ogonium.com   
WEBSITE: http://www.ogonium.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.