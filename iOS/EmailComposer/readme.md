March 2012 : Added Cordova 1.5 support - RandyMcMillan
July 2012 : Added Cordova 2.0 support - RandyMcMillan
August 2012 : Documentation examples - Guillaume Charhon


## Adding the Plugin to your project ##


• You will need to add MessageUI.framework to your project if it is not already included.

• Just add the EmailComposer.h EmailComposer.m  files to your Plugins Folder.

• Place the EmailComposer.js file in your app root, and include it from your html.

• Add to Cordova.plist Plugins: key EmailComposer value EmailComposer


## Using the plugin ##

The plugin creates the object `window.plugins.emailComposer` with the following methods:
	
	// Show an email composer
	showEmailComposer([subject],[body],[toRecipients],[ccRecipients],[bccRecipients],[bIsHTML])
	
	// Show an email composer with a callback
	showEmailComposerWithCB(cbFunction,[subject],[body],[toRecipients],[ccRecipients],[bccRecipients],[bIsHTML])
	
	
	
