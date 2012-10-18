Tab bar for Cordova on iOS
==========================

This plugin lets you create and control a native tab bar.

License
-------

[MIT license](http://www.opensource.org/licenses/mit-license.html)

Contributors
------------

See TabBar.m for the history.

Installing the plugin
---------------------

- Copy *.m and *.h files to your project's "Plugins" folder (should already exist and contain a README file if you used the Cordova project template)
- They have to be added to the project as well, so drag them from the "Plugins" folder (in Finder) to the same folder (in Xcode) and select to create references
- Open "Resources/Cordova.plist" and under "Plugins", add a key with the plugin name "TabBar" and a string value of "TabBar"

Note regarding the tab bar
--------------------------

Don't forget to add an event handler for orientation changes as follows:

    window.addEventListener("resize", function() {
        plugins.tabBar.resize();
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

This example shows how to use the tab bar:

    document.addEventListener("deviceready", function() {
        console.log("PhoneGap ready")

        plugins.tabBar.init()

        plugins.tabBar.create()
        // or with an orange tint:
        plugins.tabBar.create({selectedImageTintColorRgba: '255,40,0,255'})

        plugins.tabBar.createItem("contacts", "Unused, iOS replaces this text by Contacts", "tabButton:Contacts")
        plugins.tabBar.createItem("recents", "Unused, iOS replaces this text by Recents", "tabButton:Recents")

        // Example with selection callback
        plugins.tabBar.createItem("another", "Some text", "/www/your-own-image.png", {
            onSelect: function() {
                alert("another tab selected")
            }
        })

        plugins.tabBar.show()
        // Or with custom style (defaults to 49px height, positioned at bottom): plugins.tabBar.show({height: 80, position: 'top'})
        plugins.tabBar.showItems("contacts", "recents", "another")

        window.addEventListener("resize", function() { plugins.tabBar.resize() }, false)
    }, false)

Retina images
-------------

You can also have different images for the normal and retina quality like "image.png" and "image@2x.png". The code to assign the image would be:

    plugins.tabBar.createItem("home", "Home", "image.png", {
        onSelect: function() {
            alert("tab selected")
        }
    })

Reporting issues or requests for improvement
--------------------------------------------

Please report problems on [my GitHub fork of phonegap-plugins](https://github.com/AndiDog/phonegap-plugins).