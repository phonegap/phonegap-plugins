This plugin is a different philosophy to how contacts can work with PhoneGap Android. Rather than pulling in the contacts into HTML, this plugin allows you to leave the PhoneGap webview and enter into a native contact picker. Once the user has selected a contact, they will be sent back into the PhoneGap webview with the name of the contact available.


How to use:

Usage:

window.plugins.contactView.show(success, failure);

Success returns an object with the name and the phone of the contact selected.

Example:

	document.querySelector("#contact-name-to-native").addEventListener("touchstart", function() {
	    window.plugins.contactView.show(
	    	function(contact) {
	    		document.getElementById("contact-name-from-native").value = contact.name;
	    		document.getElementById("contact-phone").value = contact.phone;
	    	},
	    	function(fail) {
	    		alert("We were unable to get the contact you selected.");
	    	}
	    );
    }, false);
    
   

For the current files to work, you'll need to create a package (folders) called com.rearden. You can change this to whatever you like, just update the ContactView.js and ContactView.java.

ContactView.js should go in the asset folder and should be referenced in your index.html file.


Limitations:

It only grabs the Name and Phone number, but not any other information.
It only works with Android API 2.0 and above. Future versions will include older APIs.