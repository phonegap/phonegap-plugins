

(function () {

    function checkArgs(win,fail) {
        if(win && typeof win === "function" && fail && typeof fail === "function") {
            return true;
        }
        else {
            console.log("LiveTiles Error: successCallback || errorCallback is not a function");
            return false;
        }
    }

    var cdv = window.cordova || window.Cordova;
        navigator.plugins.liveTiles = {
            updateAppTile: function (successCallback, errorCallback, options) {
                if(checkArgs(successCallback, errorCallback)) {
                    cdv.exec(successCallback, errorCallback, "LiveTiles", "updateAppTile", [options]);
                }
            },

            createSecondaryTile: function (successCallback, errorCallback, options) {
                if(checkArgs(successCallback, errorCallback)) {
                    cdv.exec(successCallback, errorCallback, "LiveTiles", "createSecondaryTile", [options]);
                }
            },

            updateSecondaryTile: function (successCallback, errorCallback, options) {
                if(checkArgs(successCallback, errorCallback)) {
                    cdv.exec(successCallback, errorCallback, "LiveTiles", "updateSecondaryTile", [options]);
                }
            },

            deleteSecondaryTile: function (successCallback, errorCallback, options) {
                if(checkArgs(successCallback, errorCallback)) {
                    cdv.exec(successCallback, errorCallback, "LiveTiles", "deleteSecondaryTile", [options]);
                }
            }

        };

})();
