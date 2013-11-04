window.EmailComposer = window.EmailComposer || {};
window.EmailComposer.show = function(to, subject, body, callback, errback){
	if(!callback)
		callback = function(){};
	if(!errback)
		errback = function(){};
	var options = {
		to: to,
		subject: subject,
		body: body
	}
	cordova.exec(callback, errback, "EmailComposer", "show", options);
}