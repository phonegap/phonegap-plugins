/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2005-2011, Nitobi Software Inc.
 * Copyright (c) 2010-2011, IBM Corporation
 */
package com.phonegap.plugins.childBrowser;

import java.io.IOException;
import java.io.InputStream;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.WindowManager.LayoutParams;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.LinearLayout;

import com.phonegap.api.PhonegapActivity;
import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

public class ChildBrowser extends Plugin {
    
    protected static final String LOG_TAG = "ChildBrowser";
    private static int CLOSE_EVENT = 0;
    private static int LOCATION_CHANGED_EVENT = 1;

    private String browserCallbackId = null;

    private Dialog dialog;
    private WebView webview;
    private boolean showLocationBar = true;

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action        The action to execute.
     * @param args          JSONArry of arguments for the plugin.
     * @param callbackId    The callback id used when calling back into JavaScript.
     * @return              A PluginResult object with a status and message.
     */
    public PluginResult execute(String action, JSONArray args, String callbackId) {
        PluginResult.Status status = PluginResult.Status.OK;
        String result = "";

        try {
            if (action.equals("showWebPage")) {
                this.browserCallbackId = callbackId;
                
                result = this.showWebPage(args.getString(0), args.optJSONObject(1));
                
                if (result.length() > 0) {
                    status = PluginResult.Status.ERROR;
                    return new PluginResult(status, result);
                } else {
                    PluginResult pluginResult = new PluginResult(status, result);
                    pluginResult.setKeepCallback(true);
                    return pluginResult;
                }
            }
            else if (action.equals("close")) {
                closeDialog();
                
                JSONObject obj = new JSONObject();
                obj.put("type", CLOSE_EVENT);
                
                PluginResult pluginResult = new PluginResult(status, obj);
                pluginResult.setKeepCallback(false);
                return pluginResult;
            }
            else if (action.equals("openExternal")) {
                result = this.openExternal(args.getString(0), args.optBoolean(1));
                if (result.length() > 0) {
                    status = PluginResult.Status.ERROR;
                }
            }
            else {
                status = PluginResult.Status.INVALID_ACTION;
            }
            return new PluginResult(status, result);
        } catch (JSONException e) {
            return new PluginResult(PluginResult.Status.JSON_EXCEPTION);
        }
    }

    /**
     * Display a new browser with the specified URL.
     *
     * @param url           The url to load.
     * @param usePhoneGap   Load url in PhoneGap webview
     * @return              "" if ok, or error message.
     */
    public String openExternal(String url, boolean usePhoneGap) {
        try {
            Intent intent = null;
            if (usePhoneGap) {
                intent = new Intent().setClass(this.ctx, com.phonegap.DroidGap.class);
                intent.setData(Uri.parse(url)); // This line will be removed in future.
                intent.putExtra("url", url);

                // Timeout parameter: 60 sec max - May be less if http device timeout is less.
                intent.putExtra("loadUrlTimeoutValue", 60000);

                // These parameters can be configured if you want to show the loading dialog
                intent.putExtra("loadingDialog", "Wait,Loading web page...");   // show loading dialog
                intent.putExtra("hideLoadingDialogOnPageLoad", true);           // hide it once page has completely loaded
            }
            else {
                intent = new Intent(Intent.ACTION_VIEW);
                intent.setData(Uri.parse(url));
            }
            this.ctx.startActivity(intent);
            return "";
        } catch (android.content.ActivityNotFoundException e) {
            System.out.println("ChildBrowser: Error loading url "+url+":"+ e.toString());
            return e.toString();
        }
    }

    /**
     * Closes the dialog
     */
    private void closeDialog() {
        if (dialog != null) {
            dialog.dismiss();
        }
    }

    /**
     * Checks to see if it is possible to go back one page in history, then does so.
     */
    private void goBack() {
        if (this.webview.canGoBack()) {
            this.webview.goBack();
        }
    }

    /**
     * Checks to see if it is possible to go forward one page in history, then does so.
     */
    private void goForward() {
        if (this.webview.canGoForward()) {
            this.webview.goForward();
        }
    }

    /**
     * Navigate to the new page
     * 
     * @param url to load
     */
    private void navigate(String url) {
        if (!url.startsWith("http")) {
            this.webview.loadUrl("http://" + url);            
        }
        this.webview.loadUrl(url);
    }


    /**
     * Should we show the location bar?
     * 
     * @return boolean
     */
    private boolean getShowLocationBar() {
        return this.showLocationBar;
    }

    /**
     * Display a new browser with the specified URL.
     *
     * @param url           The url to load.
     * @param jsonObject 
     */
    public String showWebPage(final String url, JSONObject options) {
        // Determine if we should hide the location bar.
        if (options != null) {
            showLocationBar = options.optBoolean("showLocationBar", true);
        }
        
        // Create dialog in new thread 
        Runnable runnable = new Runnable() {
            public void run() {
                dialog = new Dialog(ctx);

                dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
                dialog.setCancelable(true);
                dialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
                        public void onDismiss(DialogInterface dialog) {
                            try {
                                JSONObject obj = new JSONObject();
                                obj.put("type", CLOSE_EVENT);
                                
                                sendUpdate(obj, false);
                            } catch (JSONException e) {
                                Log.d(LOG_TAG, "Should never happen");
                            }
                        }
                });

                LinearLayout.LayoutParams backParams = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT);
                LinearLayout.LayoutParams forwardParams = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT);
                LinearLayout.LayoutParams editParams = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT, 1.0f);
                LinearLayout.LayoutParams closeParams = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT);
                LinearLayout.LayoutParams wvParams = new LinearLayout.LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT);
                
                LinearLayout main = new LinearLayout(ctx);
                main.setOrientation(LinearLayout.VERTICAL);
                
                LinearLayout toolbar = new LinearLayout(ctx);
                toolbar.setOrientation(LinearLayout.HORIZONTAL);
                
                ImageButton back = new ImageButton(ctx);
                back.setOnClickListener(new View.OnClickListener() {
                    public void onClick(View v) {
                        goBack();
                    }
                });
                back.setId(1);
                try {
                    back.setImageBitmap(loadDrawable("www/childbrowser/icon_arrow_left.png"));
                } catch (IOException e) {
                    Log.e(LOG_TAG, e.getMessage(), e);
                }
                back.setLayoutParams(backParams);

                ImageButton forward = new ImageButton(ctx);
                forward.setOnClickListener(new View.OnClickListener() {
                    public void onClick(View v) {
                        goForward();
                    }
                });
                forward.setId(2);
                try {
                    forward.setImageBitmap(loadDrawable("www/childbrowser/icon_arrow_right.png"));
                } catch (IOException e) {
                    Log.e(LOG_TAG, e.getMessage(), e);
                }               
                forward.setLayoutParams(forwardParams);
                
                final EditText edittext = new EditText(ctx);
                edittext.setOnKeyListener(new View.OnKeyListener() {
                    public boolean onKey(View v, int keyCode, KeyEvent event) {
                        // If the event is a key-down event on the "enter" button
                        if ((event.getAction() == KeyEvent.ACTION_DOWN) && (keyCode == KeyEvent.KEYCODE_ENTER)) {
                          navigate(edittext.getText().toString());
                          return true;
                        }
                        return false;
                    }
                });
                edittext.setId(3);
                edittext.setSingleLine(true);
                edittext.setText(url);
                edittext.setLayoutParams(editParams);
                    
                ImageButton close = new ImageButton(ctx);                
                close.setOnClickListener(new View.OnClickListener() {
                    public void onClick(View v) {
                        closeDialog();
                    }
                });
                close.setId(4);
                try {
                    close.setImageBitmap(loadDrawable("www/childbrowser/icon_close.png"));
                } catch (IOException e) {
                    Log.e(LOG_TAG, e.getMessage(), e);
                }
                close.setLayoutParams(closeParams);
                                
                webview = new WebView(ctx);
                webview.getSettings().setJavaScriptEnabled(true);
                WebViewClient client = new ChildBrowserClient(ctx, edittext);
                webview.setWebViewClient(client);                
                webview.loadUrl(url);
                webview.setId(5);
                webview.setLayoutParams(wvParams);
                
                toolbar.addView(back);
                toolbar.addView(forward);
                toolbar.addView(edittext);
                toolbar.addView(close);
                
                if (getShowLocationBar()) {
                    main.addView(toolbar);
                }
                main.addView(webview);

                WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
                lp.copyFrom(dialog.getWindow().getAttributes());
                lp.width = WindowManager.LayoutParams.FILL_PARENT;
                lp.height = WindowManager.LayoutParams.FILL_PARENT;
                
                dialog.setContentView(main);
                dialog.show();
                dialog.getWindow().setAttributes(lp);
            }
            
            private Bitmap loadDrawable(String filename) throws java.io.IOException {
                InputStream input = ctx.getAssets().open(filename);    
                return BitmapFactory.decodeStream(input);
            }
        };
        this.ctx.runOnUiThread(runnable);
        return "";
    }
    
    /**
     * Create a new plugin result and send it back to JavaScript
     * 
     * @param obj a JSONObject contain event payload information
     */
    private void sendUpdate(JSONObject obj, boolean keepCallback) {
        if (this.browserCallbackId != null) {
            PluginResult result = new PluginResult(PluginResult.Status.OK, obj);
            result.setKeepCallback(keepCallback);
            this.success(result, this.browserCallbackId);
        }
    }

    /**
     * The webview client receives notifications about appView
     */
    public class ChildBrowserClient extends WebViewClient {
        PhonegapActivity ctx;
        EditText edittext;

        /**
         * Constructor.
         * 
         * @param mContext
         * @param edittext 
         */
        public ChildBrowserClient(PhonegapActivity mContext, EditText mEditText) {
            this.ctx = mContext;
            this.edittext = mEditText;
        }       

        /**
         * Notify the host application that a page has started loading.
         * 
         * @param view          The webview initiating the callback.
         * @param url           The url of the page.
         */
        @Override
        public void onPageStarted(WebView view, String url,  Bitmap favicon) {
            super.onPageStarted(view, url, favicon);            
            String newloc;
            if (url.startsWith("http")) {
                newloc = url;
            } else {
                newloc = "http://" + url;
            }
            
            if (!newloc.equals(edittext.getText().toString())) {           
                edittext.setText(newloc);
            }
            
            try {
                JSONObject obj = new JSONObject();
                obj.put("type", LOCATION_CHANGED_EVENT);
                obj.put("location", url);
                
                sendUpdate(obj, true);
            } catch (JSONException e) {
                Log.d("ChildBrowser", "This should never happen");
            }
        }
    }
}
