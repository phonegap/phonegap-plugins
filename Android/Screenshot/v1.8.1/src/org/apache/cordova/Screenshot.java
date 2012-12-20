/**
 * Copyright (C) 2012 30ideas (http://30ide.as)
 * MIT licensed
 * 
 * @author Josemando Sobral
 * @created Jul 2nd, 2012.
 */
package org.apache.cordova;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;

import android.graphics.Bitmap;
import android.os.Environment;
import android.view.View;

public class Screenshot extends Plugin {
	private PluginResult result = null;

	@Override
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		// starting on ICS, some WebView methods
		// can only be called on UI threads
		super.cordova.getActivity().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				View view = webView.getRootView();

				view.setDrawingCacheEnabled(true);
				Bitmap bitmap = Bitmap.createBitmap(view.getDrawingCache());
				view.setDrawingCacheEnabled(false);

				try {
					File folder = new File(Environment.getExternalStorageDirectory(), "Pictures");
					if (!folder.exists()) {
						folder.mkdirs();
					}

					File f = new File(folder, "screenshot_" + System.currentTimeMillis() + ".png");

					FileOutputStream fos = new FileOutputStream(f);
					bitmap.compress(Bitmap.CompressFormat.PNG, 100, fos);
					result = new PluginResult(PluginResult.Status.OK);

				} catch (IOException e) {
					result = new PluginResult(PluginResult.Status.IO_EXCEPTION, e.getMessage());
				}
			}
		});

		// waiting ui thread to finish
		while (this.result == null) {
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// ignoring exception, since we have to wait
				// ui thread to finish
			}
		}

		return this.result;
	}

}
