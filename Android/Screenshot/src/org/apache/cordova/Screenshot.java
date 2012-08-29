/**
 * Copyright (C) 2012 30ideas (http://30ide.as)
 * MIT licensed
 * 
 * @author Josemando Sobral
 * @created Jul 2nd, 2012.
 */
package org.apache.cordova;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;

import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.os.Environment;
import android.util.Base64;
import android.view.View;

public class Screenshot extends Plugin {
	private PluginResult result = null;
	private String callbackId;

	@Override
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		this.callbackId = callbackId;

		if (action.equals("saveScreenshot")) {
			saveScreenshot();
			return result;
		} else if (action.equals("saveScreenshotAsFile")) {
			saveScreenshotAsFile();
			return result;
		} 

		return new PluginResult(PluginResult.Status.IO_EXCEPTION, new Exception("Action:" +action+" not supported").getMessage());
	}

	private PluginResult runActivity(Runnable runnable) {
		// starting on ICS, some WebView methods
		// can only be called on UI threads
		super.cordova.getActivity().runOnUiThread(runnable);

		// waiting ui thread to finish
		while (result == null) {
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// ignoring exception, since we have to wait
				// ui thread to finish
			}
		}

		return result;
	}

	private Bitmap takeScreenshot() throws FileNotFoundException {
		View view = webView.getRootView();

		view.setDrawingCacheEnabled(true);
		Bitmap bitmap = Bitmap.createBitmap(view.getDrawingCache());
		view.setDrawingCacheEnabled(false);

		File folder = new File(Environment.getExternalStorageDirectory(), "Pictures");
		if (!folder.exists()) {
			folder.mkdirs();
		}

		File f = new File(folder, "screenshot_" + System.currentTimeMillis() + ".png");

		FileOutputStream fos = new FileOutputStream(f);
		bitmap.compress(Bitmap.CompressFormat.PNG, 100, fos);

		return bitmap;
	}

	private void saveScreenshot() {
		runActivity(new Runnable() {
			@Override
			public void run() {
				try {
					takeScreenshot();
					result = new PluginResult(PluginResult.Status.OK);

				} catch (IOException e) {
					result = new PluginResult(PluginResult.Status.IO_EXCEPTION, e.getMessage());
				}
			}
		});
	}

	private void saveScreenshotAsFile() {
		class SaveScreenshotAsFileRunnable implements Runnable {

			private Screenshot screenshot;
			private String callbackId;

			public SaveScreenshotAsFileRunnable(Screenshot screenshot, String callbackId) {
				this.screenshot = screenshot;
				this.callbackId = callbackId;
			}

			@Override
			public void run() {
				try {
					Bitmap bitmap = takeScreenshot();
					ByteArrayOutputStream jpeg_data = new ByteArrayOutputStream();
					if (bitmap.compress(CompressFormat.PNG, 100, jpeg_data)) {
		                byte[] code = jpeg_data.toByteArray();
		                byte[] output = Base64.encode(code, Base64.DEFAULT);
		                String js_out = new String(output);
		                result = new PluginResult(PluginResult.Status.OK, js_out);
		                js_out = null;
		                output = null;
		                code = null;
		            }
					
				} catch (IOException e) {
					result = new PluginResult(PluginResult.Status.IO_EXCEPTION, e.getMessage());
					this.screenshot.error(result, this.callbackId);
				}
			}

		}
		runActivity(new SaveScreenshotAsFileRunnable(this, this.callbackId));
	}

}
