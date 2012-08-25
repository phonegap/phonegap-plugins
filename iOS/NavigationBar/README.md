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

How to create a custom button (such as an arrow-shaped back button)
-------------------------------------------------------------------

There are [several ways](http://stackoverflow.com/questions/227078/creating-a-left-arrow-button-like-uinavigationbars-back-style-on-a-uitoolba) to create a back button at runtime without having to use `UINavigationController`, but only one of them seems to be okay if you want your app to be approved: A custom button background image.

![Screenshot](http://i.imgur.com/naC96.png)

The above screenshot has a navigation bar with two such custom buttons. The left one actually has a background image very similar to the black iOS navigation bar. A stretchable picture (such as [this](http://imgur.com/yibWD) or [that one](http://imgur.com/K2LUS) which were used above) should be used because the plugin automatically sets the button size according to the text size (but not smaller than the original picture). You can define left/right margins which shall not be stretched if the button width changes. Important: iOS 5.0 supports defining two different values for the left/right margins. In earlier iOS versions, the plugins takes the larger value (13 pixels in the example below), so please test if your background image looks fine with older versions (install and use the iPhone 4.3 simulator, for example).

Note: Vertical margins are supported by iOS but not implemented in the plugin – tell me if you would like that feature. I think you should keep navigation bar buttons at a fixed height (30px on normal 320x480 iPhone display).

Put the button image in the "Resources" folder of your project. Here's some example code on how to use it:

    plugins.navigationBar.setupLeftButton(
        "Baaack",
        "blackbutton.png",
        function() {
          alert('leftnavbutton tapped')
        },
        {
          useImageAsBackground: true
          fixedMarginLeft: 13 // 13 pixels on the left side are not stretched (the left-arrow shape)
          fixedMarginRight: 5 // and 5 pixels on the right side (all room between these margins is used for the text label)
        }
    )

    plugins.navigationBar.setupRightButton(
        null, // with a custom background image, it's possible to set no title at all
        "greenbutton.png",
        function() {
          alert('rightnavbutton tapped')
        },
        {
          useImageAsBackground: true
          fixedMarginLeft: 5
          fixedMarginRight: 13
        }
    )

Reporting issues or requests for improvement
--------------------------------------------

Please report problems on [my GitHub fork of phonegap-plugins](https://github.com/AndiDog/phonegap-plugins).