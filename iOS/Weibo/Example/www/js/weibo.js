//  Copyright (c) 2012年 SINA SAE. All rights reserved.
//  Under the Apache License 2.0.

// sina plugins
var cordova = window.cordova;
sina={};
// WEIBO plugin
CDV={};

CDV.WB = {
    init : function(params, cb, fail) {
        appKey = params.appKey;
        appSecret = params.appSecret;
        redirectUrl = params.redirectUrl;
        console.log('appKey: ' + appKey + ", appSecret: " + appSecret);
        cordova.exec(function(response) {
                     console.log('Cordova Weibo Connect plugin initialized successfully.');
                     if(cb)
                     cb(response);
                     },
                     (fail ? fail : null),
                     'org.apache.cordova.weibo.Connect', 'init', [ appKey,
                                                                  appSecret, redirectUrl ]);
    },
    login : function(cb, fail) {
        cordova.exec(function(response) { // login
                     console.log("cdv, access_token: " + response.access_token);
                     if (cb)
                     cb(response.access_token, response.expires_in);
                     }, (fail ? fail : null), 'org.apache.cordova.weibo.Connect', 'login',
                     []);
    },
    logout : function(cb, fail) {
        cordova.exec(function(e) {
                     if (cb)
                     cb(e);
                     }, (fail ? fail : null), 'org.apache.cordova.weibo.Connect', 'logout',
                     []);
    },
    get : function(url, params, success, fail) {
        cordova.exec(function(response) {
                     console.log("response: " + response);
                     if (success)
                     success(response);
                     }, (fail ? fail : null), 'org.apache.cordova.weibo.Connect', 'get', [
                                                                                          url, params ]);
    },
    post : function(url, params, success, fail) {
        cordova.exec(function(response) {
                     console.log("response: " + response);
                     if (success)
                     success(response);
                     }, (fail ? fail : null), 'org.apache.cordova.weibo.Connect', 'post', [
                                                                                           url, params ]);
    },
    upload : function(url, params, file, success, fail) {
        console.log("file: " + file);
        cordova.exec(function(response) {
                     console.log("response: " + response);
                     if (success)
                     success(response);
                     }, (fail ? fail : null), 'org.apache.cordova.weibo.Connect', 'upload', [
                                                                                             url, params, file ]);
    }
};

sina.weibo=CDV.WB;