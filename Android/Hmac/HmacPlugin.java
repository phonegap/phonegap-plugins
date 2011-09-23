/* Copyright (c) 2011 - Zitec COM
 * 
 * @author: Ionut Voda <ionut.voda@zitec.ro>
 */
package com.phonegap.plugin.hmac;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Base64;
import android.util.Log;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import com.phonegap.api.PluginResult.Status;

/**
 * @author Ionut Voda <ionut.voda@zitec.ro>
 * @category Plugin
 */
public class HmacPlugin extends Plugin {

	/* 
	 * (non-Javadoc)
	 * @see com.phonegap.api.Plugin#execute(java.lang.String, org.json.JSONArray, java.lang.String)
	 * @see http://download.oracle.com/javase/1.4.2/docs/guide/security/jce/JCERefGuide.html#AppA for 
	 * a complete Mac class reference
	 * 
	 * @param String hashingMethod indicates the hashing method: sha1, md5, etc
	 * @param JSONArray hashParams contains the string to be hashed and the hash key
	 * @param String callback
	 * @return PluginResult
	 */
	@Override
	public PluginResult execute(String hashingMethod, JSONArray hashParams, String callbackId) {
		// intialize internal vars
		String stringToHash = null;
		String hashKey = null;
		PluginResult result = null;
		String hashedString = null;
		
		// read the params
		try {
			stringToHash = hashParams.getString(0);
			hashKey = hashParams.getString(1);
		} catch (JSONException jsonEx) {
			Log.d("HmacPlugin", "JSON Exception " + jsonEx.getMessage());
			result = new PluginResult(Status.JSON_EXCEPTION);
		}
		
		// hash the string
		try {
			hashedString = hasher(hashingMethod, stringToHash, hashKey);
		} catch (InvalidKeyException e) {
			Log.d("HmacPlugin", "InvalidKeyException " + e.getMessage());
			result = new PluginResult(Status.ILLEGAL_ACCESS_EXCEPTION);
		} catch (UnsupportedEncodingException e) {
			Log.d("HmacPlugin", "UnsupportedEncodingException " + e.getMessage());
			result = new PluginResult(Status.ILLEGAL_ACCESS_EXCEPTION);
		} catch (NoSuchAlgorithmException e) {
			Log.d("HmacPlugin", "NoSuchAlgorithmException " + e.getMessage());
			result = new PluginResult(Status.ILLEGAL_ACCESS_EXCEPTION);
		}
		
		// prepare the response as JSON
		if (hashedString != null) {
			JSONObject JSONresult = new JSONObject();
			try {
				JSONresult.put("hash", hashedString);
			} catch (JSONException jsonEx) {
				Log.d("HmacPlugin", "JSON Exception " + jsonEx.getMessage());
				result = new PluginResult(Status.JSON_EXCEPTION);
			}
			result = new PluginResult(Status.OK, JSONresult);
		}
		
		return result;
	}
	
	/**
	 * Method in charge with generating the actual hash
	 * 
	 * @param String hashingMethod md5/sha1
	 * @param String stringToHash
	 * @param String hashKey
	 * @return String
	 */
	protected String hasher(String hashingMethod, String stringToHash, String hashKey) 
		throws UnsupportedEncodingException, NoSuchAlgorithmException, InvalidKeyException {
		
		String keyGenerator = "HmacMD5";
		if(hashingMethod.equals(new String("sha1"))) {
			keyGenerator = "HmacSHA1";
		}
		else if (hashingMethod.equals(new String("md5"))) {
			keyGenerator = "HmacMD5";
		}
		
		SecretKeySpec key = new SecretKeySpec((hashKey).getBytes("UTF-8"), keyGenerator);
		Mac hmac = Mac.getInstance(keyGenerator);
		hmac.init(key);

		byte[] bytes = hmac.doFinal(stringToHash.getBytes("UTF-8"));
		return new String(Base64.encode(bytes, Base64.NO_WRAP));
	}

}
