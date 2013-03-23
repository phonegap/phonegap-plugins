package com.sina.phonegap.weibo;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import com.weibo.net.DialogError;
import com.weibo.net.Weibo;
import com.weibo.net.WeiboDialogListener;
import com.weibo.net.WeiboException;

/*
 * Created by qhm123.
 * Copyright (c) 2012年 SINA SAE. All rights reserved.
 * Under the Apache License 2.0.
 */

public class WeiboPlugin extends Plugin {

	private static final String TAG = WeiboPlugin.class.getSimpleName();

	private String callbackId;

	@Override
	public PluginResult execute(String action, final JSONArray args,
			final String callbackId) {
		final PluginResult pr = new PluginResult(PluginResult.Status.NO_RESULT);
		pr.setKeepCallback(true);
		Log.d(TAG, "action: " + action);

		if (action.equals("init")) {

			this.callbackId = callbackId;
			Runnable runnable = new Runnable() {
				@Override
				public void run() {
					final Weibo weibo = Weibo.getInstance();
					try {
						String appId = args.getString(0);
						String appSecret = args.getString(1);
						String redirectUrl = args.getString(2);
						weibo.setupConsumerConfig(appId, appSecret);
						weibo.setRedirectUrl(redirectUrl);

						WeiboPlugin.this.success("success",
								WeiboPlugin.this.callbackId);
					} catch (JSONException e) {
						e.printStackTrace();
						WeiboPlugin.this.error("error",
								WeiboPlugin.this.callbackId);
					}
				}
			};
			this.cordova.getActivity().runOnUiThread(runnable);

		} else if (action.equals("login")) {
			final Weibo weibo = Weibo.getInstance();
			this.callbackId = callbackId;

			Runnable runnable = new Runnable() {
				public void run() {
					weibo.authorize(
							(Activity) WeiboPlugin.this.cordova.getActivity(),
							new AuthDialogListener(WeiboPlugin.this));
				};
			};
			this.cordova.getActivity().runOnUiThread(runnable);

		}

		return pr;
	}

	class AuthDialogListener implements WeiboDialogListener {
		final WeiboPlugin fba;

		public AuthDialogListener(WeiboPlugin fba) {
			super();
			this.fba = fba;
		}

		@Override
		public void onComplete(Bundle values) {
			String token = values.getString("access_token");
			String expires_in = values.getString("expires_in");
			// Log.d(TAG, "token: " + token + ", expires_in: " + expires_in);
			String json = "{\"access_token\": \"" + token
					+ "\", \"expires_in\": \"" + expires_in + "\"}";
			JSONObject jo = null;
			try {
				jo = new JSONObject(json);
			} catch (JSONException e) {
				e.printStackTrace();
			}

			this.fba.success(jo, this.fba.callbackId);
		}

		@Override
		public void onError(DialogError e) {
			this.fba.error("Error: " + e.getMessage(), this.fba.callbackId);
		}

		@Override
		public void onCancel() {
			this.fba.error("Cancelled", this.fba.callbackId);
		}

		@Override
		public void onWeiboException(WeiboException e) {
			this.fba.error("Weibo error: " + e.getMessage(),
					this.fba.callbackId);
		}
	}

}
