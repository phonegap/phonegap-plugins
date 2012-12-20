


The child browser allows you to display external webpages within your PhoneGap application.

A simple use case would be:

- Users can post links, and you don't want your users to exit your app to view the link.

This command creates a popup browser that is shown in front of your app, when the user presses the done button they are simply returned to your app ( actually they never left )

The ChildBrowser has buttons for refreshing, navigating back + forwards, as well as the option to open in Safari.

Note, because this is open source, I could not include the graphics I usually use for the back/forward and safari buttons.  I have changed the XIB file to use system buttons ( rewind / fast-forward + action ) Ideally you should modify the XIB to use your own look.

Here is a sample command to open google in a childbrowser :

PhoneGap.exec("ChildBrowserCommand.showWebPage", "http://www.google.com" );

=================================

June 1, 2010
Added support for orientations, supportedOrientations are passed through to the child view controller. -jm


================================

Sept 13, 2010
+ added callbacks for location change, close, opening in safari, 
+ added method to close the browser from js.  
( This should allow easy additions for facebook connect as you can monitor the browser's address and respond accordingly.  )
+ added images to the XIB, these need to be attached as resources in your xcode project.

Sample use:

<code>
	var root = this;
	
	/* When this function is called, PhoneGap has been initialized and is ready to roll */
	function onDeviceReady()
	{
		var cb = ChildBrowser.install();
		if(cb != null)
		{
			cb.onLocationChange = function(loc){ root.locChanged(loc); };
			cb.onClose = function(){root.onCloseBrowser()};
			cb.onOpenExternal = function(){root.onOpenExternal();};

			window.plugins.childBrowser.showWebPage("http://google.com");
			
		}
	}

	function onCloseBrowser()
	{
		alert("In index.html child browser closed");
	}
	
	function locChanged(loc)
	{
		alert("In index.html new loc = " + loc);
	}
	
	function onOpenExternal()
	{
		alert("In index.html onOpenExternal");
	}
</code>




