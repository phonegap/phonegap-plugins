# EmailComposer with attachments handling

**Update: VERSION 1.1**
Now the plugin can handle any type of attachments, not only images or PDFs

**Description**
This is a modification of the EmailComposer iOS plugin made by **Randy McMillan**
In this version of the plugin, you can attach images and PDF files to emails. A little refactoring was made.
It is compliant with Cordova 2.2.0 standard (new CDVInvokedUrlCommand parameter sent to native methods). If you want to use the plugin with an older version of Cordova you must comment the method

	showEmailComposer:(CDVInvokedUrlCommand*)command;
	
and uncomment the method

	showEmailComposer:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
	
both in EmailComposer.h and EmailComposer.m files

**IMPORTANT:** You will need to add MessageUI.framework to your project if it is not already included.

**IMPORTANT:** by now, you can attach only PDF and IMAGES (the latter will be convertend in PNG format)

- Add the EmailComposer.h EmailComposer.m  files to your Plugins Folder.

- Place the EmailComposer.js file somewhere in your www folder, and include it from your html.

- Add to Cordova.plist Plugins: key **EmailComposer** value **EmailComposer**

Callable interface:

	window.plugins.emailComposer.showEmailComposerWithCallback(callback,subject,body,toRecipients,ccRecipients,bccRecipients,isHtml,attachments);

or

	window.plugins.emailComposer.showEmailComposer(subject,body,toRecipients,ccRecipients,bccRecipients,isHtml,attachments);

**Parameters:**
- callback: a js function that will receive return parameter from the plugin
- subject: a string representing the subject of the email; can be null
- body: a string representing the email body (could be HTML code, in this case set **isHtml** to **true**); can be null
- toRecipients: a js array containing all the email addresses for TO field; can be null/empty
- ccRecipients: a js array containing all the email addresses for CC field; can be null/empty
- bccRecipients: a js array containing all the email addresses for BCC field; can be null/empty
- isHtml: a bool value indicating if the body is HTML or plain text
- attachments: a js array containing all full paths to the files you want to attach; can be null/empty

**Example**

	window.plugins.emailComposer.showEmailComposerWithCallback(function(result){console.log(result);},"Look at this photo","Take a look at <b>this<b/>:",["example@email.com", "johndoe@email.org"],[],[],true,["_complete_path/image.jpg"]);

**Return values**
- 0: email composition cancelled (cancel button pressed and draft not saved)
- 1: email saved (cancel button pressed but draft saved)
- 2: email sent
- 3: send failed
- 4: email not sent (something wrong happened)
