var AccountList = function(gap) {

	AccountList.prototype.get = function(params, success, fail) {
		return gap.exec( function(args) {
			success(args);
		}, function(args) {
			fail(args);
		}, 'AccountList', '', [params]);
	};

	gap.addConstructor(function () {
		if (gap.addPlugin) {
	            gap.addPlugin("AccountList", new AccountList());
	        } else {
	            if (!window.plugins) {
	                window.plugins = {};
	            }
	
	            window.plugins.ccountList = new AccountList();
	        }
	});

})(window.cordova || window.Cordova || window.PhoneGap);
