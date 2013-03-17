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




/**
 * Encapsulation a http accessToken headers. the order of weiboParameters will not be changed.
 * Otherwise the signature should not be calculated right.

 * @author  ZhangJie (zhangjie2@staff.sina.com.cn)
 */
public class Oauth2AccessTokenHeader extends HttpHeaderFactory {

    @Override
    public String getWeiboAuthHeader(String method, String url, WeiboParameters params,
            String app_key, String app_secret, Token token) throws WeiboException {
        if(token == null){
            return null;
        }
        return "OAuth2 " + token.getToken();
        
    }
	@Override
	public WeiboParameters generateSignatureList(WeiboParameters bundle) {
	    return null;
	}

	@Override
	public String generateSignature(String data, Token token) throws WeiboException{
		return "";
	}

	@Override
	public void addAdditionalParams(WeiboParameters des, WeiboParameters src) {
		// TODO Auto-generated method stub
		
	}

}
