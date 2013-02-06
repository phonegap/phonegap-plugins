/**
 * Phonegap ClipboardManager plugin
 * Omer Saatcioglu 2011
 * enhanced by Guillaume Charhon - Smart Mobile Software 2011
 * plugin enhanced to support all SDK by Raid A. Nahi - globaleastsw.com 
 */

package com.saatcioglu.phonegap.clipboardmanager;

import org.json.JSONArray;
import org.json.JSONException;

import android.content.ClipData;
import android.content.Context;
import android.content.ClipboardManager;
import android.os.Looper;
import android.util.Log;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

public class ClipboardManagerPlugin extends Plugin {
  private static final String actionCopy = "copy";
	private static final String actionPaste = "paste";
	private static final String errorParse = "Couldn't get the text to copy";
	private static final String errorUnknown = "Unknown Error";

//	private ClipboardManager mClipboardManager;


	/**
	 * Executes the request and returns PluginResult.
	 *
	 * @param action
	 *            The action to execute.
	 * @param args
	 *            JSONArry of arguments for the plugin.
	 * @param callbackId
	 *            The callback id used when calling back into JavaScript.
	 * @return A PluginResult object with a status and message.
	 */
	
   	@SuppressWarnings("deprecation")
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		
	    Looper.prepare();
		Log.d("Clipboard", "Clipboard: plugin called");
	
			 int sdk = android.os.Build.VERSION.SDK_INT;
			 if(sdk < 11) {
				 android.text.ClipboardManager mClipboardManager = (android.text.ClipboardManager) ((Context) ctx).getSystemService(Context.CLIPBOARD_SERVICE);
				 if (action.equals(actionCopy)) {
					 try {
							Log.d("Copy", "Clipboard: copy text");
							mClipboardManager.setText( (String) args.get(0));
							Log.d("Copy", "Clipboard: text copied");
						} catch (JSONException e) {
							Log.d("JSON Error", "Clipboard: " + errorParse);
							return new PluginResult(PluginResult.Status.ERROR, errorParse);
						} catch (Exception e) {
							Log.d("Error", "Clipboard: " + errorUnknown);
							return new PluginResult(PluginResult.Status.ERROR, errorUnknown);
						}
						return new PluginResult(PluginResult.Status.OK, "");
					 }
				    else if (action.equals(actionPaste)) {
					  	return new PluginResult(PluginResult.Status.OK,(String) mClipboardManager.getText().toString());
						} else {
						return new PluginResult(PluginResult.Status.INVALID_ACTION);
					}
			 }  // Begin SDK larger or equal to 11
			 else {
				 android.content.ClipboardManager mClipboardManager = (android.content.ClipboardManager) ((Context) ctx).getSystemService(Context.CLIPBOARD_SERVICE);
				// Copy
					if (action.equals(actionCopy)) {
						ClipData arg ;
						try {
							Log.d("Copy2", "Clipboard: copy text");
							arg = ClipData.newPlainText("ishahrazad", (String) args.get(0));
							mClipboardManager.setPrimaryClip(arg);
							Log.d("Copy2", "Clipboard: text copied");
						} catch (JSONException e) {
							Log.d("JSON Error", "Clipboard: " + errorParse);
							return new PluginResult(PluginResult.Status.ERROR, errorParse);
						} catch (Exception e) {
							Log.d("Error", "Clipboard: " + errorUnknown);
							return new PluginResult(PluginResult.Status.ERROR, errorUnknown);
						}
						return new PluginResult(PluginResult.Status.OK, "");
						
					// Paste
					} else if (action.equals(actionPaste)) {
						ClipData arg =  mClipboardManager.getPrimaryClip();
						if (arg == null) {
							arg =  ClipData.newPlainText("ishahrazad", "");
						}
						return new PluginResult(PluginResult.Status.OK,(String) arg.getItemAt(0).getText());
					} else {
						return new PluginResult(PluginResult.Status.INVALID_ACTION);
					}
			 } // end SDK larger or equal to 11
			
	}  // end of proc
}
