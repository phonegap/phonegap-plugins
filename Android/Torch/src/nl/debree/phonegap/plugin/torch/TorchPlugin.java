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
import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import com.phonegap.api.PluginResult.Status;

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

	// Create camera and parameter objects
	private Camera mCamera;
	private Camera.Parameters mParameters;
	private boolean mbTorchEnabled = false;
	
	/**
	 * Constructor
	 */
	public TorchPlugin() {
		Log.d( "TorchPlugin", "Plugin created" );
		
		mCamera = Camera.open();		
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
				
				result = new PluginResult( Status.OK, response );
			} catch( JSONException jsonEx ) {
				result = new PluginResult(Status.JSON_EXCEPTION);
			}			
		
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
}