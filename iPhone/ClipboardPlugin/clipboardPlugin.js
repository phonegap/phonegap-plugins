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
	PhoneGap.exec("ClipboardPlugin.setText", text);
}

/**
 * Get the clipboard text
 *
 * @param {String} text The new clipboard content
 */
ClipboardPlugin.prototype.getText = function(callback) {
	PhoneGap.exec(callback, null, "ClipboardPlugin", "getText", []);
}

/**
 * Register the plugin with PhoneGap
 */
PhoneGap.addConstructor(function() {
	if(!window.plugins) window.plugins = {};
	window.plugins.clipboardPlugin = new ClipboardPlugin();
});