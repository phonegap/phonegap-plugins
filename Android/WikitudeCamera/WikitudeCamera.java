/**
 * Phonegap Wikitude AR camera view plugin
 * Copyright (c) Spletart 2011
 *
 */
package com.spletart.mobile;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.openintents.intents.WikitudeARIntent;
import org.openintents.intents.WikitudePOI;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import com.phonegap.api.PhonegapActivity;
import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

/**
 * This calls out to the Wikitude SDK and returns the result.
 */
public class WikitudeCamera extends Plugin {

	public static final String ACTION = "show";
	public static final int REQUEST_CODE = 0x0ba7c0de;
	public String callback;
	
	public static final String defaultInstallTitle = "Install Wikitude Browser?";
	public static final String defaultInstallMessage = "This requires the free Wikitude Browser app. Would you like to install it now?";
	public static final String defaultYesString = "Yes";
	public static final String defaultNoString = "No";

	@Override
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		this.callback = callbackId;
		Log.d("WikitudeARCamera Plugin", "Plugin Called");
		PluginResult result = null;

		// extract data and options...
		JSONArray data;
		JSONObject options;
		try {
			data = args.getJSONArray(0);
			options = args.getJSONObject(1);
		} catch (JSONException e1) {
			e1.printStackTrace();
			return new PluginResult(PluginResult.Status.JSON_EXCEPTION);
		}

		if (ACTION.equals(action)) {

			// prepare pois list
			List<WikitudePOI> pois = new ArrayList<WikitudePOI>();
			for (int i = 0; i < data.length(); i++) {

				try {
					JSONObject obj = data.getJSONObject(i);

					Double latitude = obj.getDouble("latitude");
					Double longitude = obj.getDouble("longitude");

					WikitudePOI poi = new WikitudePOI(latitude, longitude);
					poi.setName(obj.getString("name"));
					poi.setDescription(obj.getString("description"));

					pois.add(poi);
				} catch (JSONException e) {
					e.printStackTrace();
					// Go on...
				}
			}

			// add POIs to AR intent
			WikitudeARIntent intent = new WikitudeARIntent(
					this.ctx.getApplication(), null, null);
			intent.addPOIs(pois);
			intent.addTitleText(extract(options, "title"));

			try {
				this.ctx.startActivityForResult((Plugin) this, intent,
						REQUEST_CODE);
			} catch (ActivityNotFoundException e) {
				// Extract installation dialog strings...
				String installTitle = defaultInstallTitle;
				if(options.length() > 1) {
					installTitle = extract(options, "installTitle");
				}
				String installMessage = defaultInstallMessage;
				if(options.length() > 2) {
					installMessage = extract(options, "installMessage");
				}
				String yesString = defaultYesString;
				if(options.length() > 3) {
					yesString = extract(options, "yesString");
				}
				String noString = defaultNoString;
				if(options.length() > 4) {
					noString = extract(options, "noString");
				}
				// Installation dialog
				showDownloadDialog(installTitle, installMessage, yesString, noString);
			}

			return new PluginResult(PluginResult.Status.NO_RESULT);
		}
		return null;
	}

	private String extract(JSONObject options, String key) {
		try {
			return options.getString(key);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return "";
	}

	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		if (requestCode == REQUEST_CODE) {
			if (resultCode == Activity.RESULT_OK) {
				String contents = intent.getStringExtra("SCAN_RESULT");
				this.success(
						new PluginResult(PluginResult.Status.OK, contents),
						this.callback);
			} else {
				this.error(new PluginResult(PluginResult.Status.ERROR),
						this.callback);
			}
		}
	}
	
	private void showDownloadDialog(final String title, final String message, final String yesString, final String noString) {
		final PhonegapActivity context = this.ctx;
		Runnable runnable = new Runnable() {
			public void run() {

				AlertDialog.Builder dialog = new AlertDialog.Builder(context);
				dialog.setTitle(title);
				dialog.setMessage(message);
				dialog.setPositiveButton(yesString, new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dlg, int i) {
						dlg.dismiss();
						Intent intent = new Intent(Intent.ACTION_VIEW,
												   Uri.parse("market://search?q=pname:com.wikitude")
												   );
						try {
							context.startActivity(intent);
						} catch (ActivityNotFoundException e) {
							// We don't have the market app installed.
							e.printStackTrace();
						}

					}
				});
				dialog.setNegativeButton(noString, new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dlg, int i) {
						dlg.dismiss();
					}
				});
				dialog.create();
				dialog.show();
			}
		};
		context.runOnUiThread(runnable);
	}

}
