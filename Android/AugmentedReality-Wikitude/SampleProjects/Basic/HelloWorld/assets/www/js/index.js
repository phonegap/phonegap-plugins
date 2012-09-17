var app = {
    initialize: function() {
        this.bind();
    },
    bind: function() {
        document.addEventListener('deviceready', this.deviceready, false);
    },
    
    /**
     *
     *	This function extracts an url parameter
     *
     */
    getUrlParameterForKey : function( url, requestedParam )
    {
        requestedParam = requestedParam.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
        var regexS = "[\\?&]"+requestedParam+"=([^&#]*)";
        var regex = new RegExp( regexS );
        var results = regex.exec( url );
        if( results == null )
          return "";
        else
        {
            var result = decodeURIComponent(results[1]);
            return result;
        }

    },
                                                  
    /**
     *
     *	This function gets called if you call "document.location = architectsdk://" in your ARchitect World
     *
     *
     *  @param url The url which was called in ARchitect World
     *
    */
    onClickInARchitectWorld : function(url)
    {

        app.report("you clicked on a label with text: " + app.getUrlParameterForKey(url, 'text'));
    },
                                                  
    /**
     *
     *	This function gets called it the Wikitude SDK is able to start an ARchitect World (the current device is supported by the Wikitude SDK)
     *
     */
    onDeviceIsReadyCallback : function()
    {
        // The device is able to launch ARchitect World, so we load the 'Hello World' example
        WikitudePlugin.loadARchitectWorld("assets/world/HelloWorld.html");
        
        // To be able to respond on events inside the ARchitect World, we set a onURLInvoke callback
        WikitudePlugin.setOnUrlInvokeCallback(app.onClickInARchitectWorld);
                                                  
        // This is a example how you can interact with the ARchitect World to pass in additional information
        // In this example, a JavaScript function gets called which sets a new text for a label
        WikitudePlugin.callJavaScript("didReceivedNewTextForLabel('Hello World')"); 
    },
                                                  
    /**
    *
    *	This function gets if the current device is not capable of running ARchitect Worlds
    *
    */
    onDeviceIsUnsupportedCallback : function()
    {
        app.report('device is not supported');
    },

    /**
    *
    *	This function gets if the ARchitect World finished loading
    *
    */
    onARchitectWorldLaunchedCallback : function()
    {
        app.report('ARchitect World launched');
    },
                                                  
    /**
    *
    *	This function gets if the ARchitect failed loading
    *
    */
    onARchitectWorldFailedLaunchingCallback : function(err)
    {
        app.report('ARchitect World failed launching');
    },
                                                  
    /**
    *
    *	This function gets called when the Wikitude SDK is ready to start an ARchitect World (the current device is supported by the Wikitude SDK)
    *
    */
    deviceready: function() {
        // note that this is an event handler so the scope is that of the event
        // so we need to call app.report(), and not this.report()
        app.report('deviceready');
                                                  
        // When PhoneGap finished loading we forward this event into the Wikitude SDK wrapper.
        // @param {function} A function which gets called if the device is able to launch ARchitect Worlds
        // @param {function} A function which gets called if the device is not able to launch ARchitect Worlds
        WikitudePlugin.isDeviceSupported(app.onDeviceIsReadyCallback, app.onDeviceIsUnsupportedCallback);
        
        // set a callback on the WikitudePlugin to get informed when the ARchitect World finished loading
        WikitudePlugin.onARchitectWorldLaunchedCallback = app.onARchitectWorldLaunchedCallback;

        // Set a callback on the WikitudePlugin to get informed when the ARchitect World failed loading
        WikitudePlugin.onARchitectWorldFailedLaunchingCallback = app.onARchitectWorldFailedLaunchingCallback;
    },
    report: function(id) { 
        console.log("report:" + id);
    }
};
