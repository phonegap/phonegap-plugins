# Cordova PushNotification Plugin #
by `Olivier Louvignes`

## DESCRIPTION ##

* This plugin provides a simple way to use Apple Push Notifications (or Remote Notifications) from IOS. It does comply with the latest (future-2.x) cordova standards.

* This was inspired by the now orphaned [ios-phonegap-plugin](https://github.com/urbanairship/ios-phonegap-plugin) build by Urban Airship.

## PLUGIN SETUP ##

Using this plugin requires [Cordova iOS](https://github.com/apache/incubator-cordova-ios).

1. Make sure your Xcode project has been [updated for Cordova](https://github.com/apache/incubator-cordova-ios/blob/master/guides/Cordova%20Upgrade%20Guide.md)
2. Drag and drop the `ProgressHud` folder from Finder to your Plugins folder in XCode, using "Create groups for any added folders"
3. Add the .js files to your `www` folder on disk, and add reference(s) to the .js files using `<script>` tags in your html file(s)


    `<script type="text/javascript" src="/js/plugins/PushNotification.js"></script>`


4. Add new entry with key `PushNotification` and value `PushNotification` to `Plugins` in `Cordova.plist/Cordova.plist`

## APPDELEGATE SETUP ##

This plugin requires modifications to your `AppDelegate.m`. Append the block below at the end of your file, between your `dealloc` method and the implementation `@end`.


    /* ... */

    - (void) dealloc
    {
        [super dealloc];
    }

    /* START BLOCK */

    #pragma PushNotification delegation

    - (void)application:(UIApplication*)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
    {
        PushNotification* pushHandler = [self.viewController getCommandInstance:@"PushNotification"];
        [pushHandler didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    }

    - (void)application:(UIApplication*)app didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
    {
        PushNotification* pushHandler = [self.viewController getCommandInstance:@"PushNotification"];
        [pushHandler didFailToRegisterForRemoteNotificationsWithError:error];
    }

    - (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
    {
        PushNotification* pushHandler = [self.viewController getCommandInstance:@"PushNotification"];
        NSMutableDictionary* mutableUserInfo = [userInfo mutableCopy];

        // Get application state for iOS4.x+ devices, otherwise assume active
        UIApplicationState appState = UIApplicationStateActive;
        if ([application respondsToSelector:@selector(applicationState)]) {
            appState = application.applicationState;
        }

        [mutableUserInfo setValue:@"0" forKey:@"applicationLaunchNotification"];
        if (appState == UIApplicationStateActive) {
            [mutableUserInfo setValue:@"1" forKey:@"applicationStateActive"];
            [pushHandler didReceiveRemoteNotification:mutableUserInfo];
        } else {
            [mutableUserInfo setValue:@"0" forKey:@"applicationStateActive"];
            [mutableUserInfo setValue:[NSNumber numberWithDouble: [[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
            [pushHandler.pendingNotifications addObject:mutableUserInfo];
        }
    }

    /* STOP BLOCK */

    @end

In order to support launch notifications (app starting from a remote notification), you have to add the following block inside `- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions`, just before the return YES;


    [self.window addSubview:self.viewController.view];
    [self.window makeKeyAndVisible];

    /* START BLOCK */

    // PushNotification - Handle launch from a push notification
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo) {
        PushNotification *pushHandler = [self.viewController getCommandInstance:@"PushNotification"];
        NSMutableDictionary* mutableUserInfo = [userInfo mutableCopy];
        [mutableUserInfo setValue:@"1" forKey:@"applicationLaunchNotification"];
        [mutableUserInfo setValue:@"0" forKey:@"applicationStateActive"];
        [pushHandler.pendingNotifications addObject:mutableUserInfo];
    }

    /* STOP BLOCK */

    return YES;


## JAVASCRIPT INTERFACE ##

    // After device ready, create a local alias
    var pushNotification = window.plugins.pushNotification;

`registerDevice()` does perform registration on Apple Push Notification servers (via user interaction) & retreive the token that will be use to push remote notifications to this device.


    pushNotification.registerDevice({alert:true, badge:true, sound:true}, function(status) {
        console.warn('registerDevice:%o', status);
        navigator.notification.alert(JSON.stringify(['registerDevice', status]));
    });


`getPendingNotifications()` should be used when your application starts or become active (from the background) to retreive notifications that have been pushed while the application was inactive or offline. Returned params `applicationStateActive` & `applicationLaunchNotification` enables you to filter notifications by their type.


    pushNotification.getPendingNotifications(function(notifications) {
        console.warn('getPendingNotifications:%o', notifications);
        navigator.notification.alert(JSON.stringify(['getPendingNotifications', notifications]));
    });


`getRemoteNotificationStatus()` does perform registration check for this device.


    pushNotification.getRemoteNotificationStatus(function(status) {
        console.warn('getRemoteNotificationStatus:%o', status);
        navigator.notification.alert(JSON.stringify(['getRemoteNotificationStatus', status]));
    });


`setApplicationIconBadgeNumber()` can be used to set the application badge number (that can be updated by a remote push, for instance, resetting it to 0 after notifications have been processed).


    pushNotification.setApplicationIconBadgeNumber(12, function(status) {
        console.warn('setApplicationIconBadgeNumber:%o', status);
        navigator.notification.alert(JSON.stringify(['setBadge', status]));
    });

Finally, when a remote push notification is received while the application is active, an event will be triggered on the DOM `document`.

    document.addEventListener('push-notification', function(event) {
        console.warn('push-notification!:%o', event);
        navigator.notification.alert(JSON.stringify(['push-notification!', event]));
    });

* Check [source](http://github.com/mgcrea/phonegap-plugins/tree/master/iOS/PushNotification/PushNotification.js) for additional configuration.

## BUGS AND CONTRIBUTIONS ##

Patches welcome! Send a pull request. Since this is not a part of Cordova Core (which requires a CLA), this should be easier.

Post issues on [Github](https://github.com/phonegap/phonegap-plugins/issues)

The latest code (my fork) will always be [here](http://github.com/mgcrea/phonegap-plugins/tree/master/iOS/PushNotification)

## LICENSE ##

Copyright 2012 Olivier Louvignes. All rights reserved.

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## CREDITS ##

Inspired by :

* [ios-phonegap-plugin](https://github.com/urbanairship/ios-phonegap-plugin) build by Urban Airship.
