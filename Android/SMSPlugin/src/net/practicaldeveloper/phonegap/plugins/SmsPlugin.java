/*
Copyright (C) 2011 by Daniel Shookowsky

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
package net.practicaldeveloper.phonegap.plugins;

import org.apache.cordova.api.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONException;

import android.app.PendingIntent;
import android.content.Intent;
import android.telephony.SmsManager;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

public class SmsPlugin extends Plugin {
	public final String ACTION_SEND_SMS = "SendSMS";
	
	@Override
	public PluginResult execute(String action, JSONArray arg1, String callbackId) {
		PluginResult result = new PluginResult(Status.INVALID_ACTION);
		
		if (action.equals(ACTION_SEND_SMS)) {
			try {
				String phoneNumber = arg1.getString(0);
				String message = arg1.getString(1);
				sendSMS(phoneNumber, message);
				result = new PluginResult(Status.OK);
			}
			catch (JSONException ex) {
				result = new PluginResult(Status.JSON_EXCEPTION, ex.getMessage());
			}			
		}
		
		return result;
	}

	private void sendSMS(String phoneNumber, String message) {
		SmsManager manager = SmsManager.getDefault();
		
        PendingIntent sentIntent = PendingIntent.getActivity(this.ctx.getContext(), 0, new Intent(), 0);  
		
		manager.sendTextMessage(phoneNumber, null, message, sentIntent, null);
	}

}
