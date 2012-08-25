Added Cordova 1.5 support March 2012 - @RandyMcMillan

• You will need to add MessageUI.framework to your project if it is not already included.

• Just add the EmailComposer.h EmailComposer.m  files to your Plugins Folder.

• Place the EmailComposer.js file in your app root, and include it from your html.

• Add to Cordova.plist Plugins: key EmailComposer value EmailComposer

• This is intended to also demonstrate how to pass arguments to native code using the options/map object.

• Please review the js file to understand the interface you can call, and reply with any questions.

        Cordova.exec(null, null, "EmailComposer", "showEmailComposer", [args]);
