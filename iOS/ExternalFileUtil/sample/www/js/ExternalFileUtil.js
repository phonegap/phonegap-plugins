
window.ExternalFileUtil = {
    
    openWith: function ( path, uti, success, fail) {
        return cordova.exec(success, fail, "ExternalFileUtil", "openWith", [path, uti]);
    }  
};
