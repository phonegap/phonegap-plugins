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

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.api.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONException;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;

import android.os.Handler;
import android.util.Log;

public class StatusBarNotification extends Plugin {
    //	Action to execute
    public static final String NOTIFY = "notify";
    public static final String CLEAR = "clear";

    /**
     * 	Executes the request and returns PluginResult
     *
     * 	@param action		Action to execute
     * 	@param data			JSONArray of arguments to the plugin
     *  @param callbackId	The callback id used when calling back into JavaScript
     *
     *  @return				A PluginRequest object with a status
     * */
    @Override
    public PluginResult execute(String action, JSONArray data, String callbackId) {
        PluginResult result = null;
        if (NOTIFY.equals(action)) {
            try {
                String tag = data.getString(0);
                String title = data.getString(1);
                String body = data.getString(2);
                Log.d("NotificationPlugin", "Notification: " + tag + ", " + title + ", " + body);
                showNotification(tag, title, body);
                result = new PluginResult(Status.OK);
            } catch (JSONException jsonEx) {
                Log.d("NotificationPlugin", "Got JSON Exception "
                        + jsonEx.getMessage());
                result = new PluginResult(Status.JSON_EXCEPTION);
            }
        } else if (CLEAR.equals(action)){
            try {
                String tag = data.getString(0);
                Log.d("NotificationPlugin", "Notification cancel: " + tag);
                clearNotification(tag);
            } catch (JSONException jsonEx) {
                Log.d("NotificationPlugin", "Got JSON Exception " + jsonEx.getMessage());
                result = new PluginResult(Status.JSON_EXCEPTION);
            }
        } else {
            result = new PluginResult(Status.INVALID_ACTION);
            Log.d("NotificationPlugin", "Invalid action : "+action+" passed");
        }
        return result;
    }

    /**
     * 	Displays status bar notification
     *
     * 	@param tag Notification tag.
     *  @param contentTitle	Notification title
     *  @param contentText	Notification text
     * */
    public void showNotification( CharSequence tag, CharSequence contentTitle, CharSequence contentText ) {
        String ns = Context.NOTIFICATION_SERVICE;
        context = cordova.getActivity().getApplicationContext();
        mNotificationManager = (NotificationManager) context.getSystemService(ns);

        Notification noti = StatusNotificationIntent.buildNotification(context, tag, contentTitle, contentText);
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
            sendJavascript("window.Notification.callOnclickByTag('"+ tag + "')");
        }
    }


    private NotificationManager mNotificationManager;
    private Context context;
}
