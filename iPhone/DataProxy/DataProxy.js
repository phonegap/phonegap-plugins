function DataProxy(){
}

DataProxy.prototype.getData = function(url, ua, successCB, errorCB){
    PhoneGap.exec("DataProxy.getData", {url:url, ua:ua}, GetFunctionName(successCB), GetFunctionName(errorCB));
};

PhoneGap.addConstructor(function(){
    if(!window.plugins){
        window.plugins = {};
    }

    window.plugins.dataProxy = new DataProxy();
});
