/*
Copyright (C) 2013 by Pierre-Yves Orban

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package org.apache.cordova.plugin;

import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaPlugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.telephony.SmsManager;

public class SmsSendingPlugin extends CordovaPlugin {
	public final String ACTION_HAS_SMS_POSSIBILITY = "HasSMSPossibility";
	public final String ACTION_SEND_SMS = "SendSMS";
	
	private SmsManager smsManager = null;
	
	public SmsSendingPlugin() {
		super();
		smsManager = SmsManager.getDefault();
	}
	
	@Override
	public boolean execute(String action, JSONArray args,
			final CallbackContext callbackContext) throws JSONException {
		
		if (action.equals(ACTION_HAS_SMS_POSSIBILITY)) {
			
			Activity ctx = this.cordova.getActivity();
			if(ctx.getPackageManager().hasSystemFeature(PackageManager.FEATURE_TELEPHONY)){
				callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, true));
			} else {
				callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, false));
			}
			return true;
		}
		else if (action.equals(ACTION_SEND_SMS)) {
			try {
				String phoneNumber = args.getString(0);
				String message = args.getString(1);
				this.sendSMS(phoneNumber, message);
				
				callbackContext.sendPluginResult(new PluginResult(
						PluginResult.Status.OK));
			}
			catch (JSONException ex) {
				callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, ex.getMessage()));
			}
			return true;
		}
		return false;
	}

	private void sendSMS(String phoneNumber, String message) {
        PendingIntent sentIntent = PendingIntent.getActivity(this.cordova.getActivity(), 0, new Intent(), 0);  
		smsManager.sendTextMessage(phoneNumber, null, message, sentIntent, null);
	}
}
