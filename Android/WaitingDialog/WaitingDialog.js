// window.plugins.waitingDialog

function WaitingDialog() {
}

WaitingDialog.prototype.show = function(text) {
	cordova.exec(null, null, "WaitingDialog", "show", [text]);
}

WaitingDialog.prototype.hide = function() {
	cordova.exec(null, null, "WaitingDialog", "hide", []);
}

cordova.addConstructor(function()  {
	if(!window.plugins) {
	   window.plugins = {};
	}

   // shim to work in 1.5 and 1.6
   if (!window.Cordova) {
	   window.Cordova = cordova;
   };

   window.plugins.waitingDialog = new WaitingDialog();
});