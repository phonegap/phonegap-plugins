package com.phonegap.plugin.localnotification;

import java.util.Calendar;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

/**
 * The alarm receiver is triggered when a scheduled alarm is fired. This class
 * reads the information in the intent and displays this information in the
 * Android notification bar. The notification uses the default notification
 * sound and it vibrates the phone.
 * 
 * @author dvtoever
 */
public class AlarmReceiver extends BroadcastReceiver {

	public static final String TITLE = "ALARM_TITLE";
	public static final String SUBTITLE = "ALARM_SUBTITLE";
	public static final String TICKER_TEXT = "ALARM_TICKER";
	public static final String NOTIFICATION_ID = "NOTIFICATION_ID";

	/* Contains time in 24hour format 'HH:mm' e.g. '04:30' or '18:23' */
	public static final String HOUR_OF_DAY = "HOUR_OF_DAY";
	public static final String MINUTE = "MINUTES";

	@Override
	public void onReceive(Context context, Intent intent) {
		Log.d("AlarmReceiver", "AlarmReceiver invoked!");

		final Bundle bundle = intent.getExtras();
		final Object systemService = context.getSystemService(Context.NOTIFICATION_SERVICE);

		// Retrieve notification details from the intent
		final String tickerText = bundle.getString(TICKER_TEXT);
		final String notificationTitle = bundle.getString(TITLE);
		final String notificationSubText = bundle.getString(SUBTITLE);
		int notificationId = 0;

		try {
			notificationId = Integer.parseInt(bundle.getString(NOTIFICATION_ID));
		} catch (Exception e) {
			Log.d("AlarmReceiver", "Unable to process alarm with id: " + bundle.getString(NOTIFICATION_ID));
		}

		Calendar currentCal = Calendar.getInstance();
		int alarmHour = bundle.getInt(HOUR_OF_DAY);
		int alarmMin = bundle.getInt(MINUTE);
		int currentHour = currentCal.get(Calendar.HOUR_OF_DAY);
		int currentMin = currentCal.get(Calendar.MINUTE);

		if (currentHour != alarmHour && currentMin != alarmMin) {
			/*
			 * If you set a repeating alarm at 11:00 in the morning and it
			 * should trigger every morning at 08:00 o'clock, it will
			 * immediately fire. E.g. Android tries to make up for the
			 * 'forgotten' reminder for that day. Therefore we ignore the event
			 * if Android tries to 'catch up'.
			 */
			Log.d(LocalNotification.PLUGIN_NAME, "AlarmReceiver, ignoring alarm since it is due");
			return;
		}

		// Construct the notification and notificationManager objects
		final NotificationManager notificationMgr = (NotificationManager) systemService;
		final Notification notification = new Notification(R.drawable.ic_launcher, tickerText,
				System.currentTimeMillis());
		final PendingIntent contentIntent = PendingIntent.getActivity(context, 0, new Intent(), 0);
		notification.defaults |= Notification.DEFAULT_SOUND;
		notification.vibrate = new long[] { 0, 100, 200, 300 };
		notification.setLatestEventInfo(context, notificationTitle, notificationSubText, contentIntent);

		/*
		 * If you want all reminders to stay in the notification bar, you should
		 * generate a random ID. If you want do replace an existing
		 * notification, make sure the ID below matches the ID that you store in
		 * the alarm intent.
		 */
		notificationMgr.notify(notificationId, notification);
	}
}
