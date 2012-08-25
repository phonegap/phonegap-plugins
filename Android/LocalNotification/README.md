The Android implementation for local notification uses a similar interface as the existing iOS localnotification plugin. The plugin depends on the Android AlarmManager in combination with the Notification Bar.
To use this plugin, you need to perform the following steps:

1. Copy the LocalNotification.js file to your 'www' folder and include it in your index.html
2. Create a package com.phonegap.plugin.localnotification
3. Copy the .java files into this package
4. Fix the import in AlarmReceiver.java around line 67 where R.drawable.ic_launcher is referenced so it matches an icon in your project
5. Update your res/xml/plugins.xml file with the following line:

        <plugin name="LocalNotification" value="com.phonegap.plugin.localnotification.LocalNotification" />

6. Add the following fragment in the AndroidManifest.xml inside the &lt;application&gt; tag:

        <receiver android:name="com.phonegap.plugin.localnotification.AlarmReceiver" >
        </receiver>
		
        <receiver android:name="com.phonegap.plugin.localnotification.AlarmRestoreOnBoot" >
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED" />
            </intent-filter>
        </receiver>
    
    The first part tells Android to launch the AlarmReceiver class when the alarm is be triggered. This will also work when the application is not running.
	The second part restores all added alarms upon device reboot (because Android 'forgets' all alarms after a restart).
	
7. The following piece of code is a minimal example in which you can test the notification:

        	<script type="text/javascript">
                        document.addEventListener("deviceready", appReady, false);
			
                        function appReady() {
                        	console.log("Device ready");
				
                        	if (typeof plugins !== "undefined") {
                        		plugins.localNotification.add({
                        			date : new Date(),
                        			message : "Phonegap - Local Notification\r\nSubtitle comes after linebreak",
                        			ticker : "This is a sample ticker text",
                        			repeatDaily : false,
                        			id : 4
                			});
                		}
        		}
			
                	document.addEventListener("deviceready", appReady, false);
                </script>
		
8. You can use the following commands:

	- plugins.localNotification.add({ date: new Date(), message: 'This is an Android alarm using the statusbar', id: 123 });
	- plugins.localNotification.cancel(123); 
	- plugins.localNotification.cancelAll();
		
9. Enjoy. Daniel