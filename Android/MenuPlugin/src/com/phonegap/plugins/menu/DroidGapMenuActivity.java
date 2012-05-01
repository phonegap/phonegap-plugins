package com.phonegap.plugins.menu;

import org.apache.cordova.DroidGap;

import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

public class DroidGapMenuActivity extends DroidGap {
	
	 private DroidGapMenuWrapper _wrapper = null;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		_wrapper = new DroidGapMenuWrapper(this);		  
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		return _wrapper.onCreateOptionsMenu(menu);
	}
	
	@Override
	public boolean onPrepareOptionsMenu(Menu menu) {
		return _wrapper.onPrepareOptionsMenu(menu);
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		return _wrapper.onOptionsItemSelected(item);
	}
}