/**
 * ZeroConf plugin for Cordova/Phonegap
 *
 * @author Matt Kane
 * Copyright (c) Triggertrap Ltd. 2012. All Rights Reserved.
 * Available under the terms of the MIT License.
 * 
 */

package com.triggertrap;

import java.io.IOException;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.api.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.net.wifi.WifiManager;
import android.util.Log;

import javax.jmdns.JmDNS;
import javax.jmdns.ServiceEvent;
import javax.jmdns.ServiceInfo;
import javax.jmdns.ServiceListener;

public class ZeroConf extends Plugin {
	WifiManager.MulticastLock lock;
    private JmDNS jmdns = null;
    private ServiceListener listener;
    private String callback;
    
	@Override
	public PluginResult execute(String action, JSONArray args, String callbackId) {
        this.callback = callbackId;

        if (action.equals("watch")) {
            String type = args.optString(0);
            if (type != null) {
            	watch(type);
            } else {
                return new PluginResult(PluginResult.Status.ERROR, "Service type not specified");
            }
        } else if (action.equals("unwatch")) {
            String type = args.optString(0);
            if (type != null) {
            	unwatch(type);
            } else {
                return new PluginResult(PluginResult.Status.ERROR, "Service type not specified");
            }
        } else if (action.equals("register")) {
            JSONObject obj = args.optJSONObject(0);
            if (obj != null) {
            	String type = obj.optString("type");
            	String name = obj.optString("name");
            	int port = obj.optInt("port");
            	String text = obj.optString("text");
            	if(type == null) {
            		return new PluginResult(PluginResult.Status.ERROR, "Missing required service info");
            	}
            	register(type, name, port, text);
            } else {
                return new PluginResult(PluginResult.Status.ERROR, "Missing required service info");
            }
        	
        } else if (action.equals("close")) { 
        	if(jmdns != null) {
        		try {
					jmdns.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
        	}
        }  else if (action.equals("unregister")) {
        	if(jmdns != null) {
        		jmdns.unregisterAllServices();
        	}
        	
        } else {
        	Log.e("ZeroConf", "Invalid action: " + action);
            return new PluginResult(PluginResult.Status.INVALID_ACTION);
        }
		PluginResult result = new PluginResult(Status.NO_RESULT);
		result.setKeepCallback(true);
		return result;
	}

	private void watch(String type) {
		if(jmdns == null) {
			setupWatcher();
		}
    	Log.d("ZeroConf", "Watch " + type);
    	Log.d("ZeroConf", "Name: " + jmdns.getName() + " host: " + jmdns.getHostName());
        jmdns.addServiceListener(type, listener);
	}
	private void unwatch(String type) {
		if(jmdns == null) {
			return;
		}
        jmdns.removeServiceListener(type, listener);
	}

	private void register (String type, String name, int port, String text) {
		if(name == null) {
			name = "";
		}
		
		if(text == null) {
			text = "";
		}
		
		 try {
			 ServiceInfo service = ServiceInfo.create(type, name, port, text);
			jmdns.registerService(service);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private void setupWatcher() {
    	Log.d("ZeroConf", "Setup watcher");
         WifiManager wifi = (WifiManager) this.cordova.getActivity().getSystemService(android.content.Context.WIFI_SERVICE);
        lock = wifi.createMulticastLock("ZeroConfPluginLock");
        lock.setReferenceCounted(true);
        lock.acquire();
        try {
            jmdns = JmDNS.create();
            listener = new ServiceListener() {

                public void serviceResolved(ServiceEvent ev) {
                	Log.d("ZeroConf", "Resolved");

                    sendCallback("added", ev.getInfo());
                }

                public void serviceRemoved(ServiceEvent ev) {
                	Log.d("ZeroConf", "Removed");

                    sendCallback("removed", ev.getInfo());
                }

                public void serviceAdded(ServiceEvent event) {
                	Log.d("ZeroConf", "Added");
 
                    // Force serviceResolved to be called again
                    jmdns.requestServiceInfo(event.getType(), event.getName(), 1);
                }
            };

        } catch (IOException e) {
            e.printStackTrace();
            return;
        }
	}
	
	public void sendCallback(String action, ServiceInfo info) {
		JSONObject status = new JSONObject();
		try {
			status.put("action", action);
			status.put("service", jsonifyService(info));
	    	Log.d("ZeroConf", "Sending result: " + status.toString());

			PluginResult result = new PluginResult(PluginResult.Status.OK, status);
			result.setKeepCallback(true);
			this.success(result, this.callback);

		} catch (JSONException e) {

			e.printStackTrace();
		}
		

	}
	
	
	public static JSONObject jsonifyService(ServiceInfo info) {
		JSONObject obj = new JSONObject();
		try {
			obj.put("application", info.getApplication());
			obj.put("domain", info.getDomain());
			obj.put("port", info.getPort());
			obj.put("name", info.getName());
			obj.put("server", info.getServer());
			obj.put("description", info.getNiceTextString());
			obj.put("protocol", info.getProtocol());
			obj.put("qualifiedname", info.getQualifiedName());
			obj.put("type", info.getType());

			JSONArray addresses = new JSONArray();
			String[] add = info.getHostAddresses();
			for(int i = 0; i < add.length; i++) {
				addresses.put(add[i]);
			}
			obj.put("addresses", addresses);
			JSONArray urls = new JSONArray();

			String[] url = info.getURLs();
			for(int i = 0; i < url.length; i++) {
				urls.put(url[i]);
			}
			obj.put("urls", urls);

		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		}
		
		return obj;
		
	}
	
}
