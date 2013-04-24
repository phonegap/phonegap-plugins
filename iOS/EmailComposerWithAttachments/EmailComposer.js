// window.plugins.emailComposer

function EmailComposer() {
	this.resultCallback = null; // Function
}

EmailComposer.ComposeResultType = {
    Cancelled:0,
    Saved:1,
    Sent:2,
    Failed:3,
    NotSent:4
}

// showEmailComposer : all args optional
EmailComposer.prototype.showEmailComposer = function(subject, body, toRecipients, ccRecipients, bccRecipients, bIsHTML, attachments) {
	console.log("****************************AVVIATO");
	var args = {};
	args.subject = subject ? subject : "";
	args.body = body ? body : "";
	args.toRecipients = toRecipients ? toRecipients : [];
	args.ccRecipients = ccRecipients ? ccRecipients : [];
	args.bccRecipients = bccRecipients ? bccRecipients : [];
	args.bIsHTML = bIsHTML ? true : false;
  args.attachments = attachments ? attachments : [];
	cordova.exec(null, null, "EmailComposer", "showEmailComposer", [args]);
}

EmailComposer.prototype.showEmailComposerWithCallback = function(callback, subject, body, toRecipients, ccRecipients, bccRecipients, isHTML, attachments) {
	this.resultCallback = callback;
	this.showEmailComposer.apply(this, [subject, body, toRecipients, ccRecipients, bccRecipients, isHTML, attachments]);
}

EmailComposer.prototype._didFinishWithResult = function(res) {
	this.resultCallback(res);
}

cordova.addConstructor(function() {
	console.log("****************************");
	if (!window.plugins) {
    window.plugins = {};
	}
					   
	// shim to work in 1.5 and 1.6
	if (!window.Cordova) {
		window.Cordova = cordova;
	};
					   
	window.plugins.emailComposer = new EmailComposer();
});
