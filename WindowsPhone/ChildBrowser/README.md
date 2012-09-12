ChildBrowser plugin usage:
=========================

Source files
---
ChildBrowser.js - plugin definition and js implementation
ChildBrowserCommand.cs - native side implementation

Usage
=====

In your Head:
----------
 Add <script type="text/javascript" charset="utf-8" src="ChildBrowser.js"></script> after you added Cordova.js
 
In code:
--------
 * Call ChildBrowser.install() before making any Child Browser Calls.
 * Use window.plugins.childBrowser.showWebPage(url) to open a URL.
 * Make sure you include the folder Images/ to your root directory with all the files. Then change the files Build Action to Content. This will enable the child browser functions (back, forward, close) to have proper icons at respective theme changes.
 