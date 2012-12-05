/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) 2006-2011 Worklight, Ltd. 
 * Upgraded by Doers' Guild  
 */

package com.phonegap.plugins.analytics;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.api.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONException;

import com.google.analytics.tracking.android.EasyTracker;
import com.google.analytics.tracking.android.Tracker;

import android.util.Log;

public class GoogleAnalyticsTracker extends Plugin {
	public static final String START = "start";
	public static final String STOP = "stop";
	public static final String TRACK_PAGE_VIEW = "trackPageView";
	public static final String TRACK_EVENT = "trackEvent";

	private Tracker tracker;
	private com.google.analytics.tracking.android.EasyTracker instance;

	public GoogleAnalyticsTracker() {
		instance = com.google.analytics.tracking.android.EasyTracker
				.getInstance();
	}

	@Override
	public PluginResult execute(String action, JSONArray data, String callbackId) {
		PluginResult result = null;
		if (START.equals(action)) {
			start();
			result = new PluginResult(Status.OK);
		} else if (TRACK_PAGE_VIEW.equals(action)) {
			try {
				trackPageView(data.getString(0));
				result = new PluginResult(Status.OK);
			} catch (JSONException e) {
				result = new PluginResult(Status.JSON_EXCEPTION);
			}
		} else if (TRACK_EVENT.equals(action)) {
			try {
				trackEvent(data.getString(0), data.getString(1),
						data.getString(2), data.getLong(3));
				result = new PluginResult(Status.OK);
			} catch (JSONException e) {
				result = new PluginResult(Status.JSON_EXCEPTION);
			}
		} else if (STOP.equals(action)) {
			stop();
			result = new PluginResult(Status.OK);
		} else {
			result = new PluginResult(Status.INVALID_ACTION);
		}
		return result;
	}

	private void start() {
		instance.activityStart(this.cordova.getActivity());
		tracker = EasyTracker.getTracker();
	}

	private void stop() {
		instance.activityStop(this.cordova.getActivity());
	}

	private void trackPageView(String key) {
		tracker.trackView(key);
	}

	private void trackEvent(String category, String action, String label,
			long value) {
		tracker.trackEvent(category, action, label, value);
	}

}