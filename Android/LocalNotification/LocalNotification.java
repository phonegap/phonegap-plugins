package com.phonegap.plugin.localnotification;

import java.util.Calendar;

import org.json.JSONArray;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.util.Log;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

/**
 * This plugin utilizes the Android AlarmManager in combination with StatusBar
 * notifications. When a local notification is scheduled the alarm manager takes
 * care of firing the event. When the event is processed, a notification is put
 * in the Android status bar.
 * 
 * @author Daniel van 't Oever
 */
public class LocalNotification extends Plugin {

    public static final String PLUGIN_NAME = "LocalNotification";

    /**
     * Delegate object that does the actual alarm registration. Is reused by the
     * AlarmRestoreOnBoot class.
     */
    private AlarmHelper alarm = null;

    @Override
    public PluginResult execute(String action, JSONArray optionsArr, String callBackId) {
	alarm = new AlarmHelper(this.ctx);
	Log.d(PLUGIN_NAME, "Plugin execute called with action: " + action);

	PluginResult result = null;

	final AlarmOptions alarmOptions = new AlarmOptions();
	alarmOptions.parseOptions(optionsArr);

	/*
	 * Determine which action of the plugin needs to be invoked
	 */
	String alarmId = alarmOptions.getNotificationId();
	if (action.equalsIgnoreCase("add")) {
	    final boolean daily = alarmOptions.isRepeatDaily();
	    final String title = alarmOptions.getAlarmTitle();
	    final String subTitle = alarmOptions.getAlarmSubTitle();
	    final String ticker = alarmOptions.getAlarmTicker();

	    persistAlarm(alarmId, optionsArr);
	    return this.add(daily, title, subTitle, ticker, alarmId, alarmOptions.getCal());
	} else if (action.equalsIgnoreCase("cancel")) {
	    unpersistAlarm(alarmId);
	    return this.cancelNotification(alarmId);
	} else if (action.equalsIgnoreCase("cancelall")) {
	    PluginResult result = this.cancelAllNotifications();
	    unpersistAlarmAll();
	    return result;
	}

	return result;
    }

    /**
     * Set an alarm
     * 
     * @param repeatDaily
     *            If true, the alarm interval will be set to one day.
     * @param alarmTitle
     *            The title of the alarm as shown in the Android notification
     *            panel
     * @param alarmSubTitle
     *            The subtitle of the alarm
     * @param alarmId
     *            The unique ID of the notification
     * @param cal
     *            A calendar object that represents the time at which the alarm
     *            should first be started
     * @return A pluginresult.
     */
    public PluginResult add(boolean repeatDaily, String alarmTitle, String alarmSubTitle, String alarmTicker,
	    String alarmId, Calendar cal) {
	final long triggerTime = cal.getTimeInMillis();
	final String recurring = repeatDaily ? "daily" : "onetime";

	Log.d(PLUGIN_NAME, "Adding " + recurring + " notification: '" + alarmTitle + alarmSubTitle + "' with id: "
		+ alarmId + " at timestamp: " + triggerTime);

	boolean result = alarm.addAlarm(repeatDaily, alarmTitle, alarmSubTitle, alarmTicker, alarmId, cal);
	if (result) {
	    return new PluginResult(PluginResult.Status.OK);
	} else {
	    return new PluginResult(PluginResult.Status.ERROR);
	}
    }

    /**
     * Cancel a specific notification that was previously registered.
     * 
     * @param notificationId
     *            The original ID of the notification that was used when it was
     *            registered using addNotification()
     */
    public PluginResult cancelNotification(String notificationId) {
	Log.d(PLUGIN_NAME, "cancelNotification: Canceling event with id: " + notificationId);

	boolean result = alarm.cancelAlarm(notificationId);
	if (result) {
	    return new PluginResult(PluginResult.Status.OK);
	} else {
	    return new PluginResult(PluginResult.Status.ERROR);
	}
    }

    /**
     * Cancel all notifications that were created by this plugin.
     */
    public PluginResult cancelAllNotifications() {
	Log.d(PLUGIN_NAME, "cancelAllNotifications: cancelling all events for this application");
	/*
	 * Android can only unregister a specific alarm. There is no such thing
	 * as cancelAll. Therefore we rely on the Shared Preferences which holds
	 * all our alarms to loop through these alarms and unregister them one
	 * by one.
	 */
	final SharedPreferences alarmSettings = this.ctx.getSharedPreferences(PLUGIN_NAME, Context.MODE_PRIVATE);
	final boolean result = alarm.cancelAll(alarmSettings);

	if (result) {
	    return new PluginResult(PluginResult.Status.OK);
	} else {
	    return new PluginResult(PluginResult.Status.ERROR);
	}
    }

    /**
     * Persist the information of this alarm to the Android Shared Preferences.
     * This will allow the application to restore the alarm upon device reboot.
     * Also this is used by the cancelAllNotifications method.
     * 
     * @see #cancelAllNotifications()
     * 
     * @param optionsArr
     *            The assumption is that parseOptions has been called already.
     * 
     * @return true when successfull, otherwise false
     */
    private boolean persistAlarm(String alarmId, JSONArray optionsArr) {
	final Editor alarmSettingsEditor = this.ctx.getSharedPreferences(PLUGIN_NAME, Context.MODE_PRIVATE).edit();

	alarmSettingsEditor.putString(alarmId, optionsArr.toString());

	return alarmSettingsEditor.commit();
    }

    /**
     * Remove a specific alarm from the Android shared Preferences
     * 
     * @param alarmId
     *            The Id of the notification that must be removed.
     * 
     * @return true when successfull, otherwise false
     */
    private boolean unpersistAlarm(String alarmId) {
	final Editor alarmSettingsEditor = this.ctx.getSharedPreferences(PLUGIN_NAME, Context.MODE_PRIVATE).edit();

	alarmSettingsEditor.remove(alarmId);

	return alarmSettingsEditor.commit();
    }

    /**
     * Clear all alarms from the Android shared Preferences
     * 
     * @return true when successfull, otherwise false
     */
    private boolean unpersistAlarmAll() {
	final Editor alarmSettingsEditor = this.ctx.getSharedPreferences(PLUGIN_NAME, Context.MODE_PRIVATE).edit();

	alarmSettingsEditor.clear();

	return alarmSettingsEditor.commit();
    }
}
