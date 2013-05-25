# External App Launcher

A Cordova plugin to launch external applications from your Cordova-based iOS application.  
Compatible with Cordova >= 2.5.0

### Hosted at

https://github.com/sbahal/external-app-launcher

### Steps to install

1. Install [cordova-plugman](https://github.com/apache/cordova-plugman).
2. ```cd``` into your project directory.
3. Execute the following command:

```
plugman --platform ios --project . --plugin https://github.com/sbahal/external-app-launcher.git
```

### Steps to uninstall

```
plugman --uninstall --platform ios --project . --plugin org.cordova.plugins.ExternalAppLauncher
```

### Usage

```
externalApp.launch([appUrlScheme, storeUrl, alertMessage, alertType]);
```
where,  
```appUrlScheme```: the URL scheme of the app that you wish to launch  
```storeUrl```: the URL to be redirected to in case the external app is not found  
```alertMessage```: the message to be displayed to the user in case the external app is not found  
```alertType```: the type of alert to be presented to the user
  * ```externalApp.alertType.OK```: to just display an alert message, or 
  * ```externalApp.alertType.OK_CANCEL```: to redirect the user to the specified store  

### Example

```
externalApp.launch('com.foo.MyApp', '', 'Please download the latest version of this app from the store', externalApp.alertType.OK);
externalApp.launch('com.foo.MyApp', 'https://foo.com', 'Please download the latest version of this app from the store', externalApp.alertType.OK_CANCEL);
```