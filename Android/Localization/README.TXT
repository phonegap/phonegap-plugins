Localization Plug-In For Android
================================
This plugin allows you to access the localization resource values defined in your RES folder from JavaScript.

Location:
---------
- assets\www\localizable.js
- src\dell\phoneGap\localization\Localizable.java

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

