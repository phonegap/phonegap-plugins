// This class is used on all Androids below Honeycomb
package com.phonegap.plugins.statusBarNotification;


import com.google.cordova.statusbarnotificationtest.R;
import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;

public class StatusNotificationIntent {
    public static Notification buildNotification( Context context, CharSequence contentTitle, CharSequence contentText ) {
        int icon = R.drawable.notification;
        long when = System.currentTimeMillis();
        Notification noti = new Notification(icon, contentTitle, when);
        noti.flags |= Notification.FLAG_AUTO_CANCEL;
        
        PackageManager pm = context.getPackageManager();
        Intent notificationIntent = pm.getLaunchIntentForPackage(context.getPackageName());
        notificationIntent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        
        PendingIntent contentIntent = PendingIntent.getActivity(context, 0, notificationIntent, 0);
        noti.setLatestEventInfo(context, contentTitle, contentText, contentIntent);
        return noti;
    }
}
