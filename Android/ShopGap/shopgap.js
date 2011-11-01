var ShopGap = function(){};

ShopGap.prototype.setup = function(apiKey, password, shopname, onSuccessFn, onFailureFn){
    var args = {'apikey': apiKey, 'password': password, 'shopname': shopname};
    return PhoneGap.exec(onSuccessFn, onFailureFn, 'ShopGapPlugin', 'setup', [args]);
};

ShopGap.prototype.consArgs = function(call, endpoint, query, data){
    return {call: call, endpoint: endpoint, query: query, data: data};
};

ShopGap.prototype.read = function(endpoint, query, data, success, failure){
    return this.callapi(this.consArgs('read', endpoint, query, data), success, failure);
};

ShopGap.prototype.update = function(endpoint, query, data, success, failure){
    return this.callapi(this.consArgs('update', endpoint, query, data), success, failure);
};

ShopGap.prototype.create = function(endpoint, query, data, success, failure){
    return this.callapi(this.consArgs('create', endpoint, query, data), success, failure);
};

ShopGap.prototype.destroy = function(endpoint, query, data, success, failure){
    return this.callapi(this.consArgs('destroy', endpoint, query, data), success, failure);
};

ShopGap.prototype.callapi = function(args, onSuccessFn, onFailureFn){
    return PhoneGap.exec(onSuccessFn, onFailureFn, 'ShopGapPlugin', 'callapi', [args]);
};

/*
ShopGap.prototype.callapi = function(call, endpoint, query, data, onSuccessFn, onFailureFn){
    var args = {'endpoint': endpoint, 'data': data, 'query': query};
    return PhoneGap.exec(onSuccessFn, onFailureFn, 'ShopGapPlugin', 'callapi', [args]);
};
*/

PhoneGap.addConstructor(function(){
    PhoneGap.addPlugin('shopGap', new ShopGap());
});
