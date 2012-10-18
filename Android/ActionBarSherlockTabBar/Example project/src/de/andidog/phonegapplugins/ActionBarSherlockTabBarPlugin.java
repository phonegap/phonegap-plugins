package de.andidog.phonegapplugins;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;

import android.support.v4.app.FragmentTransaction;
import android.util.Log;

import com.actionbarsherlock.ActionBarSherlock;
import com.actionbarsherlock.app.ActionBar;
import com.actionbarsherlock.app.ActionBar.Tab;

/**
 * Acts like a bridge between the ActionBarSherlock tab bar implementation and the WebView. The code in the WebView can
 * install a callback function that is called when the tab selection changes.
 */
public class ActionBarSherlockTabBarPlugin extends Plugin implements ActionBar.TabListener
{
    public interface OnInitListener
    {
        void onActionBarSherlockTabBarPluginInitialized();
    }

    private static final String TAG = "ActionBarSherlockTabBarPlugin";

    public String callback;
    private static OnInitListener onInitListener;

    // https://issues.apache.org/jira/browse/CB-1062
    public static ActionBarSherlockTabBarPlugin instance;

    protected ActionBarSherlock sherlock;

    public ActionBarSherlockTabBarPlugin()
    {
        instance = this;
    }

    /**
     * Adds a tab to the tab bar implemented with ActionBarSherlock
     *
     * Use this from your main activity, it cannot be called from JavaScript code because you may want to reference
     * resources (e.g. tab icons of R.drawable).
     *
     * @param tabTag
     * @param text Resource ID for translated text label of the tab.
     * @param icon Resource ID for a tab icon. Can be NULL, but either text or icon must be given.
     */
    public void addTab(String tabTag, int textResourceId, Integer iconResourceId)
    {
        addTab(tabTag, null, textResourceId, iconResourceId);
    }

    /**
     * Adds a tab to the tab bar implemented with ActionBarSherlock
     *
     * Use this from your main activity, it cannot be called from JavaScript code because you may want to reference
     * resources (e.g. tab icons of R.drawable).
     *
     * @param tabTag
     * @param text Text label of the tab. Can be NULL, but either text or icon must be given.
     * @param icon Resource ID for a tab icon. Can be NULL, but either text or icon must be given.
     */
    public void addTab(String tabTag, String text, Integer iconResourceId)
    {
        addTab(tabTag, text, null, iconResourceId);
    }

    protected void addTab(String tabTag, String text, Integer textResourceId, Integer iconResourceId)
    {
        if(sherlock == null)
            throw new IllegalArgumentException("Must call setSherlock first");
        if(tabTag == null)
            throw new IllegalArgumentException("tabTag may not be NULL");
        if((text == null && textResourceId == null) == (iconResourceId == null))
            throw new IllegalArgumentException("Either text or icon must be set for a tab (not both)");

        final ActionBar actionBar = sherlock.getActionBar();

        Tab tab = actionBar.newTab();

        if(text != null)
            tab.setText(text);
        else if(textResourceId != null)
            tab.setText(textResourceId);
        else if(iconResourceId != null)
            tab.setIcon(iconResourceId);

        tab.setTag(tabTag);
        tab.setTabListener(this);

        actionBar.addTab(tab);
    }

    public PluginResult execute(String action, JSONArray args, String callbackId)
    {
        if(action.equals("setTabSelectedListener"))
        {
            this.callback = callbackId;

            if(args.length() != 0)
                throw new AssertionError("setTabSelectedListener takes no arguments");

            PluginResult res = new PluginResult(PluginResult.Status.NO_RESULT);
            res.setKeepCallback(true);
            return res;
        }
        else if(action.equals("_init"))
        {
            // This is the signal send from the JavaScript that forces construction of this plugin
            if(onInitListener != null)
            {
                onInitListener.onActionBarSherlockTabBarPluginInitialized();
                onInitListener = null;
            }

            return new PluginResult(PluginResult.Status.NO_RESULT);
        }
        else
        {
            Log.e(TAG, "Invalid call: " + action);
            return new PluginResult(PluginResult.Status.INVALID_ACTION);
        }
    }

    @Override
    public void onTabReselected(Tab tab, FragmentTransaction ft)
    {
        Log.d(TAG, "Tab " + tab.getTag() + " reselected");
    }

    @Override
    public void onTabSelected(Tab tab, FragmentTransaction ft)
    {
        triggerTabSelectedEvent((String)tab.getTag());

        Log.d(TAG, "Tab " + tab.getTag() + " selected");
    }

    @Override
    public void onTabUnselected(Tab tab, FragmentTransaction ft)
    {
        Log.d(TAG, "Tab " + tab.getTag() + " unselected");
    }

    /**
     * Sets the activity that is enhanced with a tab bar
     *
     * This method must be run on the UI thread!
     */
    public void setSherlock(ActionBarSherlock sherlock)
    {
        if(this.sherlock != null && this.sherlock != sherlock)
            throw new IllegalStateException("May only set ActionBarSherlock instance of tab bar once");

        this.sherlock = sherlock;

        final ActionBar actionBar = sherlock.getActionBar();

        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
        actionBar.setDisplayShowHomeEnabled(false);
        actionBar.setDisplayShowTitleEnabled(false);
    }

    // What you won't do to hack PhoneGap's plugin initialization order...
    public static void setOnInitListener(OnInitListener listener)
    {
        onInitListener = listener;

        // Trigger immediately if already loaded (probably won't happen)
        if(instance != null)
        {
            onInitListener.onActionBarSherlockTabBarPluginInitialized();
            onInitListener = null;
        }
    }

    public void triggerTabSelectedEvent(String tabTag)
    {
        PluginResult res = new PluginResult(PluginResult.Status.OK, tabTag);
        res.setKeepCallback(true);
        this.success(res, callback);
    }
}
