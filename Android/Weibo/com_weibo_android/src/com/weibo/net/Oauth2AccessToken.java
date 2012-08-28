/*
 * Copyright 2011 Sina.
 *
 * Licensed under the Apache License and Weibo License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.open.weibo.com
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.weibo.net;

import org.json.JSONException;
import org.json.JSONObject;


/**
 * An AcessToken class contains accesstoken and tokensecret.Child class of com.weibo.net.Token.
 * 
 * @author  ZhangJie (zhangjie2@staff.sina.com.cn)
 */
public class Oauth2AccessToken extends Token {
	
	public Oauth2AccessToken(String rltString){
	 // { "access_token":"SlAV32hkKG", "expires_in":3600, "refresh_token":"8xLOxBtZp8" } 
	    if(rltString != null){
	        if(rltString.indexOf("{") >= 0){
	            try {
	                JSONObject json = new JSONObject(rltString);
	                setToken(json.optString("access_token"));
	                setExpiresIn(json.optInt("expires_in"));
	                setRefreshToken(json.optString("refresh_token"));
	            } catch (JSONException e) {
	                //不处理
	            }
	        }
	    }
	}
	
	public Oauth2AccessToken(String token , String secret){
		super(token, secret);
	}
}