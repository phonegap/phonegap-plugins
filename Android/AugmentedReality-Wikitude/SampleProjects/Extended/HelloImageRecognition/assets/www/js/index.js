var app = {
    initialize: function() {
        this.bind();
    },
    bind: function() {
        document.addEventListener('deviceready', this.deviceready, false);
    },
    
    // A callback which gets called if the device is able to launch ARchitect Worlds
    onDeviceSupportedCallback : function()
    {
        // The device is able to launch ARchitect World, so lets do so :)
        WikitudePlugin.loadARchitectWorld("assets/world/SimpleImageRecognition/SimpleIRWorld.html");
    },

    // A callback which gets called if the device is not able to start ARchitect Worlds
    onDeviceNotSupportedCallback : function()
    {
        app.report("Unable to launch ARchitect Worlds on this device");
    },
    
    deviceready: function() {
        // note that this is an event handler so the scope is that of the event
        // so we need to call app.report(), and not this.report()
        app.report('deviceready');
        
        // check if the current device is able to launch ARchitect Worlds
        WikitudePlugin.isDeviceSupported(app.onDeviceSupportedCallback, app.onDeviceNotSupportedCallback);
    },
    report: function(id) { 
        console.log("report:" + id);
        // hide the .pending <p> and show the .complete <p>
        document.querySelector('#' + id + ' .pending').className += ' hide';
        var completeElem = document.querySelector('#' + id + ' .complete');
        completeElem.className = completeElem.className.split('hide').join('');
    }
};
