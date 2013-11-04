function onBodyLoad() {
	try {
		// $.mobile.loadingMessage = "Please wait";
		if (typeof navigator.device == "undefined") {
			document.addEventListener("deviceready", onPhoneGapLoad, false);
		} else {
			onPhoneGapLoad();
		}
	} catch (e) {
		alert(e);
	}
}

function onPhoneGapLoad() {
	try {
		window.plugins.locale.get("hello", null, function(value) {
			// Success
			alert("value:" + value);
		}, function(error) {
			// Failure
			alert("error:" + error);
		});
	} catch (e) {
		alert(e);
	}
}
