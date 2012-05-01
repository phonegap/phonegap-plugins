UIManager = function () {
	
    		Init = function () {        		
    			$(document).ready(function() {
        			registerOptionsMenu();
        		});   		
    		};
    		    		
    		onError = function (err){alert(err);};

    		    			
    		registerOptionsMenu = function (){
    			var plugin = window.plugins.MenuPlugin;    			
    			if(plugin != 'undefined'){	
    				var menuBuilder = new OptionsMenuBuilder();    				
    				var menu = menuBuilder.Build("main_menu",false);
    				
    				menuBuilder.AddDynamicMenuItem(menu,"Home","home");
    				
    				plugin.Init(onOptionsItemSelected,onError);
    				
    				plugin.RegisterOptionsMenu(menu);
    			}
    			else {
    				alert("Plugin not referenced or not initialized");
    			}
    		};
    		
    		onOptionsItemSelected = function (args){
    			alert("Selected:"+args.title);    			
    		};
    		
    		return {Init:Init};
    	};
 