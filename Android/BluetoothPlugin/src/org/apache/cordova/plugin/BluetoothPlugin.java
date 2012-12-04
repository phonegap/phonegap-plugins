/*
   Copyright 2012 Wolfgang Koller - http://www.gofg.at/

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

package org.apache.cordova.plugin;

import org.apache.cordova.api.CordovaInterface;
import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;

import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.UUID;

import org.json.JSONException;
import org.json.JSONObject;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Parcelable;
import android.util.Log;

public class BluetoothPlugin extends Plugin {
	private static final String ACTION_ENABLE = "enable";
	private static final String ACTION_DISABLE = "disable";
	private static final String ACTION_DISCOVERDEVICES = "discoverDevices";
	private static final String ACTION_GETUUIDS = "getUUIDs";
	private static final String ACTION_CONNECT = "connect";
	private static final String ACTION_READ = "read";
	private static final String ACTION_DISCONNECT = "disconnect";
	
	private static String ACTION_UUID = "";
	private static String EXTRA_UUID = "";

	private BluetoothAdapter m_bluetoothAdapter = null;
	private BPBroadcastReceiver m_bpBroadcastReceiver = null;
	private boolean m_discovering = false;
	private boolean m_gettingUuids = false;
	private boolean m_stateChanging = false;

	private JSONArray m_discoveredDevices = null;
	private JSONArray m_gotUUIDs = null;
	
	private ArrayList<BluetoothSocket> m_bluetoothSockets = new ArrayList<BluetoothSocket>();

	/**
	 * Constructor for Bluetooth plugin
	 */
	public BluetoothPlugin() {
		m_bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
		m_bpBroadcastReceiver = new BPBroadcastReceiver();
		
		try {
			Field actionUUID = BluetoothDevice.class.getDeclaredField("ACTION_UUID");
			BluetoothPlugin.ACTION_UUID = (String) actionUUID.get(null);
			Log.d("BluetoothPlugin", "actionUUID: " + actionUUID.getName() + " / " + actionUUID.get(null));

			Field extraUUID = BluetoothDevice.class.getDeclaredField("EXTRA_UUID");
			BluetoothPlugin.EXTRA_UUID = (String) extraUUID.get(null);
			Log.d("BluetoothPlugin", "extraUUID: " + extraUUID.getName() + " / " + extraUUID.get(null));
		}
		catch( Exception e ) {
			Log.e("BluetoothPlugin", e.getMessage() );
		}
	}
	
	/**
	 * Register receiver as soon as we have the context
	 */
	@Override
	public void setContext(CordovaInterface ctx) {
		super.setContext(ctx);

		// Register for necessary bluetooth events
		cordova.getActivity().registerReceiver(m_bpBroadcastReceiver, new IntentFilter(
				BluetoothAdapter.ACTION_DISCOVERY_FINISHED));
		cordova.getActivity().registerReceiver(m_bpBroadcastReceiver, new IntentFilter(
				BluetoothDevice.ACTION_FOUND));
		cordova.getActivity().registerReceiver(m_bpBroadcastReceiver, new IntentFilter(BluetoothPlugin.ACTION_UUID));
	}

	/**
	 * Execute a bluetooth function
	 */
	@Override
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		PluginResult pluginResult = null;
		
		Log.d("BluetoothPlugin", "Action: " + action);
		
		// Check if bluetooth is supported at all
		if( m_bluetoothAdapter == null ) {
			pluginResult = new PluginResult(PluginResult.Status.ILLEGAL_ACCESS_EXCEPTION, "No bluetooth adapter found");
		}
		else {
			if (ACTION_ENABLE.equals(action)) {
				// Check if bluetooth isn't disabled already
				if( !m_bluetoothAdapter.isEnabled() ) {
					m_stateChanging = true;
					cordova.startActivityForResult(this, new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), 1);
					while(m_stateChanging) {};
				}
				
				// Check if bluetooth is enabled now
				if(m_bluetoothAdapter.isEnabled()) {
					pluginResult = new PluginResult(PluginResult.Status.OK, "OK");
				}
				else {
					pluginResult = new PluginResult(PluginResult.Status.ERROR, "Bluetooth not enabled");
				}
			}
			// Want to disable bluetooth?
			else if (ACTION_DISABLE.equals(action)) {
				if( !m_bluetoothAdapter.disable() && m_bluetoothAdapter.isEnabled() ) {
					pluginResult = new PluginResult(PluginResult.Status.ERROR, "Unable to disable bluetooth");
				}
				else {
					pluginResult = new PluginResult(PluginResult.Status.OK, "OK");
				}
				
			}
			else if (ACTION_DISCOVERDEVICES.equals(action)) {
				m_discoveredDevices = new JSONArray();
	
				if (!m_bluetoothAdapter.startDiscovery()) {
					pluginResult = new PluginResult(PluginResult.Status.ERROR,
							"Unable to start discovery");
				} else {
					m_discovering = true;
	
					// Wait for discovery to finish
					while (m_discovering) {}
					
					Log.d("BluetoothPlugin", "DiscoveredDevices: " + m_discoveredDevices.length());
					
					pluginResult = new PluginResult(PluginResult.Status.OK, m_discoveredDevices);
				}
			}
			// Want to list UUIDs of a certain device
			else if( ACTION_GETUUIDS.equals(action) ) {
				
				try {
					String address = args.getString(0);
					Log.d("BluetoothPlugin", "Listing UUIDs for: " + address);
					
					// Fetch UUIDs from bluetooth device
					BluetoothDevice bluetoothDevice = m_bluetoothAdapter.getRemoteDevice(address);
					Method m = bluetoothDevice.getClass().getMethod("fetchUuidsWithSdp");
					Log.d("BluetoothPlugin", "Method: " + m);
					m.invoke(bluetoothDevice);
					
					m_gettingUuids = true;
					
					while(m_gettingUuids) {}
					
					pluginResult = new PluginResult(PluginResult.Status.OK, m_gotUUIDs);
					
				}
				catch( Exception e ) {
					Log.e("BluetoothPlugin", e.toString() + " / " + e.getMessage() );
					
					pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.getMessage());
				}
			}
			// Connect to a given device & uuid endpoint
			else if( ACTION_CONNECT.equals(action) ) {
				try {
					String address = args.getString(0);
					UUID uuid = UUID.fromString(args.getString(1));
					
					Log.d( "BluetoothPlugin", "Connecting..." );
	
					BluetoothDevice bluetoothDevice = m_bluetoothAdapter.getRemoteDevice(address);
					BluetoothSocket bluetoothSocket = bluetoothDevice.createRfcommSocketToServiceRecord(uuid);
					
					bluetoothSocket.connect();
					
					m_bluetoothSockets.add(bluetoothSocket);
					int socketId = m_bluetoothSockets.indexOf(bluetoothSocket);
					
					pluginResult = new PluginResult(PluginResult.Status.OK, socketId);
				}
				catch( Exception e ) {
					Log.e("BluetoothPlugin", e.toString() + " / " + e.getMessage() );
					
					pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.getMessage());
				}
			}
			else if( ACTION_READ.equals(action) ) {
				try {
					int socketId = args.getInt(0);
					
					BluetoothSocket bluetoothSocket = m_bluetoothSockets.get(socketId);
					InputStream inputStream = bluetoothSocket.getInputStream();
					
					char[] buffer = new char[128];
					for( int i = 0; i < buffer.length; i++ ) {
						buffer[i] = (char) inputStream.read();
					}
					
					//Log.d( "BluetoothPlugin", "Buffer: " + String.valueOf(buffer) );
					pluginResult = new PluginResult(PluginResult.Status.OK, String.valueOf(buffer));
				}
				catch( Exception e ) {
					Log.e("BluetoothPlugin", e.toString() + " / " + e.getMessage() );
					
					pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.getMessage());
				}
			}
			else if( ACTION_DISCONNECT.equals(action) ) {
				try {
					int socketId = args.getInt(0);
					
					// Fetch socket & close it
					BluetoothSocket bluetoothSocket = m_bluetoothSockets.get(socketId);
					bluetoothSocket.close();
					
					// Remove socket from internal list
					m_bluetoothSockets.remove(socketId);
					
					// Everything went fine...
					pluginResult = new PluginResult(PluginResult.Status.OK, "OK");
				}
				catch( Exception e ) {
					Log.e("BluetoothPlugin", e.toString() + " / " + e.getMessage() );
					
					pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.getMessage());
				}
			}
			else {
				pluginResult = new PluginResult(PluginResult.Status.INVALID_ACTION, "Action '" + action + "' not supported");
			}
		}

		return pluginResult;
	}

	/**
	 * Receives activity results
	 */
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		if( requestCode == 1 ) {
			m_stateChanging = false;
		}
	}

	/**
	 * Helper class for handling all bluetooth based events
	 */
	private class BPBroadcastReceiver extends BroadcastReceiver {
		@Override
		public void onReceive(Context context, Intent intent) {
			String action = intent.getAction();
			
			//Log.d( "BluetoothPlugin", "Action: " + action );

			// Check if we found a new device
			if (BluetoothDevice.ACTION_FOUND.equals(action)) {
				BluetoothDevice bluetoothDevice = intent
						.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);

				try {
					JSONObject deviceInfo = new JSONObject();
					deviceInfo.put("name", bluetoothDevice.getName());
					deviceInfo.put("address", bluetoothDevice.getAddress());
					
					m_discoveredDevices.put(deviceInfo);
				} catch (JSONException e) {
					Log.e("BluetoothPlugin", e.getMessage());
				}
			}
			// Check if we finished discovering devices
			else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {
				m_discovering = false;
			}
			// Check if we found UUIDs
			else if(BluetoothPlugin.ACTION_UUID.equals(action)) {
				m_gotUUIDs = new JSONArray();
				
				Parcelable[] parcelUuids = intent.getParcelableArrayExtra(BluetoothPlugin.EXTRA_UUID);
				if( parcelUuids != null ) {
					Log.d("BluetoothPlugin", "Found UUIDs: " + parcelUuids.length);
	
					// Sort UUIDs into JSON array and return it
					for( int i = 0; i < parcelUuids.length; i++ ) {
						m_gotUUIDs.put( parcelUuids[i].toString() );
					}
	
					m_gettingUuids = false;
				}
			}
		}
	};
}
