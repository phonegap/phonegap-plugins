/**
 * Clipboard plugin for cordova
 *
 * @constructor
 */
function ClipboardPlugin(){ }

/**
 * Set the clipboard text
 *
 * @param {String} text The new clipboard content
 */
ClipboardPlugin.prototype.setText = function(text) {
    cordova.exec("ClipboardPlugin.setText", text);
}

/**
 * Get the clipboard text
 *
 * @param {String} text The new clipboard content
 */
ClipboardPlugin.prototype.getText = function(callback) {
    cordova.exec(callback, null, "ClipboardPlugin", "getText", []);
}

/**
 * Register the plugin with cordova
 */
cordova.addConstructor(function() {
    if(!window.plugins) window.plugins = {};
    window.plugins.clipboardPlugin = new ClipboardPlugin();
});