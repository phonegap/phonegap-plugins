var Weixin = function(appId) {
    if(appId != null) {
        this.appId = appId;
        cordova.exec(null, null, 'Weixin', 'registerApp', [appId]);
    }
};

Weixin.prototype = {
    registerApp : function(onSuccess,onError,appId) {
        cordova.exec(onSuccess, onError, 'Weixin', 'registerApp', [appId]);
    },
    setResponser :function(name){
        cordova.exec(null, null, 'Weixin', 'setResponser', [name]);
    },
    textContent : function(onSuccess, onError, types, text, options) {
        cordova.exec(onSuccess, onError, 'Weixin', 'textContent', [types,text,options]);     
    },
    imageContent : function(onSuccess, onError, types, imageUrl, options) {
        cordova.exec(onSuccess, onError, 'Weixin', 'imageContent', [types,imageUrl,options]);
    },
    musicContent : function(onSuccess, onError, types, musicUrl, options) {
        cordova.exec(onSuccess, onError, 'Weixin', 'musicContent', [types,musicUrl,options]);
    },
    videoContent : function(onSuccess, onError, types, videoUrl, options) {
        cordova.exec(onSuccess, onError, 'Weixin', 'videoContent', [types,videoUrl,options]);
    },
    webpageContent : function(onSuccess, onError, types, webpageUrl, options) {
        cordova.exec(onSuccess, onError, 'Weixin', 'webpageContent', [types,webpageUrl,options]);
    },
    APPContent : function(onSuccess, onError, types, options) {
        cordova.exec(onSuccess, onError, 'Weixin', 'APPContent', [types,options]);
    },
    cancleGet : function(){
        cordova.exec(null,null,'Weixin','cancleGet',[]);
    },
    getWXAppInstallUrl : function(onSuccess, onError){
        cordova.exec(onSuccess,onError,'Weixin','getWXAppInstallUrl',[]);
    },
    openWXApp : function(onSuccess,onError){
        cordova.exec(onSuccess,onError,'Weixin','openWXApp',[]);
    },
    isWeixinInstalled : function(onSuccess,onError){
        cordova.exec(onSuccess,onError,'Weixin','isWeixinInstalled',[]);
    },
    isSupportApi : function(onSuccess,onError){
        cordova.exec(onSuccess,onError,'Weixin','isSupportApi',[]);
    }
}

Weixin.install = function(){
    if(!window.plugins){
        window.plugins = {};
    }
    
    window.plugins.weixin = new Weixin();
    return window.plugins.weixin;
};

cordova.addConstructor(Weixin.install);