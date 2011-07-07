package com.zenexity.SoftKeyBoardPlugin;

import com.phonegap.DroidGap;
import android.content.Context;
import android.view.inputmethod.InputMethodManager;
import android.webkit.WebView;
import org.json.*;
import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

public class SoftKeyBoard extends Plugin {

    public SoftKeyBoard() {
    }

    public void showKeyBoard() {
        InputMethodManager mgr = (InputMethodManager) this.ctx.getSystemService(Context.INPUT_METHOD_SERVICE);
        mgr.showSoftInput(webView, InputMethodManager.SHOW_IMPLICIT);
        
        ((InputMethodManager) this.ctx.getSystemService(Context.INPUT_METHOD_SERVICE)).showSoftInput(webView, 0); 
    }
    
    public void hideKeyBoard() {
        InputMethodManager mgr = (InputMethodManager) this.ctx.getSystemService(Context.INPUT_METHOD_SERVICE);
        mgr.hideSoftInputFromWindow(webView.getWindowToken(), 0);
    }

	public PluginResult execute(String action, JSONArray args, String callbackId) {
		if (action.equals("show")) {
            this.showKeyBoard();
			return new PluginResult(PluginResult.Status.OK, "done");
		} 
        else if (action.equals("hide")) {
            this.hideKeyBoard();
            return new PluginResult(PluginResult.Status.OK);
        }
		else {
			return new PluginResult(PluginResult.Status.INVALID_ACTION);
		}
	}    
}
