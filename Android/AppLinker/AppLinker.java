package se.nindev.applinker;

import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import com.phonegap.api.PhonegapActivity;
import com.phonegap.api.Plugin;

public class AppLinker extends Plugin {

	@Override
	public PluginResult execute(String action, JSONArray data, String callbackId) {
		try {
			String name = data.getString(0);
			if(name != null)
			{
				linkOrStartApp(name);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}

		return null;
	}

	public void linkOrStartApp(String packageName){
		final Activity currentCtx = (Activity) ctx.getContext();
		Intent launchIntent = currentCtx.getPackageManager().getLaunchIntentForPackage(packageName);
		if(launchIntent != null)
		{
    		currentCtx.startActivity(launchIntent);
		}
    	else
    	{
    		Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + packageName));
    		currentCtx.startActivity(browserIntent);
    	}
    }

}
