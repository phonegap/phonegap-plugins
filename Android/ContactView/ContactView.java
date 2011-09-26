package com.rearden;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

public class ContactView extends Plugin {
	private static final int PICK_CONTACT = 1;
	private String callback;

	@Override
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		startContactActivity();
		PluginResult mPlugin = new PluginResult(PluginResult.Status.NO_RESULT);
		mPlugin.setKeepCallback(true);
		this.callback = callbackId;
		return mPlugin;
	}

	public void startContactActivity() {
		Intent intent = new Intent(Intent.ACTION_PICK);
		intent.setType(ContactsContract.Contacts.CONTENT_TYPE);
		this.ctx.startActivityForResult((Plugin) this, intent, PICK_CONTACT);
	}

	@Override
	public void onActivityResult(int reqCode, int resultCode, Intent data) {
		String name = null;
		String number = null;
		String email = null;
		switch (reqCode) {
		case (PICK_CONTACT):
			if (resultCode == Activity.RESULT_OK) {
				Uri contactData = data.getData();
				Cursor c = this.ctx.managedQuery(contactData, null, null, null, null);
				if (c.moveToFirst()) {
					String ContactID = c.getString(c
							.getColumnIndex(ContactsContract.Contacts._ID));
					String hasPhone = c.getString(c.getColumnIndex(ContactsContract.Contacts.HAS_PHONE_NUMBER));

					if (Integer.parseInt(hasPhone) == 1) {
						Cursor phoneCursor = this.ctx.managedQuery(
										ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
										null,
										ContactsContract.CommonDataKinds.Phone.CONTACT_ID
												+ "='" + ContactID + "'", null,
										null);
						while (phoneCursor.moveToNext()) {
							number = phoneCursor
									.getString(phoneCursor
									.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
						}
					}
					// get email address
					Cursor emailCur = this.ctx.managedQuery( 
							ContactsContract.CommonDataKinds.Email.CONTENT_URI, 
							null,
							ContactsContract.CommonDataKinds.Email.CONTACT_ID + "='" + ContactID + "'", null,null); 
						while (emailCur.moveToNext()) { 
						    // This would allow you get several email addresses
					            // if the email addresses were stored in an array
						    email = emailCur.getString(
					                      emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA));
					 	    //String emailType = emailCur.getString(
					          //            emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.TYPE)); 
					 	} 
					 	emailCur.close();

					name = c.getString(c.getColumnIndexOrThrow(ContactsContract.Contacts.DISPLAY_NAME));
					JSONObject contactObject = new JSONObject();
					try {
						contactObject.put("name", name);
						contactObject.put("phone", number);
						contactObject.put("email", email);
					} catch (JSONException e) {
						e.printStackTrace();
					}

					this.success(new PluginResult(PluginResult.Status.OK,
							contactObject), this.callback);
				}
			}
			break;
		}
	}
}
