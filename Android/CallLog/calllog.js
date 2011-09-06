var CallLog = function() {
};

CallLog.prototype.list = function(params, successCallback, failureCallback) {
	return PhoneGap.exec(successCallback, failureCallback, 'CallListPlugin', 'list',
			[ params ]);
};

CallLog.prototype.contact = function(params, successCallback, failureCallback) {
	return PhoneGap.exec(successCallback, failureCallback, 'CallListPlugin', 'contact',
			[ params ]);
};

CallLog.prototype.show = function(params, successCallback, failureCallback) {
	return PhoneGap.exec(successCallback, failureCallback, 'CallListPlugin', 'show',
			[ params ]);
};

PhoneGap.addConstructor(function() {
	PhoneGap.addPlugin('CallLog', new CallLog());
	PluginManager.addService("CallListPlugin", "com.leafcut.ctrac.CallListPlugin");
});