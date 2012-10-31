/* MIT licensed */
// (c) 2010 Jesse MacFadyen, Nitobi
// Contributions, advice from : 
// http://www.pushittolive.com/post/1239874936/facebook-login-on-iphone-phonegap

function FBConnect()
{
	if(window.plugins.childBrowser == null)
	{
		ChildBrowser.install();
	}
}

FBConnect.prototype.connect = function(client_id,redirect_uri,display)
{
	this.client_id = client_id;
	this.redirect_uri = redirect_uri;
	
	var authorize_url  = "https://graph.facebook.com/oauth/authorize?";
		authorize_url += "client_id=" + client_id;
		authorize_url += "&redirect_uri=" + redirect_uri;
		authorize_url += "&display="+ ( display ? display : "touch" );
		authorize_url += "&type=user_agent";

	window.plugins.childBrowser.showWebPage(authorize_url);
	var self = this;
	window.plugins.childBrowser.onLocationChange = function(loc){self.onLocationChange(loc);};
}

FBConnect.prototype.onLocationChange = function(newLoc)
{
	if(newLoc.indexOf(this.redirect_uri) == 0)
	{
		var result = unescape(newLoc).split("#")[1];
		result = unescape(result);
		
		// TODO: Error Check
		this.accessToken = result.split("&")[0].split("=")[1];		
		//this.expiresIn = result.split("&")[1].split("=")[1];
	
		window.plugins.childBrowser.close();
		this.onConnect();
		
	}
}

FBConnect.prototype.getFriends = function()
{
	var url = "https://graph.facebook.com/me/friends?access_token=" + this.accessToken;
	var req = new XMLHttpRequest();
	
	req.open("get",url,true);
	req.send(null);
	req.onerror = function(){alert("Error");};
	return req;
}

// Note: this plugin does NOT install itself, call this method some time after deviceready to install it
// it will be returned, and also available globally from window.plugins.fbConnect
FBConnect.install = function()
{
	if(!window.plugins)
	{
		window.plugins = {};	
	}
	window.plugins.fbConnect = new FBConnect();
	return window.plugins.fbConnect;
}

