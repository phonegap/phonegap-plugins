package com.sina.phonegapoauth.weibosdkexample;

import org.apache.cordova.DroidGap;

import android.os.Bundle;
import com.sina.phonegapoauth.weibosdkexample.R;

public class MainActivity extends DroidGap {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		super.loadUrl("file:///android_asset/www/index.html");
	}

}
