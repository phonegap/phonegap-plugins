var MSISDN = function(){};

MSISDN.prototype.getSimNumber = function(successCB, errorCB){
	return PhoneGap.exec(successCB, errorCB, 'MSISDN', 'getSimNumber',[this]);
};

PhoneGap.addConstructor(function(){
    if(typeof navigator.msisdn === "undefined") {
        navigator.msisdn = new MSISDN();
        PhoneGap.addPlugin('msisdn', navigator.msisdn);
    }
});