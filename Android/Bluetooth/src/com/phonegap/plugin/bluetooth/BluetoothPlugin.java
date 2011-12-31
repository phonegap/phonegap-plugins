/* Copyright (c) 2011 - Andago
 * 
 * author: Daniel Tizón, Idoia Olalde, Iñigo González
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

package com.phonegap.plugin.bluetooth;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Set;
import org.json.JSONArray;
import android.net.ConnectivityManager;
import android.os.Looper;
import android.util.Log;
import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import com.phonegap.api.PluginResult.Status;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;



public class BluetoothPlugin extends Plugin {

	public static final String ACTION_DISCOVER_DEVICES="listDevices";
	public static final String ACTION_LIST_BOUND_DEVICES="listBoundDevices";
	public static final String ACTION_IS_BT_ENABLED="isBTEnabled";
	public static final String ACTION_ENABLE_BT="enableBT";
	public static final String ACTION_DISABLE_BT="disableBT";
	public static final String ACTION_PAIR_BT="pairBT";
	public static final String ACTION_UNPAIR_BT="unPairBT";
	public static final String ACTION_STOP_DISCOVERING_BT="stopDiscovering";
	public static final String ACTION_IS_BOUND_BT="isBound";
	private static BluetoothAdapter btadapter;	
	private ArrayList<BluetoothDevice> found_devices;
	private boolean discovering=false;
	private Context context;
	
	/* (non-Javadoc)
	 * @see com.phonegap.api.Plugin#execute(java.lang.String, org.json.JSONArray, java.lang.String)
	 */
	@Override
	public PluginResult execute(String action, JSONArray arg1, String callbackId) {
		Log.d("BluetoothPlugin", "Plugin Called");
		PluginResult result = null;
		context = this.ctx;
		
		 // Register for broadcasts when a device is discovered
       IntentFilter filter = new IntentFilter(BluetoothDevice.ACTION_FOUND);
       context.registerReceiver(mReceiver, filter);
       
       
       // Register for broadcasts when discovery starts
       filter = new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_STARTED);
       context.registerReceiver(mReceiver, filter);

       
       // Register for broadcasts when discovery has finished
       filter = new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
       context.registerReceiver(mReceiver, filter);  
       
              
       // Register for broadcasts when connectivity state changes
       filter = new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION);
       context.registerReceiver(mReceiver, filter);  
       
              
		Looper.prepare();
		btadapter= BluetoothAdapter.getDefaultAdapter();
		found_devices=new ArrayList<BluetoothDevice>(); 
		
		
		
		
		if (ACTION_DISCOVER_DEVICES.equals(action)) {
			try {
				
				Log.d("BluetoothPlugin", "We're in "+ACTION_DISCOVER_DEVICES);
				
				found_devices.clear();
				discovering=true;
				
		        if (btadapter.isDiscovering()) {
		        	btadapter.cancelDiscovery();
		        }
		        
		        Log.i("BluetoothPlugin","Discovering devices...");        
				btadapter.startDiscovery();		
				
				while (discovering){}
				
				String devicesFound=null;
				int count=0;
				devicesFound="[";
				for (BluetoothDevice device : found_devices) {
					Log.i("BluetoothPlugin",device.getName() + " "+device.getAddress()+" "+device.getBondState());
				   if ((device.getName()!=null) && (device.getBluetoothClass()!=null)){
					   devicesFound = devicesFound + " { \"name\" : \"" + device.getName() + "\" ," +
					   		"\"address\" : \"" + device.getAddress() + "\" ," +
							"\"class\" : \"" + device.getBluetoothClass().getDeviceClass() + "\" }";
					   if (count<found_devices.size()-1) devicesFound = devicesFound + ",";
				   }else Log.i("BluetoothPlugin",device.getName() + " Problems retrieving attributes. Device not added ");
				   count++;
				}	
				
				devicesFound= devicesFound + "] ";				
				
				Log.d("BluetoothPlugin - "+ACTION_DISCOVER_DEVICES, "Returning: "+ devicesFound);
				result = new PluginResult(Status.OK, devicesFound);
			} catch (Exception Ex) {
				Log.d("BluetoothPlugin - "+ACTION_DISCOVER_DEVICES, "Got Exception "+ Ex.getMessage());
				result = new PluginResult(Status.ERROR);
			}
			
			
			
			
			
		} else 	if (ACTION_IS_BT_ENABLED.equals(action)) {
			try {							
				Log.d("BluetoothPlugin", "We're in "+ACTION_IS_BT_ENABLED);
				
				boolean isEnabled = btadapter.isEnabled();
				
				Log.d("BluetoothPlugin - "+ACTION_IS_BT_ENABLED, "Returning "+ "is Bluetooth Enabled? "+isEnabled);
				result = new PluginResult(Status.OK, isEnabled);
			} catch (Exception Ex) {
				Log.d("BluetoothPlugin - "+ACTION_IS_BT_ENABLED, "Got Exception "+ Ex.getMessage());
				result = new PluginResult(Status.ERROR);
			}
		
			
			
			
			
		} else 	if (ACTION_ENABLE_BT.equals(action)) {
			try {							
				Log.d("BluetoothPlugin", "We're in "+ACTION_ENABLE_BT);
				
				boolean enabled = false;
				
				Log.d("BluetoothPlugin", "Enabling Bluetooth...");
				
				if (btadapter.isEnabled())
				{
				  enabled = true;
				} else {
				  enabled = btadapter.enable();
				}

				
				Log.d("BluetoothPlugin - "+ACTION_ENABLE_BT, "Returning "+ "Result: "+enabled);
				result = new PluginResult(Status.OK, enabled);
			} catch (Exception Ex) {
				Log.d("BluetoothPlugin - "+ACTION_ENABLE_BT, "Got Exception "+ Ex.getMessage());
				result = new PluginResult(Status.ERROR);
			}
			
			
			
			
			
		} else 	if (ACTION_DISABLE_BT.equals(action)) {
			try {							
				Log.d("BluetoothPlugin", "We're in "+ACTION_DISABLE_BT);
				
				boolean disabled = false;
				
				Log.d("BluetoothPlugin", "Disabling Bluetooth...");
				
				if (btadapter.isEnabled())
				{
					disabled = btadapter.disable();
				} else {
					disabled = true;
				}				
								
				Log.d("BluetoothPlugin - "+ACTION_DISABLE_BT, "Returning "+ "Result: "+disabled);
				result = new PluginResult(Status.OK, disabled);
			} catch (Exception Ex) {
				Log.d("BluetoothPlugin - "+ACTION_DISABLE_BT, "Got Exception "+ Ex.getMessage());
				result = new PluginResult(Status.ERROR);
			}
			
			
			
			
						
		} else 	if (ACTION_PAIR_BT.equals(action)) {
			try {							
				Log.d("BluetoothPlugin", "We're in "+ACTION_PAIR_BT);
				
				String addressDevice = arg1.getString(0);
				
				if (btadapter.isDiscovering()) {
		        	btadapter.cancelDiscovery();
		        }

				BluetoothDevice device = btadapter.getRemoteDevice(addressDevice);
				boolean paired = false;
							
				Log.d("BluetoothPlugin","Pairing with Bluetooth device with name " + device.getName()+" and address "+device.getAddress());
		          	
				try {
					Method m = device.getClass().getMethod("createBond");
					paired = (Boolean) m.invoke(device);					
				} catch (Exception e) 
				{
					e.printStackTrace();
				}  
				
				
				Log.d("BluetoothPlugin - "+ACTION_PAIR_BT, "Returning "+ "Result: "+paired);
				result = new PluginResult(Status.OK, paired);
			} catch (Exception Ex) {
				Log.d("BluetoothPlugin - "+ACTION_PAIR_BT, "Got Exception "+ Ex.getMessage());
				result = new PluginResult(Status.ERROR);
			}
			
			
			
			
						
		} else 	if (ACTION_UNPAIR_BT.equals(action)) {
			try {							
				Log.d("BluetoothPlugin", "We're in "+ACTION_UNPAIR_BT);
				
				String addressDevice = arg1.getString(0);
				
				if (btadapter.isDiscovering()) {
		        	btadapter.cancelDiscovery();
		        }

				BluetoothDevice device = btadapter.getRemoteDevice(addressDevice);
				boolean unpaired = false;
							
				Log.d("BluetoothPlugin","Unpairing Bluetooth device with " + device.getName()+" and address "+device.getAddress());
		          	
				try {
					Method m = device.getClass().getMethod("removeBond");
					unpaired = (Boolean) m.invoke(device);					
				} catch (Exception e) 
				{
					e.printStackTrace();
				}  
				
				
				Log.d("BluetoothPlugin - "+ACTION_UNPAIR_BT, "Returning "+ "Result: "+unpaired);
				result = new PluginResult(Status.OK, unpaired);
			} catch (Exception Ex) {
				Log.d("BluetoothPlugin - "+ACTION_UNPAIR_BT, "Got Exception "+ Ex.getMessage());
				result = new PluginResult(Status.ERROR);
			}
			
			
			
			
						
		} else 	if (ACTION_LIST_BOUND_DEVICES.equals(action)) {
			try {							
				Log.d("BluetoothPlugin", "We're in "+ACTION_LIST_BOUND_DEVICES);
				
				Log.d("BluetoothPlugin","Getting paired devices...");
				Set<BluetoothDevice> pairedDevices = btadapter.getBondedDevices();
				int count =0;	
				String resultBoundDevices="[ ";
				if (pairedDevices.size() > 0) {					
					for (BluetoothDevice device : pairedDevices) 
					{						
						Log.i("BluetoothPlugin",device.getName() + " "+device.getAddress()+" "+device.getBondState());
						
						if ((device.getName()!=null) && (device.getBluetoothClass()!=null)){
							resultBoundDevices = resultBoundDevices + " { \"name\" : \"" + device.getName() + "\" ," +
				   				"\"address\" : \"" + device.getAddress() + "\" ," +
				   				"\"class\" : \"" + device.getBluetoothClass().getDeviceClass() + "\" }";
							 if (count<pairedDevices.size()-1) resultBoundDevices = resultBoundDevices + ",";					   
						} else Log.i("BluetoothPlugin",device.getName() + " Problems retrieving attributes. Device not added ");
						 count++;
					 }			    
					
				}
				
				resultBoundDevices= resultBoundDevices + "] ";
				
				Log.d("BluetoothPlugin - "+ACTION_LIST_BOUND_DEVICES, "Returning "+ resultBoundDevices);
				result = new PluginResult(Status.OK, resultBoundDevices);
				
			} catch (Exception Ex) {
				Log.d("BluetoothPlugin - "+ACTION_LIST_BOUND_DEVICES, "Got Exception "+ Ex.getMessage());
				result = new PluginResult(Status.ERROR);
			}	
			
			
			
			
			
		} else 	if (ACTION_STOP_DISCOVERING_BT.equals(action)) {
			try {							
				Log.d("BluetoothPlugin", "We're in "+ACTION_STOP_DISCOVERING_BT);
				
				boolean stopped = true;
				
				Log.d("BluetoothPlugin", "Stop Discovering Bluetooth Devices...");
				
				if (btadapter.isDiscovering())
				{
					Log.i("BluetoothPlugin","Stop discovery...");	
					stopped = btadapter.cancelDiscovery();
		        	discovering=false;
				}				
				
			
				Log.d("BluetoothPlugin - "+ACTION_STOP_DISCOVERING_BT, "Returning "+ "Result: "+stopped);
				result = new PluginResult(Status.OK, stopped);
			} catch (Exception Ex) {
				Log.d("BluetoothPlugin - "+ACTION_STOP_DISCOVERING_BT, "Got Exception "+ Ex.getMessage());
				result = new PluginResult(Status.ERROR);
			}
			
			
			
			
			
		} else 	if (ACTION_IS_BOUND_BT.equals(action)) {
			try {							
				Log.d("BluetoothPlugin", "We're in "+ACTION_IS_BOUND_BT);
				String addressDevice = arg1.getString(0);
				BluetoothDevice device = btadapter.getRemoteDevice(addressDevice);
				Log.i("BluetoothPlugin","BT Device in state "+device.getBondState());	
				
				boolean state = false;
				
				if (device!=null && device.getBondState()==12) 
					state =  true;
				else
					state = false;
				
				Log.d("BluetoothPlugin","Is Bound with " + device.getName()+" - address "+device.getAddress());
		          				
				
				Log.d("BluetoothPlugin - "+ACTION_IS_BOUND_BT, "Returning "+ "Result: "+state);
				result = new PluginResult(Status.OK, state);
				
				
			} catch (Exception Ex) {
				Log.d("BluetoothPlugin - "+ACTION_IS_BOUND_BT, "Got Exception "+ Ex.getMessage());
				result = new PluginResult(Status.ERROR);
			}
			
			
			
		
		
		} else {
			result = new PluginResult(Status.INVALID_ACTION);
			Log.d("BluetoothPlugin", "Invalid action : "+action+" passed");
		}
		return result;
	}
	
	
	
	
	public void setDiscovering(boolean state){
		discovering=state;
	}

	
	
	public void addDevice(BluetoothDevice device){		
		if (!found_devices.contains(device))
		{
			Log.i("BluetoothPlugin","Device stored ");
			found_devices.add(device);
		}
	}
	
	
	
    @Override
	public void onDestroy() {
		// TODO Auto-generated method stub
    	Log.i("BluetoothPlugin","onDestroy "+this.getClass());
    	context.unregisterReceiver(mReceiver);
    	super.onDestroy();
	}
	
	
    
    /** BroadcastReceiver to receive bluetooth events */    
	private final BroadcastReceiver mReceiver = new BroadcastReceiver() {
	    public void onReceive(Context context, Intent intent) 
	    {
	    	
	        String action = intent.getAction();
	        Log.i("BluetoothPlugin","Action: "+action);
	        
	        // When discovery finds a device	        
	        if (BluetoothDevice.ACTION_FOUND.equals(action)) 
	        {	        	
	            // Get the BluetoothDevice object from the Intent
	            BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
	            Log.i("BluetoothPlugin","Device found "+device.getName()+ " "+device.getBondState()+" " + device.getAddress());
	       
	            if (device.getBondState() != BluetoothDevice.BOND_BONDED) {	
	            	Log.i("BluetoothPlugin","Device not paired");
	            	addDevice(device);
	            }else Log.i("BluetoothPlugin","Device already paired");	         
	         
	        // When discovery starts	
	        }else if (BluetoothAdapter.ACTION_DISCOVERY_STARTED.equals(action)) {
	        	
	        	Log.i("BluetoothPlugin","Discovery started");
	        	setDiscovering(true);
	        	
	        // When discovery finishes	
            }else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {
            	
            	Log.i("BluetoothPlugin","Discovery finilized");
            	setDiscovering(false); 	   
	
            }
	    }
    };

}
