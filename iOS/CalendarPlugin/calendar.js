//
// Cordova Calendar Plugin
// Author: Felix Montanez 
// Created: 01-17-2012
//
// Contributors:
// Michael Brooks


function calendarPlugin()
{
}



calendarPlugin.prototype.createEvent = function(title,location,notes,startDate,endDate) {
    console.log("here");
    cordova.exec(null,null,"calendarPlugin","createEvent", [title,location,notes,startDate,endDate]);
};

// More methods will need to be added like fetch events, delete event, edit event

calendarPlugin.install = function()
{
    if(!window.plugins)
    {
        window.plugins = {};
    }
    
    window.plugins.calendarPlugin = new calendarPlugin();
    return window.plugins.calendarPlugin;
};

cordova.addConstructor(calendarPlugin.install);
