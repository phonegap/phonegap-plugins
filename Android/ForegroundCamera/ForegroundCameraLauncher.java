/*
	    Copyright 2012 Bruno Carreira - Lucas Farias - Rafael Luna - Vin�cius Fonseca.

		Licensed under the Apache License, Version 2.0 (the "License");
		you may not use this file except in compliance with the License.
		You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

		Unless required by applicable law or agreed to in writing, software
		distributed under the License is distributed on an "AS IS" BASIS,
		WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
		See the License for the specific language governing permissions and
   		limitations under the License.   			
 */

package com.foregroundcameraplugin;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;

import org.apache.cordova.CameraLauncher;
import org.apache.cordova.ExifHelper;
import org.apache.cordova.api.CordovaInterface;
import org.apache.cordova.api.LOG;
import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;

/**
 * This class launches the camera view, allows the user to take a picture,
 * closes the camera view, and returns the captured image. When the camera view
 * is closed, the screen displayed before the camera view was shown is
 * redisplayed.
 */
public class ForegroundCameraLauncher extends CameraLauncher {

	private static final String LOG_TAG = "ForegroundCameraLauncher";

	private int mQuality;
	private int targetWidth;
	private int targetHeight;

	private Uri imageUri;
	private File photo;

	public String callbackId;
	private int numPics;

	private static final String _DATA = "_data";

	/**
	 * Constructor.
	 */
	public ForegroundCameraLauncher() {
	}

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
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		PluginResult.Status status = PluginResult.Status.OK;
		String result = "";
		this.callbackId = callbackId;

		try {
			if (action.equals("takePicture")) {
				this.targetHeight = 0;
				this.targetWidth = 0;
				this.mQuality = 80;

				JSONObject options = args.optJSONObject(0);
				if (options != null) {
					this.targetHeight = options.getInt("targetHeight");
					this.targetWidth = options.getInt("targetWidth");
					this.mQuality = options.getInt("quality");
				}

				this.takePicture();

				PluginResult r = new PluginResult(PluginResult.Status.NO_RESULT);
				r.setKeepCallback(true);
				return r;
			}
			return new PluginResult(status, result);
		} catch (JSONException e) {
			e.printStackTrace();
			return new PluginResult(PluginResult.Status.JSON_EXCEPTION);
		}
	}

	// --------------------------------------------------------------------------
	// LOCAL METHODS
	// --------------------------------------------------------------------------

	/**
	 * Take a picture with the camera. When an image is captured or the camera
	 * view is cancelled, the result is returned in
	 * CordovaActivity.onActivityResult, which forwards the result to
	 * this.onActivityResult.
	 * 
	 * The image can either be returned as a base64 string or a URI that points
	 * to the file. To display base64 string in an img tag, set the source to:
	 * img.src="data:image/jpeg;base64,"+result; or to display URI in an img tag
	 * img.src=result;
	 * 
	 */
	public void takePicture() {
		// Save the number of images currently on disk for later
		this.numPics = queryImgDB().getCount();

		Intent intent = new Intent(this.cordova.getActivity().getApplicationContext(), CameraActivity.class);
		this.photo = createCaptureFile();
		this.imageUri = Uri.fromFile(photo);
		intent.putExtra(MediaStore.EXTRA_OUTPUT, this.imageUri);

		this.cordova.startActivityForResult((Plugin) this, intent, 1);
	}

	/**
	 * Create a file in the applications temporary directory based upon the
	 * supplied encoding.
	 * 
	 * @return a File object pointing to the temporary picture
	 */
	private File createCaptureFile() {
		File photo = new File(getTempDirectoryPath(this.cordova.getActivity().getApplicationContext()), "Pic.jpg");
		return photo;
	}

	/**
	 * Called when the camera view exits.
	 * 
	 * @param requestCode
	 *            The request code originally supplied to
	 *            startActivityForResult(), allowing you to identify who this
	 *            result came from.
	 * @param resultCode
	 *            The integer result code returned by the child activity through
	 *            its setResult().
	 * @param intent
	 *            An Intent, which can return result data to the caller (various
	 *            data can be attached to Intent "extras").
	 */
	public void onActivityResult(int requestCode, int resultCode, Intent intent) {

		// If image available
		if (resultCode == Activity.RESULT_OK) {
			try {
				// Create an ExifHelper to save the exif data that is lost
				// during compression
				ExifHelper exif = new ExifHelper();
				exif.createInFile(getTempDirectoryPath(this.cordova.getActivity().getApplicationContext())
						+ "/Pic.jpg");
				exif.readExifData();

				// Read in bitmap of captured image
				Bitmap bitmap;
				try {
					bitmap = android.provider.MediaStore.Images.Media
							.getBitmap(this.cordova.getActivity().getContentResolver(), imageUri);
				} catch (FileNotFoundException e) {
					Uri uri = intent.getData();
					android.content.ContentResolver resolver = this.cordova.getActivity().getContentResolver();
					bitmap = android.graphics.BitmapFactory
							.decodeStream(resolver.openInputStream(uri));
				}

				bitmap = scaleBitmap(bitmap);

				// Create entry in media store for image
				// (Don't use insertImage() because it uses default compression
				// setting of 50 - no way to change it)
				ContentValues values = new ContentValues();
				values.put(android.provider.MediaStore.Images.Media.MIME_TYPE,
						"image/jpeg");
				Uri uri = null;
				try {
					uri = this.cordova.getActivity().getContentResolver()
							.insert(android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
									values);
				} catch (UnsupportedOperationException e) {
					LOG.d(LOG_TAG, "Can't write to external media storage.");
					try {
						uri = this.cordova.getActivity().getContentResolver()
								.insert(android.provider.MediaStore.Images.Media.INTERNAL_CONTENT_URI,
										values);
					} catch (UnsupportedOperationException ex) {
						LOG.d(LOG_TAG, "Can't write to internal media storage.");
						this.failPicture("Error capturing image - no media storage found.");
						return;
					}
				}

				// Add compressed version of captured image to returned media
				// store Uri
				OutputStream os = this.cordova.getActivity().getContentResolver()
						.openOutputStream(uri);
				bitmap.compress(Bitmap.CompressFormat.JPEG, this.mQuality, os);
				os.close();

				// Restore exif data to file
				exif.createOutFile(getRealPathFromURI(uri, this.ctx));
				exif.writeExifData();

				// Send Uri back to JavaScript for viewing image
				this.success(new PluginResult(PluginResult.Status.OK,
						getRealPathFromURI(uri, this.ctx)), this.callbackId);

				bitmap.recycle();
				bitmap = null;
				System.gc();

				checkForDuplicateImage();
			} catch (IOException e) {
				e.printStackTrace();
				this.failPicture("Error capturing image.");
			}
		}

		// If cancelled
		else if (resultCode == Activity.RESULT_CANCELED) {
			this.failPicture("Camera cancelled.");
		}

		// If something else
		else {
			this.failPicture("Did not complete!");
		}
	}

	/**
	 * Scales the bitmap according to the requested size.
	 * 
	 * @param bitmap
	 *            The bitmap to scale.
	 * @return Bitmap A new Bitmap object of the same bitmap after scaling.
	 */
	public Bitmap scaleBitmap(Bitmap bitmap) {
		int newWidth = this.targetWidth;
		int newHeight = this.targetHeight;
		int origWidth = bitmap.getWidth();
		int origHeight = bitmap.getHeight();

		// If no new width or height were specified return the original bitmap
		if (newWidth <= 0 && newHeight <= 0) {
			return bitmap;
		}
		// Only the width was specified
		else if (newWidth > 0 && newHeight <= 0) {
			newHeight = (newWidth * origHeight) / origWidth;
		}
		// only the height was specified
		else if (newWidth <= 0 && newHeight > 0) {
			newWidth = (newHeight * origWidth) / origHeight;
		}
		// If the user specified both a positive width and height
		// (potentially different aspect ratio) then the width or height is
		// scaled so that the image fits while maintaining aspect ratio.
		// Alternatively, the specified width and height could have been
		// kept and Bitmap.SCALE_TO_FIT specified when scaling, but this
		// would result in whitespace in the new image.
		else {
			double newRatio = newWidth / (double) newHeight;
			double origRatio = origWidth / (double) origHeight;

			if (origRatio > newRatio) {
				newHeight = (newWidth * origHeight) / origWidth;
			} else if (origRatio < newRatio) {
				newWidth = (newHeight * origWidth) / origHeight;
			}
		}

		return Bitmap.createScaledBitmap(bitmap, newWidth, newHeight, true);
	}

	/**
	 * Creates a cursor that can be used to determine how many images we have.
	 * 
	 * @return a cursor
	 */
	private Cursor queryImgDB() {
		return this.cordova.getActivity().getContentResolver().query(
				android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
				new String[] { MediaStore.Images.Media._ID }, null, null, null);
	}

	/**
	 * Used to find out if we are in a situation where the Camera Intent adds to
	 * images to the content store. If we are using a FILE_URI and the number of
	 * images in the DB increases by 2 we have a duplicate, when using a
	 * DATA_URL the number is 1.
	 */
	private void checkForDuplicateImage() {
		int diff = 2;
		Cursor cursor = queryImgDB();
		int currentNumOfImages = cursor.getCount();

		// delete the duplicate file if the difference is 2 for file URI or 1
		// for Data URL
		if ((currentNumOfImages - numPics) == diff) {
			cursor.moveToLast();
			int id = Integer.valueOf(cursor.getString(cursor
					.getColumnIndex(MediaStore.Images.Media._ID))) - 1;
			Uri uri = Uri.parse(MediaStore.Images.Media.EXTERNAL_CONTENT_URI
					+ "/" + id);
			this.cordova.getActivity().getContentResolver().delete(uri, null, null);
		}
	}

	/**
	 * Determine if we can use the SD Card to store the temporary file. If not
	 * then use the internal cache directory.
	 * 
	 * @return the absolute path of where to store the file
	 */
	private String getTempDirectoryPath(Context ctx) {
		File cache = null;

		// SD Card Mounted
		if (Environment.getExternalStorageState().equals(
				Environment.MEDIA_MOUNTED)) {
			cache = new File(Environment.getExternalStorageDirectory()
					.getAbsolutePath()
					+ "/Android/data/"
					+ ctx.getPackageName() + "/cache/");
		}
		// Use internal storage
		else {
			cache = ctx.getCacheDir();
		}

		// Create the cache directory if it doesn't exist
		if (!cache.exists()) {
			cache.mkdirs();
		}

		return cache.getAbsolutePath();
	}

	/**
	 * Queries the media store to find out what the file path is for the Uri we
	 * supply
	 * 
	 * @param contentUri
	 *            the Uri of the audio/image/video
	 * @param ctx
	 *            the current applicaiton context
	 * @return the full path to the file
	 */
	private String getRealPathFromURI(Uri contentUri, CordovaInterface ctx) {
		String[] proj = { _DATA };
		Cursor cursor = cordova.getActivity().managedQuery(contentUri, proj, null, null, null);
		int column_index = cursor.getColumnIndexOrThrow(_DATA);
		cursor.moveToFirst();
		return cursor.getString(column_index);
	}
}
