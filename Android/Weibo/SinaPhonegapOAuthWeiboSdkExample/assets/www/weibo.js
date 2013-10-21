//  Created by qhm123.
//  Copyright (c) 2012年 SINA SAE. All rights reserved.
//  Under the Apache License 2.0.

if (typeof window.plugins == 'undefined') {
    window.plugins = {};
}

window.plugins.weibo = {
    init: function(params, cb, fail) {
        appKey = params.appKey;
        appSecret = params.appSecret;
        redirectUrl = params.redirectUrl;
        cordova.exec(function(response) {
            console.log('Cordova Weibo Connect plugin initialized successfully.');
            if (cb) cb(response);
        }, (fail ? fail : null), 'Weibo', 'init', [appKey, appSecret, redirectUrl]);
    },
    login: function(cb, fail) {
        cordova.exec(function(response) {
            if (cb) cb(response.access_token, response.expires_in);
        }, (fail ? fail : null), 'Weibo', 'login', []);
    }
};

