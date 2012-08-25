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
    cordova.exec("NavigationBar.create", style || "Default");
};

/**
 * Must be called before any other method in order to initialize the plugin.
 */
NavigationBar.prototype.init = function()
{
    cordova.exec("NavigationBar.init");
};

NavigationBar.prototype.resize = function() {
    cordova.exec("NavigationBar.resize");
};

/**
 * Assign either title or image to the left navigation bar button, and assign the tap callback
*/
NavigationBar.prototype.setupLeftButton = function(title, image, onselect, options)
{
    this.leftButtonCallback = onselect;
    cordova.exec("NavigationBar.setupLeftButton", title || "", image || "", options || {});
};

NavigationBar.prototype.hideLeftButton = function()
{
    cordova.exec("NavigationBar.hideLeftButton");
};

NavigationBar.prototype.showLeftButton = function()
{
    cordova.exec("NavigationBar.showLeftButton");
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
    cordova.exec("NavigationBar.setupRightButton", title || "", image || "", onselect, options || {});
};


NavigationBar.prototype.hideRightButton = function()
{
    cordova.exec("NavigationBar.hideRightButton");
};

NavigationBar.prototype.showRightButton = function()
{
    cordova.exec("NavigationBar.showRightButton");
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
    cordova.exec("NavigationBar.setTitle", title);
};

NavigationBar.prototype.setLogo = function(imageURL)
{
    cordova.exec("NavigationBar.setLogo", imageURL);
};

/**
 * Shows the navigation bar. Make sure you called create() first.
 */
NavigationBar.prototype.show = function() {
    cordova.exec("NavigationBar.show");
};

/**
 * Hides the navigation bar. Make sure you called create() first.
 */
NavigationBar.prototype.hide = function() {

    cordova.exec("NavigationBar.hide");
};

cordova.addConstructor(function()
{
	if(!window.plugins)
	{
		window.plugins = {};
	}
    window.plugins.navigationBar = new NavigationBar();
});
