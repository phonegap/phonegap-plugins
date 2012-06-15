var LowLatencyAudio = {
  
preloadFX: function ( id, assetPath, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "preloadFX", [id, assetPath]);
},    
    
preloadAudio: function ( id, assetPath, voices, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "preloadAudio", [id, assetPath, voices]);
},
    
getVolume: function (id, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "getVolume", [id]);
},

setVolume: function (id, volume, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "setVolume", [id, volume]);
},

play: function (id, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "play", [id]);
},
    
stop: function (id, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "stop", [id]);
},
    
loop: function (id, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "loop", [id]);
},
    
unload: function (id, success, fail) {
    return cordova.exec(success, fail, "LowLatencyAudio", "unload", [id]);
}
    
    
};
