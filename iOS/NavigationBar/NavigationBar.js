function NavigationBar() {
    this.leftButtonCallback = null;
    this.rightButtonCallback = null;
}

/**
 * Create a navigation bar.
 *
 * @param style: One of "BlackTransparent", "BlackOpaque", "Black" or "Default". The latter will be used if no style is given.
 */
NavigationBar.prototype.create = function(style)
{
    Cordova.exec("NavigationBar.create", style || "Default");
};

/**
 * Must be called before any other method in order to initialize the plugin.
 */
NavigationBar.prototype.init = function()
{
    Cordova.exec("NavigationBar.init");
};

NavigationBar.prototype.resize = function() {
    Cordova.exec("NavigationBar.resize");
};

/**
 * Assign either title or image to the left navigation bar button, and assign the tap callback
*/
NavigationBar.prototype.setupLeftButton = function(title, image, onselect, options)
{
    this.leftButtonCallback = onselect;
    Cordova.exec("NavigationBar.setupLeftButton", title || "", image || "", options || {});
};

NavigationBar.prototype.hideLeftButton = function()
{
    Cordova.exec("NavigationBar.hideLeftButton");
};

NavigationBar.prototype.showLeftButton = function()
{
    Cordova.exec("NavigationBar.showLeftButton");
};

/**
 * Internal function called by the plugin
 */
NavigationBar.prototype.leftButtonTapped = function()
{
    if(typeof(this.leftButtonCallback) === "function")
        this.leftButtonCallback()
};

/**
 * Assign either title or image to the right navigation bar button, and assign the tap callback
*/
NavigationBar.prototype.setupRightButton = function(title, image, onselect, options)
{
    this.rightButtonCallback = onselect;
    Cordova.exec("NavigationBar.setupRightButton", title || "", image || "", onselect, options || {});
};


NavigationBar.prototype.hideRightButton = function()
{
    Cordova.exec("NavigationBar.hideRightButton");
};

NavigationBar.prototype.showRightButton = function()
{
    Cordova.exec("NavigationBar.showRightButton");
};

/**
 * Internal function called by the plugin
 */
NavigationBar.prototype.rightButtonTapped = function()
{
    if(typeof(this.rightButtonCallback) === "function")
        this.rightButtonCallback()
};

NavigationBar.prototype.setTitle = function(title)
{
    Cordova.exec("NavigationBar.setTitle", title);
};

NavigationBar.prototype.setLogo = function(imageURL)
{
    Cordova.exec("NavigationBar.setLogo", imageURL);
};

/**
 * Shows the navigation bar. Make sure you called create() first.
 */
NavigationBar.prototype.show = function() {
    Cordova.exec("NavigationBar.show");
};

/**
 * Hides the navigation bar. Make sure you called create() first.
 */
NavigationBar.prototype.hide = function() {

    Cordova.exec("NavigationBar.hide");
};

Cordova.addConstructor(function()
{
	if(!window.plugins)
	{
		window.plugins = {};
	}
    window.plugins.navigationBar = new NavigationBar();

});
