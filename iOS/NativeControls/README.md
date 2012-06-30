Native controls for Cordova on iOS
==================================

This includes a tab bar, navigation bar and action sheet implementation.

License
-------

MIT license.

Contributors
------------

See NativeControls.m for the history.

Installing the plugin
---------------------

- Copy *.xib, *.m and *.h files to your project's "Plugins" folder (should already exist and contain a README file if you used the Cordova project template)
- They have to be added to the project as well, so drag them from the "Plugins" folder (in Finder) to the same folder (in Xcode) and select to create references
- Open "Supporting Files/Cordova.plist" and under "Plugins", add a key with the plugin name "NativeControls" and a string value of "NativeControls" (I guess it's the plugin's main class name)

Note regarding the tab bar
--------------------------

Don't forget to add an event handler for orientation changes as follows:

    window.addEventListener("resize", function() {
        plugins.nativeControls.resizeTabBar();
    ), false);

Example
-------

This example shows how to use the tab and navigation bar:

    document.addEventListener("deviceready", function() {
        console.log("PhoneGap ready")

        plugins.nativeControls.createTabBar()
        plugins.nativeControls.createTabBarItem("contacts", "Unused, iOS replaces this text by Contacts", "tabButton:Contacts")
        plugins.nativeControls.createTabBarItem("recents", "Unused, iOS replaces this text by Recents", "tabButton:Recents")
        plugins.nativeControls.createTabBarItem("another", "Some text", "/www/your-own-image.png")
        plugins.nativeControls.showTabBar()
        plugins.nativeControls.showTabBarItems("contacts", "recents", "another")

        plugins.nativeControls.createNavBar()
        plugins.nativeControls.hideLeftNavButton()
        plugins.nativeControls.hideRightNavButton()

        plugins.nativeControls.setNavBarTitle("My heading")

        plugins.nativeControls.showLeftNavButton()
        plugins.nativeControls.showRightNavButton()

        // Create left navigation button with a title (you can either have a title or an image, not both!)
        plugins.nativeControls.setupLeftNavButton("Text", null, function() {
            alert("left nav button tapped")
        })

        // Create right navigation button from a system-predefined button (see the full list in NativeControls.m)
        // or from an image
        plugins.nativeControls.setupRightNavButton(
            null,
            "barButton:Bookmarks", // or your own file like "/www/stylesheets/images/ajax-loader.png",
            function() {
                alert("right nav button tapped")
            }
        )

        plugins.nativeControls.showNavBar()

        window.addEventListener("resize", function() { plugins.nativeControls.resizeTabBar(); }, false);
    }, false)

Reporting issues or requests for improvement
--------------------------------------------

Please report problems on [my GitHub fork of phonegap-plugins](https://github.com/AndiDog/phonegap-plugins).