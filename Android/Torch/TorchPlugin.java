/**
 * Phonegap Torch Plugin
 * Copyright (c) Arne de Bree 2011
 *
 */
package nl.debree.phonegap.plugin.torch;

import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.api.PluginResult.Status;

import android.hardware.Camera;
import android.util.Log;

/**
 * Plugin to turn on or off the Camera Flashlight of an Android device
 * after the capability is tested  
 */
public class TorchPlugin extends Plugin {

	public static final String CMD_ON = "turnOn";
	public static final String CMD_OFF = "turnOff";
	public static final String CMD_TOGGLE = "toggle";
	public static final String CMD_IS_ON = "isOn";
	public static final String CMD_HAS_TORCH = "isCapable";
	public static final String CMD_RELEASE = "release";

	// Create camera and parameter objects
	private Camera mCamera;
	private Camera.Parameters mParameters;
	private boolean mbTorchEnabled = false;
	
	/**
	 * Constructor
	 */
	public TorchPlugin() {
		Log.d( "TorchPlugin", "Plugin created" );
		
		getCamera();//mCamera = Camera.open();		
	}

	/*
	 * Executes the request and returns PluginResult.
	 * 
	 * @param action		action to perform. Allowed values: turnOn, turnOff, toggle, isOn, isCapable
	 * @param data			input data, currently not in use
	 * @param callbackId	The callback id used when calling back into JavaScript.
	 * @return 				A PluginResult object with a status and message.
	 * 
	 * @see com.phonegap.api.Plugin#execute(java.lang.String,
	 * org.json.JSONArray, java.lang.String)
	 */
	@Override
	public PluginResult execute(String action, JSONArray data, String callbackId) {
		Log.d( "TorchPlugin", "Plugin Called " + action );

		PluginResult result = null;
		JSONObject response = new JSONObject();
		
		if (action.equals(CMD_ON)) {
			
			this.toggleTorch( true );
			result = new PluginResult( Status.OK );

		} else if (action.equals(CMD_OFF)) {
			
			this.toggleTorch( false );
			result = new PluginResult( Status.OK );
			
		} else if (action.equals(CMD_TOGGLE)) {
			
			this.toggleTorch();
			result = new PluginResult( Status.OK );
						
		} else if (action.equals(CMD_IS_ON)) {
			try {
				response.put( "on", mbTorchEnabled );
				
				result = new PluginResult( Status.OK, response );
			} catch( JSONException jsonEx ) {
				result = new PluginResult(Status.JSON_EXCEPTION);
			}			
		} else if (action.equals(CMD_HAS_TORCH)) {
			try {
				response.put( "capable", this.isCapable() );
				result = new PluginResult( Status.OK , response);
			} catch( JSONException jsonEx ) {
				result = new PluginResult(Status.JSON_EXCEPTION);
			}			
		
		} else if (action.equals(CMD_RELEASE)) {
				release();
				result = new PluginResult( Status.OK );
		
		} else {
			result = new PluginResult(Status.INVALID_ACTION);
			Log.d( "TorchPlugin", "Invalid action : " + action + " passed");
		}

		return result;
	}
	
	/**
	 * Test if this device has a Flashlight we can use and put in Torch mode
	 * 
	 * @return boolean
	 */
	protected boolean isCapable() {
		boolean result = false;
		if(mCamera==null)
			getCamera();
		mParameters = mCamera.getParameters();
		List<String> flashModes = mParameters.getSupportedFlashModes();

		if (flashModes != null	&& flashModes.contains(Camera.Parameters.FLASH_MODE_TORCH)) {
			result = true;
		}
		
		return result;
	}

	/**
	 * True toggle function, turns the torch on when off and vise versa
	 * 
	 */
	protected void toggleTorch() {
		toggleTorch( !mbTorchEnabled );
	}
	
	/**
	 * Toggle the torch in the requested state
	 * 
	 * @param state			The requested state
	 * 
	 */
	protected void toggleTorch(boolean state) {
		if(mCamera==null)
			getCamera();
		mParameters = mCamera.getParameters();

		// Make sure that torch mode is supported
		//
		if ( this.isCapable() ) {
			if (state) {
				mParameters.setFlashMode(Camera.Parameters.FLASH_MODE_TORCH);
			} else {
				mParameters.setFlashMode(Camera.Parameters.FLASH_MODE_ON);
			}

			// Commit the camera parameters
			//
			mCamera.setParameters(mParameters);

			mbTorchEnabled = state;
		}
	}
	
	/**
	 * Get camera resource
	 * 
	 * 
	 */
	protected void getCamera() {
		mCamera = Camera.open();
	}
	/**
	 * Release camera resource
	 * Useit onPause method
	 * 
	 */
	protected void release() {
		mCamera.release();
		mCamera = null;
	}
	/**
	 * Implements release on finalize
	 * 
	 * 
	 */
	protected void finalize() {
		release();
		try {
			super.finalize();
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}