/*
 * Copyright (C) 2011 Wolfgang Koller
 * 
 * This file is part of GOFG Sports Computer - http://www.gofg.at/.
 * 
 * GOFG Sports Computer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * GOFG Sports Computer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with GOFG Sports Computer.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * PhoneGap (Android) plugin for accessing the power-management functions of the device
 * @author Wolfgang Koller <viras@users.sourceforge.net>
 */
package com.phonegap.plugin;

import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.os.PowerManager;
import android.util.Log;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import com.phonegap.api.PluginResult.Status;

/**
 * Plugin class which does the actual handling
 */
public class PowerManagement extends Plugin {
	// As we only allow one wake-lock, we keep a reference to it here
	private PowerManager.WakeLock wakeLock = null;

	/**
	 * Called by the PhoneGap framework to handle a call to this plugin
	 * @param action currently supported are 'acquire' and 'release'
	 * @param data In case of action 'acquire' this may contain a parameter set to 'true' to indicate only a dim wake-lock
	 */
	@Override
	public PluginResult execute(String action, JSONArray data, String callbackId) {
		PluginResult result = null;
		Log.d("PowerManagementPlugin", "Plugin execute called - " + this.toString() );
		Log.d("PowerManagementPlugin", "Action is " + action );
		
		if( action.equals("acquire") ) {
			try {
				if( data.length() > 0 && data.getBoolean(0) ) {
					Log.d("PowerManagementPlugin", "Only dim lock" );
					result = this.acquire( PowerManager.SCREEN_DIM_WAKE_LOCK );
				}
				else {
					result = this.acquire( PowerManager.FULL_WAKE_LOCK );
				}
			}
			catch( JSONException jsonEx ) {
				result = new PluginResult(Status.JSON_EXCEPTION, jsonEx.getMessage());
			}
		}
		else if( action.equals("release") ) {
			result = this.release();
		}
		
		Log.d("PowerManagementPlugin", "Result is " + result.toString() );

		return result;
	}
	
	/**
	 * Acquire a wake-lock
	 * @param p_flags Type of wake-lock to acquire
	 * @return PluginResult containing the status of the acquire process
	 */
	private PluginResult acquire( int p_flags ) {
		PluginResult result = null;
		
		if( this.wakeLock == null ) {
			PowerManager pm = (PowerManager) ctx.getSystemService(Context.POWER_SERVICE);
			this.wakeLock = pm.newWakeLock(p_flags, "PowerManagementPlugin");
			this.wakeLock.acquire();

			result = new PluginResult(PluginResult.Status.OK);
		}
		else {
			result = new PluginResult(PluginResult.Status.ILLEGAL_ACCESS_EXCEPTION, "WakeLock already active - release first");
		}
		
		return result;
	}
	
	/**
	 * Release an active wake-lock
	 * @return PluginResult containing the status of the release process
	 */
	private PluginResult release() {
		PluginResult result = null;
		
		if( this.wakeLock != null ) {
			this.wakeLock.release();
			this.wakeLock = null;
			
			result = new PluginResult(PluginResult.Status.OK);
		}
		else {
			result = new PluginResult(PluginResult.Status.ILLEGAL_ACCESS_EXCEPTION, "No WakeLock active - acquire first");
		}
		
		return result;
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
