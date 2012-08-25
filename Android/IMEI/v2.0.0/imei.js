var IMEI = function(){};

IMEI.prototype.get = function(onSuccess, onFail){
    return cordova.exec(onSuccess, onFail, 'IMEI', 'get', []);
};

if(!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.imei) {
    window.plugins.imei = new IMEI();
}