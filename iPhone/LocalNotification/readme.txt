LocalNotification phonegap Plugin
The original LocalNotification plugin for iOS was not well documented and was lacking a few very important features.

This new version includes -
backgroundCallback - a callback if the app was in the background when the notification happened.
foregroundCallback - a callback if the app was in the foreground when the notification happened.
sound - Attach a sound to the notification.

TWO VERY IMPORTANT STEPS
Adjusting your AppDelegate to watch for the callback and fire it. Check out the sample file.

To add a sound you must first convert it to a .caf file, and then drag it into your resources folder in xcode.

other than that it works just the same, just a bit more functionality.

a write up about the changes can be found here.
http://www.drewdahlman.com/meusLabs/?p=117

a full explanation of how LocalNotifications work can be found here
http://www.drewdahlman.com/meusLabs/?p=84

