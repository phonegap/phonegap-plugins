package com.phonegap.plugins.menu;

public class MenuItemRequest {
	private String _title = "";
	private String _icon;

	public MenuItemRequest(String title,String icon) {
		_title = title;
		_icon = icon;		
	}
	
	public String get_title() {
		return _title;
	}

	public String get_icon() {
		return _icon;
	}	
}
