package com.zenexity.SoftKeyBoardPlugin;

import org.json.JSONArray;

import android.content.Context;
import android.view.inputmethod.InputMethodManager;

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
    
    public boolean isKeyBoardShowing() {
        
    	int heightDiff = webView.getRootView().getHeight() - webView.getHeight();
    	return (100 < heightDiff); // if more than 100 pixels, its probably a keyboard...
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
        else if (action.equals("isShowing")) {
			
            return new PluginResult(PluginResult.Status.OK, this.isKeyBoardShowing());
        }
		else {
			return new PluginResult(PluginResult.Status.INVALID_ACTION);
		}
	}    
}
