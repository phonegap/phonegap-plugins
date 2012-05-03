package com.phonegap.plugins.menu;

import java.util.List;

public class OptionsMenuRequest {
	
	private String _layoutName = null;
	private List<MenuItemRequest> _items = null;
	private Boolean _isDynamic = false;

	public OptionsMenuRequest(String layoutName, List<MenuItemRequest> items, Boolean isDynamic) {
		 _layoutName = layoutName;
		 _items = items;
		 _isDynamic = isDynamic;
	}
	
	public String get_layoutName() {
		return _layoutName;
	}

	public List<MenuItemRequest> get_items() {
		return _items;
	}

	public Boolean get_isDynamic() {
		return _isDynamic;
	}
}
