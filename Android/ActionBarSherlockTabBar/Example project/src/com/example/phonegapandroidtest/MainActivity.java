package com.example.phonegapandroidtest;

import org.apache.cordova.DroidGap;

import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup.LayoutParams;

import com.actionbarsherlock.ActionBarSherlock;

import de.andidog.phonegapplugins.ActionBarSherlockTabBarPlugin;

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

        super.setIntegerProperty("loadUrlTimeoutValue", 60000);

        // Show splashscreen up to 25 seconds (hidden when application is ready, see JavaScript code)
        super.loadUrl("file:///android_asset/www/index.html", 25000);
    }

    private void createTabs()
    {
        ActionBarSherlockTabBarPlugin.instance.setSherlock(sherlock);

        // You can either provide a text by string literal or resource ID (R.string.something)
        ActionBarSherlockTabBarPlugin.instance.addTab("tab-home", "Home", null);
        ActionBarSherlockTabBarPlugin.instance.addTab("tab-settings", R.string.tab_settings, null);

        // Icons are possible, too, but not together with a text label!
        ActionBarSherlockTabBarPlugin.instance.addTab("tab-search", null, R.drawable.ic_action_search);
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
