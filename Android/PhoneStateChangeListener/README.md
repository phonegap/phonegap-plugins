PhoneStateChangeListener
========================

Cordova plugin to provide callback when Telephony state changes

Possible states are IDLE, OFFHOOK and RINGING

Get this at https://github.com/madeinstefano/PhoneStateChangeListener

# to use:

1 - Import the .js file plugin right after your cordova.js file (index.html)
2 - Import the .java file inside your src folder
3 - Setup the callback to handle when state changes in your js:
    
    plugins.PhoneStateChangeListener.start(function (state){
      // do stuff with the state
    });
    
3 - Possible values to 'state' variable are:

    plugins.PhoneStateChangeListener.IDLE // when the none call are being made
    plugins.PhoneStateChangeListener.RINGING // when the phone is ringing
    plugins.PhoneStateChangeListener.OFFHOOK // when the phone is busy
    plugins.PhoneStateChangeListener.NONE // when something goes wrong
    
4 - To stop listening to this:

    plugins.PhoneStateChangeListener.stop();
    
    
# version 1
- Added basic support to listen when Telephony state changes
- Added feature to remove this listener