Tab bar for Cordova on Android
==============================

![Example screenshot](https://raw.github.com/AndiDog/phonegap-plugins/master/Android/ActionBarSherlockTabBar/Example screenshot.png)

License
-------

Plugin code is licensed under the [MIT license](http://www.opensource.org/licenses/mit-license.html), [ActionBarSherlock](http://actionbarsherlock.com/) under the Apache License 2.0.

Features
--------

- Compatible with Cordova 2.1.0 (older versions not tested)
- Should work on Android versions down to 2.1 (SDK version 7)
- You can register a callback function that is triggered when the selected tab changes
- Only tabs implemented (with text or icon), no other features of ActionBarSherlock
- Can show/hide tab bar at runtime
- If a tab is reselected, you won't be notified (*TODO*)
- Tab creation only from Java code, not from JavaScript (*TODO*)

Setup
-----

- Download ActionBarSherlock and add the `library` folder as Android library project (see ActionBarSherlock
  documentation)
- Reference the library project in your own Android project and make sure both compile
  - They must have the same Android support library JAR file, if any (same file checksum)
  - You may have to change the compiler settings to use Java 1.6 (right-click project, Properties > Java Compiler)
- Copy `ActionBarSherlockTabBar.js` from `assets/www` to the appropriate location in your project (e.g. `assets/www`)
- Copy the `src` folder to your project
- Refresh your Android project (click on project name and press F5)

Now change your main activity (the one deriving from DroidGap) like this:

    public class MainActivity extends DroidGap implements ActionBarSherlockTabBarPlugin.OnInitListener
    {
        private ActionBarSherlock sherlock = ActionBarSherlock.wrap(this);

        @Override
        public void onCreate(Bundle savedInstanceState)
        {
            // Show the title bar, or else the ActionBar will be null on Android 4.x
            super.setBooleanProperty("showTitle", true);

            super.onCreate(savedInstanceState);

            ActionBarSherlockTabBarPlugin.setOnInitListener(this);

            // The following two lines have nothing to do with the plugin, just good practice in my opinion:

            super.setIntegerProperty("loadUrlTimeoutValue", 60000);

            // Show splashscreen up to 25 seconds (hidden when application is ready, see JavaScript code)
            super.loadUrl("file:///android_asset/www/index.html", 25000);
        }

        private void createTabs()
        {
            ActionBarSherlockTabBarPlugin.instance.setSherlock(sherlock);

            // You can either provide a text by string literal or resource ID (R.string.something).
            ActionBarSherlockTabBarPlugin.instance.addTab("tab-home", "Home", null);
            ActionBarSherlockTabBarPlugin.instance.addTab("tab-settings", R.string.tab_settings, null);
        }

        @Override
        public void onActionBarSherlockTabBarPluginInitialized()
        {
            // Now it's safe to access ActionBarSherlockTabBarPlugin.instance because the plugin was instantiated
            runOnUiThread(new Runnable() {
                @Override
                public void run()
                {
                    createTabs();
                }
            });
        }

        // All setContentView methods are overridden because ActionBarSherlock has to modify the view
        @Override
        public void setContentView(int layoutResID)
        {
            // Don't call super!
            sherlock.setContentView(layoutResID);
        }

        @Override
        public void setContentView(View view)
        {
            // Don't call super!
            sherlock.setContentView(view);
        }

        @Override
        public void setContentView(View view, LayoutParams params)
        {
            // Don't call super!
            sherlock.setContentView(view, params);
        }
    }

Set a compatible theme for the activity in `AndroidManifest.xml`. Predefined themes are `Theme.Sherlock`,
`Theme.Sherlock.Light` and `Theme.Sherlock.Light.DarkActionBar`. You can define your own with [Android Action Bar Style
Generator](http://jgilfelt.github.com/android-actionbarstylegenerator/). Note that the predefined ones must be prefixed
like `@style/Theme.Sherlock`.

As last step, register the plugin in your `config.xml`:

    <plugin name="ActionBarSherlockTabBar" value="de.andidog.phonegapplugins.ActionBarSherlockTabBarPlugin" />

Usage
-----

Use the plugin like so:

    <script type="text/javascript" src="ActionBarSherlockTabBar.js"></script>
    <script type="text/javascript">
        document.addEventListener('deviceready', function() {
            actionBarSherlockTabBar = cordova.require('cordova/plugin/actionBarSherlockTabBar')

            actionBarSherlockTabBar.setTabSelectedListener(function(tabTag) {
                console.log('Tab ' + tabTag + ' selected')
            })

            // Tab bar is shown by default, but you can change that at runtime
            // actionBarSherlockTabBar.hide()
            // actionBarSherlockTabBar.show()
        }
    </script>

See also the example project in the repository (note: you have to download and reference ActionBarSherlock yourself).