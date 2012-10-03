/*
	    Copyright 2012 Bruno Carreira - Lucas Farias - Rafael Luna - Vinícius Fonseca. 

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
	 
package com.foregroundcameraplugin;

import org.apache.cordova.DroidGap;
import android.os.Bundle;

/** 
 * App class.
 * Opens index.html file to test the camera. *
 */
public class App extends DroidGap {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		super.loadUrl("file:///android_asset/www/index.html");
	}
}