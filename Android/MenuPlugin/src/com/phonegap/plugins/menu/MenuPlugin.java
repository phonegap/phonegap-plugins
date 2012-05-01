/**
 * 
 */
package com.phonegap.plugins.menu;


import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;
import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;

/**
 * @author Alex Michel amishel@gmail.com
 * 
 * Plugin displays native Android menu by inflating it from resources 
 * or/and adding menu items dynamically
 *         
 */
public class MenuPlugin extends Plugin
implements IMenuEventListener  {

	private final String pluginName = "MenuPlugin";
	private String _callbackId;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.phonegap.api.Plugin#execute(java.lang.String,
	 * org.json.JSONArray, java.lang.String)
	 */
	@Override
	public PluginResult execute(final String action, final JSONArray data, final String callBackId) {

		Log.d(pluginName, "Menu called with options: " + data + " ("+action+")");
		
		PluginResult result = null;
		_callbackId = callBackId;
		
		if(action.equals("RegisterOptionsMenu"))
		{
			OptionsMenuRequest request  = JSONToRequest(data, callBackId);
			
			if(request!=null)
			{
				DroidGapMenuWrapper.registerOptionsMenu(request, this);
				result = new PluginResult(PluginResult.Status.NO_RESULT);
				result.setKeepCallback(true);
			}
			else
			{
				result = new PluginResult(PluginResult.Status.ERROR);
			}
			
			return result;
		}
		else
		{
			return new PluginResult(PluginResult.Status.ERROR);
		}		
	}

	private OptionsMenuRequest JSONToRequest(JSONArray data, String callBackId)
	{		
		try {			
			JSONObject obj = data.getJSONObject(0);
			String layoutName = obj.getString("layoutName");
			Boolean isDynamic = obj.getBoolean("isDynamic");			
			
			JSONArray jsonItems = obj.getJSONArray("items"); 
			List<MenuItemRequest> items = new ArrayList<MenuItemRequest>();
			
			for(int i=0;i<jsonItems.length();i++)
			{
				JSONObject itemobj = jsonItems.getJSONObject(i);
				items.add(new MenuItemRequest(itemobj.getString("title"), itemobj.getString("icon")));				
			}
						
			OptionsMenuRequest request = new OptionsMenuRequest(layoutName, items, isDynamic);
			
			return request;

		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		}		
	}
	
	@Override
	public void onOptionsItemSelected(int id, String title) {		
		JSONObject eventArgs = new JSONObject();
		try {
			eventArgs.put("id", id);
			eventArgs.put("title", title);			
			
			PluginResult result = new PluginResult(PluginResult.Status.OK, eventArgs);
			result.setKeepCallback(true);
			this.success(result, _callbackId);
			
		} catch (JSONException e) {
			e.printStackTrace();
			this.error(new PluginResult(PluginResult.Status.JSON_EXCEPTION), _callbackId);
		}		
	}
}
