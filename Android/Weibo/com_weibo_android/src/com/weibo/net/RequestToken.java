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
 * A RequestToken class contains oauth_token and oauth_secret. Child class of com.weibo.net.Token.
 * 
 * @author  ZhangJie (zhangjie2@staff.sina.com.cn)
 */


public class RequestToken extends Token {
	
	
	public RequestToken(String authResult){
		super(authResult);
	}
	
	
}
