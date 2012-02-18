# PhoneGap SMSComposer #
by Grant Sanders

## Adding the Plugin to your project ##

Using this plugin requires [PhoneGap for iPhone](http://github.com/phonegap/phonegap-iphone).

1. Add the SMSComposer.h and SMSComposer.m files to your "Plugins" folder in your PhoneGap project
2. Add the SMSComposer.js files to your "www" folder on disk, and add a reference to the .js file after phonegap.js.
3. Add the MessageUI framework to your Xcode project. In Xcode 4, double-click on the target, select "Build Phases" -> "Link Binary with Libraries" -> "+" and select "MessageUI.framework".
4. Add the plugin to the PhoneGap.plist under Plugins (key: "SMSComposer" value: "SMSComposer")

## RELEASE NOTES ##

###20120219 ###
* Fix for deprecations in PhoneGap 1.4.x
* Added PhoneGap.plist instructions in README.md

### 201101112 ###
* Initial release
* Adds SMS text message composition in-app.
* Requires iOS 4.0 or higher. 
  Attempts to compose SMS text without running 4.0+ fails gracefully with a friendly message.

## EXAMPLE USAGE ##

* All parameters are optional.
	`window.plugins.smsComposer.showSMSComposer();`


* Passing phone number and message.
	`window.plugins.smsComposer.showSMSComposer('3424221122', 'hello');`

* Multiple recipents are separated by comma(s).
	`window.plugins.smsComposer.showSMSComposer('3424221122,2134463330', 'hello');`


* `showSMSComposerWithCB` takes a callback as its first parameter.  
* 0, 1, 2, or 3 will be passed to the callback when the text message has been attempted.

```javascript
	window.plugins.smsComposer.showSMSComposerWithCB(function(result){

		if(result == 0)
			alert("Cancelled");
		else if(result == 1)
			alert("Sent");
		else if(result == 2)
			alert("Failed.");
		else if(result == 3)
			alert("Not Sent.");		

	},'3424221122,2134463330', 'hello');
````````

* A fully working example as index.html has been added to this repository. 
* It is an example of what your www/index.html could look like.