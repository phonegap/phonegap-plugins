var IMEI = function(){};

IMEI.prototype.get = function(onSuccess, onFail){
    return PhoneGap.exec(onSuccess, onFail, 'IMEI', 'get', []);
};

PhoneGap.addConstructor(function(){
    PhoneGap.addPlugin('imei', new IMEI());
});