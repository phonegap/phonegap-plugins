package com.phonegap.plugins.menu;

import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;

public class DroidGapMenuWrapper 
{
	
	private DroidGapMenuActivity _callerActivity = null; 
	private static OptionsMenuRequest _optionsMenuRequest = null;
	private static IMenuEventListener _menuEventListener = null;
	
	public DroidGapMenuWrapper(DroidGapMenuActivity activity)
	{
		_callerActivity = activity;
	}
	
	public synchronized static void registerOptionsMenu(OptionsMenuRequest request,IMenuEventListener eventListener)
	{
		_optionsMenuRequest = request;	
		_menuEventListener = eventListener;
	}
	
	public synchronized boolean onCreateOptionsMenu(Menu menu) {
		if(_optionsMenuRequest!=null && !_optionsMenuRequest.get_isDynamic())
		{
			populateMenu(menu);
		}		
		return true;    
	}
		
	public synchronized boolean onPrepareOptionsMenu(Menu menu) {
		if(_optionsMenuRequest!=null && _optionsMenuRequest.get_isDynamic())
		{
			menu.clear();
			populateMenu(menu);
		}
		return true;
	}
		
	public synchronized boolean onOptionsItemSelected(MenuItem item) {		
		if(_menuEventListener!=null)
			_menuEventListener.onOptionsItemSelected(item.getItemId(), item.getTitleCondensed ().toString());		
		return true;
	}
	
	
	private void populateMenu(Menu menu)
	{		
		String layout = _optionsMenuRequest.get_layoutName();
		if(!layout.isEmpty())
			inflate(layout,menu);
		
		if(_optionsMenuRequest.get_items()!=null)
			for(int i=0;i<_optionsMenuRequest.get_items().size();i++)
				addMenuItem(_optionsMenuRequest.get_items().get(i), menu);				
	}
		
	private void inflate(String layout,Menu menu)
	{
		 MenuInflater inflater = _callerActivity.getMenuInflater();       
	     inflater.inflate(getLayoutByName(layout), menu);	     
	}
	
	private void addMenuItem(MenuItemRequest request,Menu menu)
	{
		 MenuItem m = menu.add(0,menu.size(),0,request.get_title());
		 if(!request.get_icon().isEmpty())
			 m.setIcon(getDrawableByName(request.get_icon()));	        
	}
	
	private int getResourceByName(String name,String type)
	{
		return _callerActivity.getResources().getIdentifier(name, type, _callerActivity.getPackageName());
	}
	
	private int getLayoutByName(String name)
	{
		return getResourceByName(name, "layout");
	}
	
	private int getDrawableByName(String name)
	{
		return getResourceByName(name, "drawable");
	}		
}