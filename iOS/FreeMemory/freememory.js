window.freeMemory = function(callback) {
    cordova.exec(callback, function(err) {
                 callback('Could not get Free Memory.');
         }, "FreeMemory", "getFreeMemory", []);
};