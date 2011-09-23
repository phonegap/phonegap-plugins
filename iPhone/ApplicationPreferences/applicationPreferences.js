function applicationPreferences() {
}

applicationPreferences.prototype.get = function(name,success,fail) 
{

    PhoneGap.exec("applicationPreferences.getSetting", name,GetFunctionName(success),GetFunctionName(fail));
};

applicationPreferences.prototype.set = function(name,value,success,fail) 
{

    PhoneGap.exec("applicationPreferences.setSetting", name,value,GetFunctionName(success),GetFunctionName(fail));
};

PhoneGap.addConstructor(function() 
{
	if(!window.plugins)
	{
		window.plugins = {};
	}
    window.plugins.applicationPreferences = new applicationPreferences();
});