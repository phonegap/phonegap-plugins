package org.apache.cordova;

import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaPlugin;
import org.apache.cordova.api.LOG;
import org.json.JSONArray;
import org.json.JSONException;
import android.app.ProgressDialog;

public class WaitingDialog extends CordovaPlugin {
	
	private ProgressDialog waitingDialog = null;
	
	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
		if ("show".equals(action)) {
			String text = "Please wait";
			try {
				text = args.getString(0);
			} catch (Exception e) {
				LOG.d("WaitingDialog", "Text parameter not valid, using default");
			}
			showWaitingDialog(text);
			callbackContext.success();
			return true;
		} else if ("hide".equals(action)) {
			hideWaitingDialog();
			callbackContext.success();
			return true;
		}
		return false;
	}
	
	public void showWaitingDialog(String text) {
		waitingDialog = ProgressDialog.show(this.cordova.getActivity(), "", text);
		LOG.d("WaitingDialog", "Dialog shown, waiting hide command");
	}
	
	public void hideWaitingDialog() {
		if (waitingDialog != null) {
			waitingDialog.dismiss();
			LOG.d("WaitingDialog", "Dialog dismissed");
			waitingDialog = null;
		} else {
			LOG.d("WaitingDialog", "Nothing to dismiss");
		}
	}
	
}
