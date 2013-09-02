/**
 * Clipboard plugin for PhoneGap
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
	Cordova.exec("ClipboardPlugin.setText", text);
}

/**
 * Get the clipboard text
 *
 * @param {String} text The new clipboard content
 */
ClipboardPlugin.prototype.getText = function(callback) {
	Cordova.exec(callback, null, "ClipboardPlugin", "getText", []);
}

/**
 * Register the plugin with PhoneGap
 */
window.clipboardPlugin = new ClipboardPlugin();