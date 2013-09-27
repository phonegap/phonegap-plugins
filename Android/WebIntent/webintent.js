/**
 * cordova Web Intent plugin
 * Copyright (c) Boris Smus 2010
 *
 * Updated to PhoneGap 3.0.0 compatibility 
 * Copyright (c) Avi Vaisenberger 2013
 */
CDV = ( typeof CDV == 'undefined' ? {} : CDV );
var cordova = window.cordova || window.Cordova;

CDV.WEBINTENT = {
    ACTION_SEND : "android.intent.action.SEND",
    ACTION_VIEW : "android.intent.action.VIEW",
    EXTRA_TEXT : "android.intent.extra.TEXT",
    EXTRA_SUBJECT : "android.intent.extra.SUBJECT",
    EXTRA_STREAM : "android.intent.extra.STREAM",
    EXTRA_EMAIL : "android.intent.extra.EMAIL",

    startActivity : function(params, success, fail) {
        return cordova.exec(function(args) {
            success(args);
        }, function(args) {
            fail(args);
        }, 'WebIntent', 'startActivity', [params]);
    },

    hasExtra : function(params, success, fail) {
        return cordova.exec(function(args) {
            success(args);
        }, function(args) {
            fail(args);
        }, 'WebIntent', 'hasExtra', [params]);
    },

    getUri : function(success, fail) {
        return cordova.exec(function(args) {
            success(args);
        }, function(args) {
            fail(args);
        }, 'WebIntent', 'getUri', []);
    },

    getExtra : function(params, success, fail) {
        return cordova.exec(function(args) {
            success(args);
        }, function(args) {
            fail(args);
        }, 'WebIntent', 'getExtra', [params]);
    },

    onNewIntent : function(callback) {
        return cordova.exec(function(args) {
            callback(args);
        }, function(args) {
        }, 'WebIntent', 'onNewIntent', []);
    },

    sendBroadcast : function(params, success, fail) {
        return cordova.exec(function(args) {
            success(args);
        }, function(args) {
            fail(args);
        }, 'WebIntent', 'sendBroadcast', [params]);
    }
}