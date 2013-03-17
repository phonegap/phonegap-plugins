package com.sina.mobile.iflytek;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.iflytek.speech.RecognizerResult;
import com.iflytek.speech.SpeechConfig.RATE;
import com.iflytek.speech.SpeechError;
import com.iflytek.ui.RecognizerDialog;
import com.iflytek.ui.RecognizerDialogListener;
import com.iflytek.ui.UploadDialog;
import com.iflytek.ui.UploadDialogListener;

public class IFlyTekPlugin extends Plugin {
	private static final String TAG = IFlyTekPlugin.class.getSimpleName();

	private String callbackId;

	private RecognizerDialog iatDialog;

	private String appId;

	private String listenerName = "onResults";

	@Override
	public boolean isSynch(String action) {
		if (action.equals("init") || action.equals("setOption")
				|| action.equals("setListener")) {
			return true;
		}
		return super.isSynch(action);
	}

	@Override
	public PluginResult execute(String action, final JSONArray args,
			final String callbackId) {
		final PluginResult pr = new PluginResult(PluginResult.Status.NO_RESULT);

		if (action.equals("init")) {
			appId = args.optString(0);
			Log.d(TAG, "appId: " + appId);
			iatDialog = new RecognizerDialog((Context) IFlyTekPlugin.this.ctx,
					"appid=" + appId);

			Log.d(TAG, "init end");

		} else if (action.equals("setOption")) {
			JSONObject jo = args.optJSONObject(0);
			String engine = jo.optString("engine");
			String area = jo.optString("engineParams");
			String grammar = jo.optString("grammar");
			iatDialog.setEngine(TextUtils.isEmpty(engine) ? null : engine,
					TextUtils.isEmpty(area) ? null : area,
					TextUtils.isEmpty(grammar) ? null : grammar);

			String rate = jo.optString("sampleRate");
			if (rate.equals("rate8k"))
				iatDialog.setSampleRate(RATE.rate8k);
			else if (rate.equals("rate11k"))
				iatDialog.setSampleRate(RATE.rate11k);
			else if (rate.equals("rate16k"))
				iatDialog.setSampleRate(RATE.rate16k);
			else if (rate.equals("rate22k"))
				iatDialog.setSampleRate(RATE.rate22k);

			Log.d(TAG, "setOption end");

		} else if (action.equals("setListener")) {
			this.listenerName = args.optString(0);

			Log.d(TAG, "setListener end");

		} else if (action.equals("start")) {
			this.callbackId = callbackId;
			pr.setKeepCallback(true);

			Runnable runnable = new Runnable() {
				@Override
				public void run() {
					RecognizerDialogListener recognizerListener = new RecognizerDialogListener() {
						@Override
						public void onEnd(SpeechError error) {
							Log.d(TAG, "onEnd: " + error);
							int errorCode = 0;
							String message = "成功";
							if (error != null) {
								errorCode = error.getErrorCode();
								message = error.getErrorDesc();
							}

							JSONObject jo = new JSONObject();
							try {
								jo.put("errorCode", errorCode);
								jo.put("message", message);
							} catch (JSONException e) {
								e.printStackTrace();
							}

							IFlyTekPlugin.this.success(jo,
									IFlyTekPlugin.this.callbackId);
						}

						@Override
						public void onResults(
								ArrayList<RecognizerResult> results,
								boolean isLast) {
							Log.d(TAG, "onResults: isLast: " + isLast);

							try {
								String json = Object2Json.toJSONString(results);
								Log.d(TAG, "json: " + json);
								JSONArray ja = new JSONArray(json);
								JSONObject jo = new JSONObject();
								jo.put("results", ja);
								jo.put("isLast", isLast);

								IFlyTekPlugin.this.webView
										.loadUrl("javascript:"
												+ IFlyTekPlugin.this.listenerName
												+ "(" + jo.toString() + ")");
							} catch (JSONException e) {
								e.printStackTrace();
							}
						}
					};

					iatDialog.setListener(recognizerListener);
					iatDialog.show();
				}
			};
			this.ctx.runOnUiThread(runnable);

			Log.d(TAG, "start end");

		} else if (action.equals("uploadKeyword")) {
			this.callbackId = callbackId;
			pr.setKeepCallback(true);
			Runnable runnable = new Runnable() {
				@Override
				public void run() {
					UploadDialog uploadDialog = new UploadDialog(
							(Context) IFlyTekPlugin.this.ctx, "appid=" + appId);

					UploadDialogListener uploadListener = new UploadDialogListener() {
						@Override
						public void onDataUploaded(String contentID,
								String extendID) {
							JSONObject jo = new JSONObject();
							try {
								jo.put("contentID", contentID);
								jo.put("extendID", extendID);
							} catch (JSONException e) {
								e.printStackTrace();
							}
							IFlyTekPlugin.this.success(jo,
									IFlyTekPlugin.this.callbackId);
						}

						@Override
						public void onEnd(SpeechError error) {
							Log.d(TAG, "onEnd: " + error);
							int errorCode = 0;
							String message = "成功";
							if (error != null) {
								errorCode = error.getErrorCode();
								message = error.getErrorDesc();
							}

							JSONObject jo = new JSONObject();
							try {
								jo.put("errorCode", errorCode);
								jo.put("message", message);
							} catch (JSONException e) {
								e.printStackTrace();
							}

							IFlyTekPlugin.this.success(jo,
									IFlyTekPlugin.this.callbackId);
						}
					};

					uploadDialog.setListener(uploadListener);
					String keys = args.optString(0);
					String contentId = args.optString(1);
					try {
						uploadDialog.setContent(keys.getBytes("UTF-8"),
								"dtt=keylist", contentId);
					} catch (UnsupportedEncodingException e) {
						e.printStackTrace();
					}
					uploadDialog.show();
				}
			};
			this.ctx.runOnUiThread(runnable);
		}

		return pr;
	}

}
