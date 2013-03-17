var Macaddress = function(){}

Macaddress.prototype = {
    getMacAddress : function(onSuccess,onError) {
        cordova.exec(onSuccess, onError, 'Macaddress', 'getMacAddress', []);
    },

};

Macaddress.install = function(){
    if(!window.plugins){
        window.plugins = {};
    }
    
    window.plugins.macaddress = new Macaddress();
    return window.plugins.macaddress;
};

cordova.addConstructor(Macaddress.install);
