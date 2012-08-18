/*
   Copyright 2012 Wolfgang Koller - http://www.gofg.at/
   
   Modified and improved Agust, 2012 Hüseyin Kozan http://huseyinkozan.com.tr

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

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Set;
import java.util.UUID;

import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.TargetApi;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Parcelable;
import android.util.Log;

public class BluetoothPlugin extends Plugin {
	
	private static final String ACTION_IS_SUPPORTED = 		"isSupported";
	private static final String ACTION_ENABLE = 				"enable";
	private static final String ACTION_DISABLE = 				"disable";
	private static final String ACTION_IS_ENABLED = 			"isEnabled";
	private static final String ACTION_GETADDRESS = 			"getAddress";
	private static final String ACTION_GETNAME = 				"getName";
	private static final String ACTION_REQUEST_DISCOVERABLE =	"requestDiscoverable";
	private static final String ACTION_STARTDISCOVERY = 		"startDiscovery";
	private static final String ACTION_CANCELDISCOVERY = 		"cancelDiscovery";
	private static final String ACTION_GETBONDEDDEVICES = 	"getBondedDevices";
	private static final String ACTION_CONNECT = 				"connect";
	private static final String ACTION_DISCONNECT = 			"disconnect";
	private static final String ACTION_LISTEN = 				"listen";
	private static final String ACTION_READ = 				"read";
	private static final String ACTION_WRITE = 				"write";
	
	// min api 10 {
	private static final String ACTION_CONNECTINSECURE = 		"connectInsecure";
	// }
	
	// min api 15 {
	private static final String ACTION_FETCHUUIDS = 			"fetchUUIDs";
	private static String ACTION_UUID = "";
	private static String EXTRA_UUID = "";
	private JSONArray m_gotUUIDs = null;
	public String callback_uuids = null;
	// }
	
	private final int REQUEST_CODE_ENABLE = 1;
	private final int REQUEST_CODE_DISCOVERABLE = 2;
	
	private BluetoothAdapter m_bluetoothAdapter = null;
	private BPBroadcastReceiver m_bpBroadcastReceiver = null;
	
	public String callback_enable = null;
	public String callback_discovery = null;
	public String callback_discoverable = null;
	public String callback_listen = null;
	
	private final int CONNECTION_SECURE = 1;
	private final int CONNECTION_INSECURE = 2;
	
	private ArrayList<BluetoothSocket> m_bluetoothSockets = new ArrayList<BluetoothSocket>();
	private JSONArray m_discoveredDevices = null;
	

	/**
	 * Constructor for Bluetooth plugin
	 */
	public BluetoothPlugin() {
		
		m_bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
		m_bpBroadcastReceiver = new BPBroadcastReceiver();
		
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH_MR1) {
			try {
				Field actionUUID = BluetoothDevice.class.getDeclaredField("ACTION_UUID");
				BluetoothPlugin.ACTION_UUID = (String) actionUUID.get(null);
				Log.d("BluetoothPlugin", "actionUUID: " + actionUUID.getName() + " / " + actionUUID.get(null));
				Field extraUUID = BluetoothDevice.class.getDeclaredField("EXTRA_UUID");
				BluetoothPlugin.EXTRA_UUID = (String) extraUUID.get(null);
				Log.d("BluetoothPlugin", "extraUUID: " + extraUUID.getName() + " / " + extraUUID.get(null));
			}
			catch( Exception e ) {
				logErr( e.getMessage() );
			}
		}
	}

	/**
	 * Register receiver as soon as we have the context
	 */
	@Override
	public void setContext(CordovaInterface cordova) {
		super.setContext(cordova);

		// Register for necessary bluetooth events
		this.cordova.getActivity().registerReceiver(m_bpBroadcastReceiver,
				new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED));
		this.cordova.getActivity().registerReceiver(m_bpBroadcastReceiver,
				new IntentFilter(BluetoothDevice.ACTION_FOUND));
		this.cordova.getActivity().registerReceiver(m_bpBroadcastReceiver, 
				new IntentFilter(BluetoothPlugin.ACTION_UUID));
		
	}
	
	@Override
	public void onDestroy() {
		this.cordova.getActivity().unregisterReceiver(m_bpBroadcastReceiver);
		super.onDestroy();
	}

	/**
	 * Execute a bluetooth function
	 */
	@Override
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		PluginResult pluginResult = null;

		logDbg("Action: " + action);
		
		
		if ( ACTION_IS_SUPPORTED.equals(action) ) 
		{
			pluginResult = action_isSupported();
		}
		else if ( m_bluetoothAdapter == null )
		{
			pluginResult = action_support_error();
		}
		else if ( ACTION_ENABLE.equals(action) )
		{
			this.callback_enable = callbackId;
			pluginResult = action_enable();
		}
		else if ( ACTION_DISABLE.equals(action) )
		{
			pluginResult = action_disable();
			
		}
		else if ( ACTION_IS_ENABLED.equals(action) )
		{
			pluginResult = action_isEnabled();
			
		}
		else if ( ACTION_GETADDRESS.equals(action) )
		{
			pluginResult = action_getAddress();
		}
		else if ( ACTION_GETNAME.equals(action) )
		{
			pluginResult = action_getName();
		}
		else if ( ACTION_REQUEST_DISCOVERABLE.equals(action) )
		{
			try {
				this.callback_discoverable = callbackId;
				pluginResult = action_requestDiscoverable(args.getInt(0));
			} catch (JSONException e) {
				String msg = e.toString() + " / " + e.getMessage();
				logErr( msg );
				pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, msg);
			}
		}
		else if ( ACTION_STARTDISCOVERY.equals(action) )
		{
			this.callback_discovery = callbackId;
			pluginResult = action_startDiscovery();
		}
		else if ( ACTION_CANCELDISCOVERY.equals(action) )
		{
			pluginResult = action_cancelDiscovery();
		}
		else if ( ACTION_GETBONDEDDEVICES.equals(action) )
		{
			pluginResult = action_getBondedDevices();
		}
		else if (ACTION_FETCHUUIDS.equals(action))
		{
			try {
				this.callback_uuids = callbackId;
				pluginResult = action_fetchUUIDs(args.getString(0));
			} catch (JSONException e) {
				String msg = e.toString() + " / " + e.getMessage();
				logErr( msg );
				pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, msg);
			}
		}
		else if ( ACTION_CONNECT.equals(action) )
		{
			try {
				pluginResult = action_connect(
						args.getString(0),
						UUID.fromString(args.getString(1)),
						this.CONNECTION_SECURE);
			} catch (JSONException e) {
				String msg = e.toString() + " / " + e.getMessage();
				logErr( msg );
				pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, msg);
			}
		}
		else if ( ACTION_CONNECTINSECURE.equals(action) )
		{
			try {
				pluginResult = action_connect(
						args.getString(0),
						UUID.fromString(args.getString(1)),
						this.CONNECTION_INSECURE);
			} catch (JSONException e) {
				String msg = e.toString() + " / " + e.getMessage();
				logErr( msg );
				pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, msg);
			}
		}
		else if (ACTION_DISCONNECT.equals(action)) 
		{
			try {
				pluginResult = action_disconnect(args.getInt(0));
			} catch (JSONException e) {
				String msg = e.toString() + " / " + e.getMessage();
				logErr( msg );
				pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, msg);
			}
		}
		else if ( ACTION_LISTEN.equals(action) )
		{
			try {
				this.callback_listen = callbackId;
				pluginResult = action_listen(args.getString(0),args.getString(1));
			} catch (JSONException e) {
				String msg = e.toString() + " / " + e.getMessage();
				logErr( msg );
				pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, msg);
			}

		}
		else if ( ACTION_READ.equals(action) ) 
		{
			try {
				pluginResult = action_read(args.getInt(0));
			} catch (JSONException e) {
				String msg = e.toString() + " / " + e.getMessage();
				logErr( msg );
				pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, msg);
			}
		}
		else if ( ACTION_WRITE.equals(action) )
		{
			try {
				pluginResult = action_write(args.getInt(0), args.getJSONArray(1));
			} catch (JSONException e) {
				String msg = e.toString() + " / " + e.getMessage();
				logErr( msg );
				pluginResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, msg);
			}
		}
		else {
			pluginResult = new PluginResult(PluginResult.Status.INVALID_ACTION);
		}
		return pluginResult;
	}

	

	/**
	 * Helper class for handling all bluetooth based events
	 */
	private class BPBroadcastReceiver extends BroadcastReceiver {
		@Override
		public void onReceive(Context context, Intent intent) {
			
			String action = intent.getAction();
			// logDbg( "Action: " + action );
			
			if ( BluetoothDevice.ACTION_FOUND.equals(action) ) {
				BluetoothDevice bluetoothDevice = 
						intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
				try {
					JSONObject deviceInfo = new JSONObject();
					boolean isBonded = false;
					isBonded = bluetoothDevice.getBondState() == BluetoothDevice.BOND_BONDED;
					deviceInfo.put("name", bluetoothDevice.getName());
					deviceInfo.put("address", bluetoothDevice.getAddress());
					deviceInfo.put("isBonded", isBonded);
					m_discoveredDevices.put(deviceInfo);
				} catch (JSONException e) {
					logErr(e.getMessage());
				}
			}
			else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {
				sendDiscoveredDevices(intent);
			}
			else if (BluetoothPlugin.ACTION_UUID.equals(action)) {
				m_gotUUIDs = new JSONArray();
				Parcelable[] parcelUuids = 
						intent.getParcelableArrayExtra(BluetoothPlugin.EXTRA_UUID);
				if (parcelUuids != null) {
					logDbg("Found UUIDs : " + parcelUuids.length);
					// Sort UUIDs into JSON array and return it
					for (int i = 0; i < parcelUuids.length; ++i) {
						m_gotUUIDs.put(parcelUuids[i].toString());
					}
					returnUUIDs(intent);
				}
			}
		}
	};
	
	/**
	 * Receives activity results
	 */
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		if (requestCode == this.REQUEST_CODE_ENABLE) 
		{
			if (resultCode == Activity.RESULT_OK)
				this.success(new PluginResult(PluginResult.Status.OK, true), 
						this.callback_enable);
			else if (resultCode == Activity.RESULT_CANCELED)
				this.success(new PluginResult(PluginResult.Status.ERROR), 
						this.callback_enable);
		}
		else if (requestCode == this.REQUEST_CODE_DISCOVERABLE)
		{
			if (resultCode == Activity.RESULT_CANCELED)
				this.success(new PluginResult(PluginResult.Status.ERROR), 
						this.callback_discoverable);
			else
				this.success(new PluginResult(PluginResult.Status.OK, resultCode), 
						this.callback_discoverable);
		}
	}
	

	

	/**
	 * bluetooth is not supported error
	 * @return immediate error returns
	 */
	private PluginResult action_support_error() {
		String msg = "Bluetooth is not supported !";
		logErr(msg);
		return new PluginResult(PluginResult.Status.ERROR, msg);
	}
	
	/**
	 * isSupported() function
	 * @return immediate result returns
	 */
	private PluginResult action_isSupported() {
		boolean b = m_bluetoothAdapter != null;
		return new PluginResult(PluginResult.Status.OK, b);
	}
	
	/**
	 * enable() function
	 * @return no result, result will async
	 */
	private PluginResult action_enable() {
		if ( ! m_bluetoothAdapter.isEnabled() )  {
			this.cordova.startActivityForResult(this, 
					new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), 
					this.REQUEST_CODE_ENABLE);
		}
		PluginResult result = new PluginResult(PluginResult.Status.NO_RESULT);
		result.setKeepCallback(true);
		return result;
	}
	
	/**
	 * disable() function
	 * @return immediate result returns
	 */
	private PluginResult action_disable() {
		PluginResult pluginResult;
		if ( ! m_bluetoothAdapter.disable() 
				&& ! ( m_bluetoothAdapter.getState() == BluetoothAdapter.STATE_TURNING_OFF
						|| m_bluetoothAdapter.getState() == BluetoothAdapter.STATE_OFF
					 ) ) {
			pluginResult = new PluginResult(PluginResult.Status.ERROR);
		} else {
			pluginResult = new PluginResult(PluginResult.Status.OK);
		}
		return pluginResult;
	}
	
	/**
	 * isEnabled() function
	 * @return immediate result returns
	 */
	private PluginResult action_isEnabled() {
		boolean b = m_bluetoothAdapter.isEnabled();
		return new PluginResult(PluginResult.Status.OK, b);
	}

	/**
	 * getAddress() function
	 * @return immediate result returns
	 */
	private PluginResult action_getAddress() {
		String address = m_bluetoothAdapter.getAddress();
		return new PluginResult(PluginResult.Status.OK, address);
	}
	
	/**
	 * getName() function
	 * @return immediate result returns
	 */
	private PluginResult action_getName() {
		String name = m_bluetoothAdapter.getName();
		return new PluginResult(PluginResult.Status.OK, name);
	}

	/**
	 * requestDiscoverable(int duration) function
	 * @param duration default 120, max 300 seconds
	 * @return no result, result will async
	 */
	private PluginResult action_requestDiscoverable(int duration) {
		Intent intent =new Intent(BluetoothAdapter.ACTION_REQUEST_DISCOVERABLE);
		intent.putExtra(BluetoothAdapter.EXTRA_DISCOVERABLE_DURATION, duration);
		this.cordova.startActivityForResult(
				this, intent, this.REQUEST_CODE_DISCOVERABLE);
		PluginResult pluginResult = 
				new PluginResult(PluginResult.Status.NO_RESULT);
		pluginResult.setKeepCallback(true);
		return pluginResult;
	}
	
	
	/**
	 * startDiscovery() function
	 * @return no result, result will async
	 */
	private PluginResult action_startDiscovery() {
		
		PluginResult pluginResult;
		m_discoveredDevices = new JSONArray();
		// be sure there are no ongoing discovery
		m_bluetoothAdapter.cancelDiscovery();
		if ( ! m_bluetoothAdapter.startDiscovery() ) {
			String msg = "Unable to start discovery";
			logErr(msg);
			pluginResult = new PluginResult(PluginResult.Status.ERROR, msg);
		} else {
			pluginResult = new PluginResult(PluginResult.Status.NO_RESULT);
			pluginResult.setKeepCallback(true);
		}
		return pluginResult;
	}
	
	/**
	 * cancelDiscovery() function
	 * @return immediate result returns
	 */
	private PluginResult action_cancelDiscovery() {
		if ( m_bluetoothAdapter.cancelDiscovery() )
			return new PluginResult(PluginResult.Status.OK);
		else
			return new PluginResult(PluginResult.Status.ERROR);
	}
	
	/**
	 * PluginResult helper function for discoveryDevices 
	 * @param intent
	 */
	public void sendDiscoveredDevices(Intent intent) {
		this.success(new PluginResult(PluginResult.Status.OK, 
				m_discoveredDevices), this.callback_discovery);
	}
	
	/**
	 * getBondedDevies() function
	 * @return
	 */
	private PluginResult action_getBondedDevices() {
		JSONArray bondedDevices = new JSONArray();
		Set<BluetoothDevice> bondSet = 
				m_bluetoothAdapter.getBondedDevices();
		for (Iterator<BluetoothDevice> it = bondSet.iterator(); it.hasNext();) {
			BluetoothDevice bluetoothDevice = (BluetoothDevice) it.next();
			JSONObject deviceInfo = new JSONObject();
			try {
				deviceInfo.put("name", bluetoothDevice.getName());
				deviceInfo.put("address", bluetoothDevice.getAddress());
				deviceInfo.put("isBonded", true);
			} catch (JSONException e) {
				logErr(e.toString() + " / " + e.getMessage());
			}
			bondedDevices.put(deviceInfo);
		}
		return new PluginResult(PluginResult.Status.OK, bondedDevices);
	}
	
	/**
	 * fetchUUIDs() function
	 * @param args
	 * @return
	 */
	@TargetApi(15)
	private PluginResult action_fetchUUIDs(String address) {
		
		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.ICE_CREAM_SANDWICH_MR1) {
			String msg = "Not supported, minimum SDK version is :" + 
					Build.VERSION_CODES.ICE_CREAM_SANDWICH_MR1;
			logErr(msg);
			return new PluginResult(PluginResult.Status.ERROR, msg);
		}
		PluginResult pluginResult;
		try {
			logDbg("Listing UUIDs for : " + address);
			// Fetch UUIDs from bluetooth device
			BluetoothDevice bluetoothDevice = 
					m_bluetoothAdapter.getRemoteDevice(address);
			// min api 15 !!!
			bluetoothDevice.fetchUuidsWithSdp();
			pluginResult = new PluginResult(PluginResult.Status.NO_RESULT);
			pluginResult.setKeepCallback(true);
		} catch (Exception e) {
			logErr(e.toString() + " / " + e.getMessage());
			pluginResult = new PluginResult(
					PluginResult.Status.IO_EXCEPTION, e.getMessage());
		}
		return pluginResult;
	}
	
	/**
	 * PluginResult helper function for returning UUIDs
	 * @param intent
	 */
	public void returnUUIDs(Intent intent) {
		this.success(new PluginResult(PluginResult.Status.OK, 
				m_gotUUIDs), this.callback_uuids);
	}
	
	/**
	 * connect() function
	 * @param address
	 * @param uuid
	 * @return
	 */
	private PluginResult action_connect(String address, UUID uuid, int connectionType) {
		BluetoothSocket bluetoothSocket = null;
		try {
			logDbg("Connecting...");
			// Cancel discovery because it will slow down the connection
			if(m_bluetoothAdapter.isDiscovering())
				m_bluetoothAdapter.cancelDiscovery();
			BluetoothDevice bluetoothDevice = 
					m_bluetoothAdapter.getRemoteDevice(address);
			
			if (connectionType == this.CONNECTION_SECURE) {
				bluetoothSocket = connectSecureHelper(bluetoothDevice, uuid);
			}
			else if (connectionType == this.CONNECTION_INSECURE) {
				bluetoothSocket = connectInsecureHelper(bluetoothDevice, uuid);
			}
			else {
				return new PluginResult(
						PluginResult.Status.ERROR, "Wrong connection type !");
			}
		} catch (Exception e) {
			logErr(e.toString() + " / " + e.getMessage());
			return new PluginResult(
					PluginResult.Status.IO_EXCEPTION, e.getMessage());
		}
		if(bluetoothSocket != null) {
			logDbg("Connected");
			m_bluetoothSockets.add(bluetoothSocket);
			int socketId = m_bluetoothSockets.indexOf(bluetoothSocket);
			return new PluginResult(PluginResult.Status.OK, socketId);
		}
		else {
			return new PluginResult(PluginResult.Status.ERROR);
		}
	}
	
	/**
	 * helper function
	 * @param device
	 * @param uuid
	 * @return
	 * @throws IOException
	 */
	private BluetoothSocket connectSecureHelper(
			BluetoothDevice device, UUID uuid) throws IOException {
		BluetoothSocket bluetoothSocket = 
				device.createRfcommSocketToServiceRecord(uuid);
		bluetoothSocket.connect();
		return bluetoothSocket;
	}
	
	/**
	 * helper function
	 * @param device
	 * @param uuid
	 * @return
	 * @throws IOException
	 */
	@TargetApi(10)
	private BluetoothSocket connectInsecureHelper(
			BluetoothDevice device, UUID uuid) throws IOException {
		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.GINGERBREAD_MR1) {
			String msg = "Not supported, minimum SDK version is :" + 
					Build.VERSION_CODES.GINGERBREAD_MR1;
			logErr(msg);
			return null;
		}
		BluetoothSocket bluetoothSocket = 
				device.createInsecureRfcommSocketToServiceRecord(uuid);
		bluetoothSocket.connect();
		return bluetoothSocket;
	}
	
	/**
	 * disconnect() function
	 * @param args
	 * @return
	 */
	private PluginResult action_disconnect(int socketId) {
		PluginResult pluginResult;
		try {
			// Fetch socket & close it
			BluetoothSocket socket = m_bluetoothSockets.get(socketId);
			logDbg("Close socket");
			socket.close();
			// Remove socket from internal list
			logDbg("Delete socket from list");
			m_bluetoothSockets.remove(socketId);
			// Everything went fine...
			pluginResult = new PluginResult(PluginResult.Status.OK);
		} catch (Exception e) {
			logErr(e.toString() + " / " + e.getMessage());
			pluginResult = new PluginResult(
					PluginResult.Status.IO_EXCEPTION, e.getMessage());
		}
		return pluginResult;
	}
	
	/**
	 * listen(name,uuid) function
	 * @param name service name for SDP record
	 * @param uuid uuid for SDP record
	 * @return no result, result will async
	 */
	private PluginResult action_listen(String name, String uuid) {
		
		// TODO : get  BluetoothServerSocket from listenUsingRfcommWithServiceRecord
		// TODO : create thread for incoming connections
		
		return new PluginResult(PluginResult.Status.NO_RESULT);
	}
	
	
	/**
	 * read() function
	 * @param args
	 * @return
	 */
	private PluginResult action_read(int socketId) {
		PluginResult pluginResult;
		try {
			BluetoothSocket socket = m_bluetoothSockets.get(socketId);
			InputStream inputStream = socket.getInputStream();

			byte[] buffer = new byte[1024];
			for (int i = 0; i < buffer.length; i++) {
				
				// TODO : move to thread
				buffer[i] = (byte) inputStream.read();
			}
			
			logDbg("Buffer: " + String.valueOf(buffer) );
			
			pluginResult = new PluginResult(PluginResult.Status.OK,
					String.valueOf(buffer));
		} catch (Exception e) {
			logErr(e.toString() + " / " + e.getMessage());
			pluginResult = new PluginResult(
					PluginResult.Status.IO_EXCEPTION, e.getMessage());
		}
		return pluginResult;
	}
	
	/**
	 * write() function
	 * @param socketId socket id
	 * @param jsonArray array that contains byte values
	 * @return
	 */
	private PluginResult action_write(int socketId, JSONArray jsonArray) {
		PluginResult pluginResult;
		try {
			BluetoothSocket socket = m_bluetoothSockets.get(socketId);
			OutputStream outputStream = socket.getOutputStream();
			
			byte[] buffer = new byte[jsonArray.length()];
			
			for (int i = 0; i < jsonArray.length(); i++) {
				buffer[i] = (byte) jsonArray.getInt(i);
			}
			// TODO : move to thread
			outputStream.write(buffer);
			
			pluginResult = new PluginResult(PluginResult.Status.OK);
		} catch (Exception e) {
			logErr(e.toString() + " / " + e.getMessage());
			pluginResult = new PluginResult(
					PluginResult.Status.IO_EXCEPTION, e.getMessage());
		}
		return pluginResult;
	}
	
	// helper log functions
	private void logDbg(String msg) {
		Log.d("BluetoothPlugin", msg);
	}
	
	private void logErr(String msg) {
		Log.e("BluetoothPlugin", msg);
	}
}
