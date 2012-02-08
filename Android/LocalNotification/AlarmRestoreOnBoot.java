package com.phonegap.plugin.localnotification;

import java.util.Calendar;
import java.util.Map;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONException;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.util.Log;

/**
 * This class is triggered upon reboot of the device. It needs to re-register
 * the alarms with the AlarmManager since these alarms are lost in case of
 * reboot.
 * 
 * @author dvtoever
 */
public class AlarmRestoreOnBoot extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
	final String pluginName = LocalNotification.PLUGIN_NAME;
	
	// Obtain alarm details form Shared Preferences
	final SharedPreferences alarmSettings = context.getSharedPreferences(pluginName, Context.MODE_PRIVATE);
	final Map<String, ?> allAlarms = alarmSettings.getAll();
	final Set<String> alarmIds = allAlarms.keySet();

	/*
	 * For each alarm, parse its alarm options and register is again with
	 * the Alarm Manager
	 */
	for (String alarmId : alarmIds) {
	    try {
		final AlarmHelper alarm = new AlarmHelper(context);
		final JSONArray alarmDetails = new JSONArray(alarmSettings.getString(alarmId, ""));
		final AlarmOptions options = new AlarmOptions();

		options.parseOptions(alarmDetails);

		final boolean daily = options.isRepeatDaily();
		final String title = options.getAlarmTitle();
		final String subTitle = options.getAlarmSubTitle();
		final String ticker = options.getAlarmTicker();
		final String id = options.getNotificationId();
		final Calendar cal = options.getCal();

		alarm.addAlarm(daily, title, subTitle, ticker, id, cal);

	    } catch (JSONException e) {
		Log.d(pluginName,
			"AlarmRestoreOnBoot: Error while restoring alarm details after reboot: " + e.toString());
	    }

	    Log.d(pluginName, "AlarmRestoreOnBoot: Successfully restored alarms upon reboot");
	}
    }
}
