Navigation bar for Cordova on iOS
=================================

This plugin lets you create and control a native navigation bar and its buttons.

License
-------

[MIT license](http://www.opensource.org/licenses/mit-license.html)

Contributors
------------

This plugin was put together from the incomplete NativeControls plugin and other sources. See NavigationBar.m for the history.

Installing the plugin
---------------------

- Copy *.xib, *.m and *.h files to your project's "Plugins" folder (should already exist and contain a README file if you used the Cordova project template)
- They have to be added to the project as well, so drag them from the "Plugins" folder (in Finder) to the same folder (in Xcode) and select to create references
- Open "Supporting Files/Cordova.plist" and under "Plugins", add a key with the plugin name "NavigationBar" and a string value of "NavigationBar" (I guess it's the plugin's main class name)

Note regarding orientation changes and the tab bar plugin
---------------------------------------------------------

If the tab bar plugin is used together with this plugin and the tab bar is positioned on top (defaults to bottom), it's necessary to resize the navigation bar automatically:

    window.addEventListener("resize", function() {
        plugins.navigationBar.resize();
    ), false);

Using the tab bar and navigation bar plugin together
----------------------------------------------------

In order to use the [tab bar plugin](https://github.com/AndiDog/phonegap-plugins/tree/master/iOS/TabBar) and [navigation bar plugin](https://github.com/AndiDog/phonegap-plugins/tree/master/iOS/NavigationBar) together, you must initialize both plugins before calling any of their methods, i.e. before creating a navigation/tab bar. For example right when your application starts:

    document.addEventListener("deviceready", function() {
        console.log("Cordova ready")

        plugins.navigationBar.init()
        plugins.tabBar.init()

        plugins.navigationBar.create()
        plugins.tabBar.create()

        // ...

This is because both plugins are aware of each other and resize Cordova's web view accordingly, but therefore they have to know the web view's initial dimensions. If for example you only initialize the tab bar plugin, create the tab bar and later decide to also create a navigation bar, the navigation bar plugin would think the original web view size is 320x411 instead of 320x460 (on iPhone). Layouting *could* be done using the screen size as well but it's currently implemented like this.

Example
-------

This example shows how to use the navigation bar:

    document.addEventListener("deviceready", function() {
        console.log("Cordova ready")

        plugins.navigationBar.init()

        plugins.navigationBar.create() // or .create("BlackOpaque") to apply a certain style
        plugins.navigationBar.hideLeftButton()
        plugins.navigationBar.hideRightButton()

        plugins.navigationBar.setTitle("My heading")

        plugins.navigationBar.showLeftButton()
        plugins.navigationBar.showRightButton()

        // Create left navigation button with a title (you can either have a title or an image, not both!)
        plugins.navigationBar.setupLeftButton("Text", null, function() {
            alert("left nav button tapped")
        })

        // Create right navigation button from a system-predefined button (see the full list in NativeControls.m)
        // or from an image
        plugins.navigationBar.setupRightButton(
            null,
            "barButton:Bookmarks", // or your own file like "/www/stylesheets/images/ajax-loader.png",
            function() {
                alert("right nav button tapped")
            }
        )

        plugins.navigationBar.show()
    }, false)

Reporting issues or requests for improvement
--------------------------------------------

Please report problems on [my GitHub fork of phonegap-plugins](https://github.com/AndiDog/phonegap-plugins).