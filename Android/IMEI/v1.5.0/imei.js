var IMEI = function(){};

IMEI.prototype.get = function(onSuccess, onFail){
    return cordova.exec(onSuccess, onFail, 'IMEI', 'get', []);
};

cordova.addConstructor(function(){
    cordova.addPlugin('imei', new IMEI());
});