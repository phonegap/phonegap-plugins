var MSISDN = function(){};

MSISDN.prototype.getSimNumber = function(successCB, errorCB){
            
       if (typeof successCB !== "function") {
                console.log("Error: successCB is not a function");
                return;
       }
       if (errorCB && (typeof errorCB !== "function")) {
                console.log("Error: errorCB is not a function");
                return;
        }
	return PhoneGap.exec(successCB, errorCB, 'MSISDN', 'getSimNumber',[this]);
};

PhoneGap.addConstructor(function(){
    if(typeof navigator.msisdn === "undefined") {
        navigator.msisdn = new MSISDN();
        PhoneGap.addPlugin('msisdn', navigator.msisdn);
    }
});
