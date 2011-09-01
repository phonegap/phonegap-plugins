//
//  ShareKitPlugin.js
//  
//
//  Created by Erick Camacho on 28/07/11.
//  MIT Licensed
//

function ShareKitPlugin()
{
	console.log('creating plugin');
};

ShareKitPlugin.prototype.share = function(message, url)
{
	
	PhoneGap.exec(null, null, "ShareKitPlugin", "share", [message, url]);
    
};


ShareKitPlugin.prototype.isLoggedToTwitter = function( callback )
{
	
    PhoneGap.exec(callback, null, "ShareKitPlugin", "isLoggedToTwitter", [] );
};

ShareKitPlugin.prototype.isLoggedToFacebook = function( callback )
{
	
    PhoneGap.exec(callback, null, "ShareKitPlugin", "isLoggedToFacebook", [] );

};

ShareKitPlugin.prototype.logoutFromTwitter = function()
{
	
    PhoneGap.exec(null, null, "ShareKitPlugin", "logoutFromTwitter", [] );

};

ShareKitPlugin.prototype.logoutFromFacebook = function()
{
	
    PhoneGap.exec(null, null, "ShareKitPlugin", "logoutFromFacebook", [] );

};


ShareKitPlugin.prototype.facebookConnect = function(callback)
{
	
    PhoneGap.exec(callback, null, "ShareKitPlugin", "facebookConnect", [] );
    
};
ShareKitPlugin.prototype.shareToFacebook = function( message, url)
{
	
    PhoneGap.exec(null, null, "ShareKitPlugin", "shareToFacebook", [message, url] );
    
};



ShareKitPlugin.prototype.twitterConnect = function(callback)
{
    PhoneGap.exec(callback, null, "ShareKitPlugin", "twitterConnect", [] );
};
ShareKitPlugin.prototype.shareToTwitter = function(message, url)
{
	
    PhoneGap.exec(null, null, "ShareKitPlugin", "shareToTwitter", [message, url] );
    
};





ShareKitPlugin.install = function()
{
    if(!window.plugins)
    {
        window.plugins = {};	
    }

    
    window.plugins.shareKit = new ShareKitPlugin();
    return window.plugins.shareKit;
};


PhoneGap.addConstructor(ShareKitPlugin.install);