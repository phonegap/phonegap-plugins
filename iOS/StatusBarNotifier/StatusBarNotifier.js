;(function(cordova) {

	function StatusBarNotifier() {}

	StatusBarNotifier.prototype.show = function(text, timeOnScreen, callback) {
    if (typeof timeOnScreen === "function") callback = timeOnScreen
	  if (!callback) callback = function() {}
		cordova.exec(callback, callback, "StatusBarNotifier", "show", [{text: text, timeOnScreen: timeOnScreen}])
	}

 	if (!window.plugins) window.plugins = {}
	window.plugins.StatusBarNotifier = new StatusBarNotifier()

})(window.cordova || window.Cordova || window.PhoneGap);
