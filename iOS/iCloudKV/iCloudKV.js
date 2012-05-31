// Copyright (c) Alex Drel 2012

var iCloudKV = (function (ckv) {

    var onChange = null;

    ckv.sync = function (success, fail) {
        return cordova.exec(success /*(dictionary_with_all_sync_keys)*/, fail, "iCloudKV", "sync", []);
    };

    ckv.save = function (key, value, success) {
        return cordova.exec(success, null, "iCloudKV", "save", [key, value]);
    };

    ckv.load = function (key, success, fail) {
        return cordova.exec(success /*(value)*/, fail, "iCloudKV", "load", [key]);
    };

    ckv.remove = function (key, success) {
        return cordova.exec(success, null, "iCloudKV", "remove", [key]);
    };

    ckv.monitor = function (notification /*(keys)*/, success) {
        onChange = notification;
        return cordova.exec(success, null, "iCloudKV", "monitor", []);
    };

    ckv.onChange = function (keys) {
        if (onChange)
            onChange(keys);
    };

    return ckv;
})(iCloudKV || {});