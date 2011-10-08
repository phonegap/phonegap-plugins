package ca.christophersaunders.shopgap;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import com.phonegap.api.PluginResult.Status;
import com.shopify.api.client.ShopifyClient;
import com.shopify.api.credentials.Credential;
import com.shopify.api.endpoints.JsonPipeService;

public class ShopGapPlugin extends Plugin {
	private static final String API_KEY = "apikey";
	private static final String PASSWORD = "password";
	private static final String SHOPNAME = "shopname";
	private static final String CALL = "call";
	private static final String ENDPOINT = "endpoint";
	private static final String QUERY = "query";
	private static final String DATA = "data";
	
	private ShopifyClient client;
	private JsonPipeService service;
	
	enum Methods { CALL_API, SETUP };
	enum Call   { READ, CREATE, UPDATE, DESTROY };

	@Override
	public PluginResult execute(String func, JSONArray arguments, String callbackId) {
		try {
			JSONObject argsMap = arguments.getJSONObject(0);
			switch(determineMethod(func)) {
			case CALL_API:
				JSONObject results = callAPI(determineCall(argsMap.getString(CALL)), argsMap);
				return new PluginResult(Status.OK, results);
			case SETUP:
				if(setupClient(argsMap)) {
					return new PluginResult(Status.OK);
				}
				break;
			default:
				return new PluginResult(PluginResult.Status.INVALID_ACTION);
			}
		} catch (JSONException e) {
			// Trololololololo
			return new PluginResult(PluginResult.Status.JSON_EXCEPTION);
		}
		return null;
	}
	
	private Methods determineMethod(String name){
		if(name.equals("callapi"))
			return Methods.CALL_API;
		if(name.equals("setup"))
			return Methods.SETUP;
		return null;
	}
	
	private Call determineCall(String callname) {
		if(callname.equals("read"))
			return Call.READ;
		if (callname.equals("update"))
			return Call.UPDATE;
		if (callname.equals("create"))
			return Call.CREATE;
		if (callname.equals("destroy"))
			return Call.DESTROY;
		return null;
	}
	
	private boolean setupClient(JSONObject args) throws JSONException {
		if (args.has(API_KEY) && args.has(PASSWORD) && args.has(SHOPNAME)) {
			String apiKey = args.getString(API_KEY);
			String passwd = args.getString(PASSWORD);
			String shop   = args.getString(SHOPNAME);
			
			Credential cred = new Credential(apiKey, "", shop, passwd);
			client = new ShopifyClient(cred);
			service = client.constructService(JsonPipeService.class);
			return true;
		}
		return false;
	}
	
	private JSONObject callAPI(Call call, JSONObject args) {
		try {
			String endpoint = null, data = null, query = null;
			if(args.has(ENDPOINT))
				endpoint = args.getString(ENDPOINT);
			if(args.has(QUERY))
				query = args.getString(QUERY);
			if(args.has(DATA))
				data = args.getString(DATA);
			
			InputStream result = null;
			
			switch(call) {
			case CREATE:
				result = service.create(endpoint, data);
				break;
			case READ:
				result = service.read(endpoint);
				break;
			case UPDATE:
				result = service.update(endpoint, data);
				break;
			case DESTROY:
				result = service.destroy(endpoint);
				break;
			}
			
			if( result != null) {
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				BufferedInputStream bis = new BufferedInputStream(result);
				byte[] resultData = new byte[0x4000];
				int dataRead = 0;
				while((dataRead = bis.read(resultData)) > 0) {
					baos.write(resultData, 0, dataRead);
				}
				return new JSONObject(new String(baos.toByteArray()));
			}
			
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return new JSONObject();
	}

}
