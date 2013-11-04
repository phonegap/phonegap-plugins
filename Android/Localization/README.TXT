Localization Plug-In For Android
================================
This plugin allows you to access the localization resource values defined in your RES folder from JavaScript.

Location:
---------
- assets\www\localizable.js
- src\dell\phoneGap\localization\Localizable.java

Preparation:
------------
1. Add the following reference to your html file:
<script type="text/javascript" src="localizable.js"></script>

2. Create different resource files for each locale as you normally do it in Android:
http://developer.android.com/guide/topics/resources/localization.html

3. Add localizable.js to the following folder in your project:
<project>/assets/www/localizable.js

4. Add localizable.java to the following folder in your project:
<project>/src/<namespace>/localizable.js
 
Usage:
------

Note: Change {resource_name} with the actual name attribute associated to the resource entry.

To retrieve a specific value use it as follows:
<code>
	window.plugins.locale.get("{resource_name}", null, function(value) {
		// Success
		alert("value:" + value);
	}, function(error) {
		// Failure
		alert("error:" + error);
	});
</code>

To pull all values at once do it as follows:
<code>
	var resourceValues = null; // Define this as a global variable that you can use anywhere in your js code

	window.plugins.locale.values(null, function(values) {
	// Success
		resourceValues = values;
		alert("value-{resource_name}:" + resourceValues.{resource_name});
	}, function(error) {
		// Failure
		alert("error:" + error);
	});
</code>

