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

import java.util.ArrayList;
import java.util.List;

import android.os.Bundle;


/**
 * A list queue for saving keys and values.
 * Using it to construct http header or get/post parameters.
 *
 * @author  ZhangJie (zhangjie2@staff.sina.com.cn)
 */
public class WeiboParameters {

	private Bundle mParameters = new Bundle();
	private List<String> mKeys = new ArrayList<String>();
	
	
	public WeiboParameters(){
		
	}
	
	
	public void add(String key, String value){
		if(this.mKeys.contains(key)){	
			this.mParameters.putString(key, value);
		}else{
			this.mKeys.add(key);
			this.mParameters.putString(key, value);
		}
	}
	
	
	public void remove(String key){
		mKeys.remove(key);
		this.mParameters.remove(key);
	}
	
	public void remove(int i){
		String key = this.mKeys.get(i);
		this.mParameters.remove(key);
		mKeys.remove(key);
	}
	
	
	public int getLocation(String key){
		if(this.mKeys.contains(key)){
			return this.mKeys.indexOf(key);
		}
		return -1;
	}
	
	public String getKey(int location){
		if(location >= 0 && location < this.mKeys.size()){
			return this.mKeys.get(location);
		}
		return "";
	}
	
	
	public String getValue(String key){
		String rlt = this.mParameters.getString(key);
		return rlt;
	}
	
	public String getValue(int location){
		String key = this.mKeys.get(location);
		String rlt = this.mParameters.getString(key);
		return rlt;
	}
	
	
	public int size(){
		return mKeys.size();
	}
	
	public void addAll(WeiboParameters parameters){
		for(int i = 0; i < parameters.size(); i++){
			this.add(parameters.getKey(i), parameters.getValue(i));
		}
		
	}
	
	public void clear(){
		this.mKeys.clear();
		this.mParameters.clear();
	}
	
}
