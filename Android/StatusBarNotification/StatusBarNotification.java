/*
 *
 * Copyright (C) 2011 Dmitry Savchenko <dg.freak@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 */

package com.phonegap.plugins.statusBarNotification;

import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class StatusBarNotification extends CordovaPlugin {
    //	Action to execute
    public static final String NOTIFY = "notify";
    public static final String CLEAR = "clear";

    /**
     * 	Executes the request and returns PluginResult
     *
     * 	@param action		Action to execute
     * 	@param data			JSONArray of arguments to the plugin
     *  @param callbackContext	The callback context used when calling back into JavaScript.
     *
     *  @return				A PluginRequest object with a status
     * */
    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) {
        boolean actionValid = true;
        if (NOTIFY.equals(action)) {
            try {
                String tag = data.getString(0);
                String title = data.getString(1);
                String body = data.getString(2);
                String flag = data.getString(3);
                Log.d("NotificationPlugin", "Notification: " + tag + ", " + title + ", " + body);
                int notificationFlag = getFlagValue(flag);
                showNotification(tag, title, body, notificationFlag);
            } catch (JSONException jsonEx) {
                Log.d("NotificationPlugin", "Got JSON Exception "
                        + jsonEx.getMessage());
                actionValid = false;
            }
        } else if (CLEAR.equals(action)){
            try {
                String tag = data.getString(0);
                Log.d("NotificationPlugin", "Notification cancel: " + tag);
                clearNotification(tag);
            } catch (JSONException jsonEx) {
                Log.d("NotificationPlugin", "Got JSON Exception " + jsonEx.getMessage());
                actionValid = false;
            }
        } else {
            actionValid = false;
            Log.d("NotificationPlugin", "Invalid action : "+action+" passed");
        }
        return actionValid;
    }

    /**
     * Helper method that returns a flag value to be used for notification
     * by default it will return 16 representing FLAG_NO_CLEAR
     * 
     * @param flag
     * @return int value of the flag
     */
    private int getFlagValue(String flag) {
		int flagVal = Notification.FLAG_AUTO_CANCEL;
		
		// We trust the flag value as it comes from our JS constant.
		// This is also backwards compatible as it will be emtpy.
		if (!flag.isEmpty()){
			flagVal = Integer.parseInt(flag);
		}
		
		return flagVal;
	}

	/**
     * 	Displays status bar notification
     *
     * 	@param tag Notification tag.
     *  @param contentTitle	Notification title
     *  @param contentText	Notification text
     * */
    public void showNotification( CharSequence tag, CharSequence contentTitle, CharSequence contentText, int flag) {
        String ns = Context.NOTIFICATION_SERVICE;
        context = cordova.getActivity().getApplicationContext();
        mNotificationManager = (NotificationManager) context.getSystemService(ns);

        Notification noti = StatusNotificationIntent.buildNotification(context, tag, contentTitle, contentText, flag);
        mNotificationManager.notify(tag.hashCode(), noti);
    }

    /**
     * Cancels a single notification by tag.
     *
     * @param tag Notification tag to cancel.
     */
    public void clearNotification(String tag) {
        mNotificationManager.cancel(tag.hashCode());
    }

    /**
     * Removes all Notifications from the status bar.
     */
    public void clearAllNotifications() {
        mNotificationManager.cancelAll();
    }

    /**
     * Called when a notification is clicked.
     * @param intent The new Intent passed from the notification.
     */
    @Override
    public void onNewIntent(Intent intent) {
        // The incoming Intent may or may not have been for a notification.
        String tag = intent.getStringExtra("notificationTag");
        if (tag != null) {
        	 this.webView.sendJavascript("window.Notification.callOnclickByTag('"+ tag + "')");
        }
    }


    private NotificationManager mNotificationManager;
    private Context context;
}
