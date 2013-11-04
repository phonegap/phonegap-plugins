if(!window.plugins.appLinker){
    
    var AppLinker = function() {}

    AppLinker.prototype.linkApp = function(packageName, sucess, fail) {
        return cordova.exec(
                function (args) { if(success !== undefined) { success(args); } }, 
                function (args) { if(fail !== undefined) { fail(args); } },
                'AppLinker', '', [packageName]);
    };

    cordova.addConstructor(function() {
        if(!window.plugins){ window.plugins = {}; }
        window.plugins.appLinker = new AppLinker();
    });
}