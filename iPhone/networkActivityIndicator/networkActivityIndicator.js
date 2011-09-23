function networkActivityIndicator() {
}

networkActivityIndicator.prototype.set = function(value,success,fail) 
{
    if(value)
        value = "true";
    else
        value = "false";
    PhoneGap.exec("networkActivityIndicator.setIndicator",value,GetFunctionName(success),GetFunctionName(fail));
};


PhoneGap.addConstructor(function() 
{
	if(!window.plugins)
	{
		window.plugins = {};
	}
    window.plugins.networkActivityIndicator = new networkActivityIndicator();
});