var msgbox = function() {
	}
 
		msgbox.prototype.show = function(str, success, fail) {
		PhoneGap.exec(success, fail, "msgbox", "show", [str]);
	};
 
	navigator.msgbox = new msgbox();