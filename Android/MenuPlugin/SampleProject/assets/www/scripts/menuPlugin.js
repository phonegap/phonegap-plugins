
/*
 * Phonegap Menu Plugin Copyright (c) Alex Michel
 */

OptionsMenuBuilder = function (){
	
	Build = function (layout,isdynamic){		
		var menu = {
			layoutName:layout,
			isDynamic:isdynamic,
			items:[]
		};
		
		return menu;
	}
	
	AddDynamicMenuItem = function (menu,title,icon) {
		menu.items.push({"title":title,"icon":icon});
	}
	
	return {Build:Build,AddDynamicMenuItem:AddDynamicMenuItem}
};
 
MenuPlugin = function (){
		var onOptionsItemSelected;
		var onError;
		
		Init = function (itemSelectedCallback, errorCallback){
			onOptionsItemSelected = itemSelectedCallback;
			onError = errorCallback;				
		}
		
		RegisterOptionsMenu = function (optionsMenu) {
			return PhoneGap.exec(onOptionsItemSelected,onError,'MenuPlugin','RegisterOptionsMenu',new Array(optionsMenu));
		}
		
		
		return {Init:Init,RegisterOptionsMenu:RegisterOptionsMenu}
};

//register plugin
if (typeof cordova !== "undefined") {	
	cordova.addConstructor(function() {
		cordova.addPlugin("MenuPlugin", new MenuPlugin());
               });
	}