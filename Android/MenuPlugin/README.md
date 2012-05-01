Menu Plugin
============

Installation
------------

This plugin allows your application to use native Android options menu activated via device's Menu button.
Menu items can be inflated from existing xml layout, added dynamically via JS API or as a mix of both techniques.
  

To use the plugin you need:

1. Copy the contents under src folder (com/phonegap/plugins/menu) to your projects src folder
(or you can optionally pack them into a JAR) and reference via build path

2. Copy  the menuPlugin.js (from assets/www/scripts) to similar location where you keep js files in your phonegap project

3. Modify your default activity to inherit from DroidGapMenuActivity instead of DroidGap

4. Reference menuPlugin.js from your HTML file

5. Register plugin in res/xml/plugins.xml: <plugin name="MenuPlugin" value="com.phonegap.plugins.menu.MenuPlugin" />

6. If you want to use predefined xml layouts and inflate them, you will need to add them to res/layout folder

7. In your layouts you may use resources from res/values/strings.xml for menu item titles

8. In both inflated layouts or dynamic menu items you can use icons from res/drawable if you 
   need icons in your menu   

9. If you want to use dynamic items only, you can call MenuBuilder with empty sting as layout name

10. Additionally, in Menu object that is created via MenuBuilder there is an option to set whether you want
	a dynamic menu. Static menu is created only once first time Menu button is pressed and is more efficient if used frequently. 
	Dynamic menu is created	every time Menu button is pressed on device, so that you can switch to another menu on the fly
	from JS, depending on the context.     


NOTE: If you have a handler on menu button in your JS using  PhoneGap API (document.addEventListener("menubutton",....),
plugin will work as it relies on native events and JS event will fire as well.


Use SampleProject as a fully-functional example of integration of both Java and JS/HTML parts.