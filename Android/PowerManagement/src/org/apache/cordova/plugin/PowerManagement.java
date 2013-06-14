/*
   Copyright 2011-2012 Wolfgang Koller - http://www.gofg.at/

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

/**
 * Cordova (Android) plugin for accessing the power-management functions of the device
 * @author Wolfgang Koller <viras@users.sourceforge.net>
 */
package org.apache.cordova.plugin;

import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.os.PowerManager;
import android.util.Log;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaInterface;
import org.apache.cordova.api.CordovaPlugin;

/**
 * Plugin class which does the actual handling
 */
public class PowerManagement extends CordovaPlugin {
	// As we only allow one wake-lock, we keep a reference to it here
	private PowerManager.WakeLock wakeLock = null;
	private PowerManager powerManager = null;

	/**
	 * Fetch a reference to the power-service when the plugin is initialized
	 */
	@Override
	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		super.initialize(cordova, webView);

		this.powerManager = (PowerManager) cordova.getActivity().getSystemService(Context.POWER_SERVICE);
	}

	@Override
	public boolean execute(String action, JSONArray args,
			CallbackContext callbackContext) throws JSONException {

		Log.d("PowerManagementPlugin", "Plugin execute called - " + this.toString() );
		Log.d("PowerManagementPlugin", "Action is " + action );

		try {
			if( action.equals("acquire") ) {				
				String type = args.optString(0);
				if(type.equals("dim") ) {
					Log.d("PowerManagementPlugin", "Only dim lock" );
					this.acquire( PowerManager.SCREEN_DIM_WAKE_LOCK );
				}
				else if(type.equals("partial") ) {
					Log.d("PowerManagementPlugin", "Only partial lock" );
					this.acquire( PowerManager.PARTIAL_WAKE_LOCK );
				}
				else {
					Log.d("PowerManagementPlugin", "Full wakelock" );
					this.acquire( PowerManager.FULL_WAKE_LOCK );
				}
			}
			else if( action.equals("release") ) {
				this.release();
			}
		}
		catch( Exception e ) {
			return false;
		}

		callbackContext.success();
		return true;
	}

	/**
	 * Acquire a wake-lock
	 * @param p_flags Type of wake-lock to acquire
	 */
	private void acquire( int p_flags ) {

		if (this.wakeLock == null) {
			this.wakeLock = this.powerManager.newWakeLock(p_flags, "PowerManagementPlugin");
			try {
				this.wakeLock.acquire();
			}
			catch( Exception e ) {
				this.wakeLock = null;
			}
		}
	}

	/**
	 * Release an active wake-lock
	 */
	private void release() {

		if( this.wakeLock != null ) {
			this.wakeLock.release();
			this.wakeLock = null;

		}
	}

	/**
	 * Make sure any wakelock is released if the app goes into pause
	 */
	@Override
	public void onPause(boolean multitasking) {
		if( this.wakeLock != null ) this.wakeLock.release();

		super.onPause(multitasking);
	}

	/**
	 * Make sure any wakelock is acquired again once we resume
	 */
	@Override
	public void onResume(boolean multitasking) {
		if( this.wakeLock != null ) this.wakeLock.acquire();

		super.onResume(multitasking);
	}
}
