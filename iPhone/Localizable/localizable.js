function localizable() {
}

localizable.prototype.get = function(name, success) 
{
    PhoneGap.exec("localizable.get", name,GetFunctionName(success));
};

PhoneGap.addConstructor(function() 
{
	if(!window.plugins)
	{
		window.plugins = {};
	}
    window.plugins.localizable = new localizable();
});