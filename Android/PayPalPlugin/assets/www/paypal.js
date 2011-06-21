/* PayPal PhoneGap Plugin - JavaScript side of the bridge to PayPalPlugin.java
*
* Copyright (C) 2011, Appception, Inc.. All Rights Reserved.
* Copyright (C) 2011, Mobile Developer Solutions All Rights Reserved.
*/

/* 
 * @return Instance of PayPal
 */
var PayPal = function() {
};

/**
 * @param directory
 *            The directory for which we want the listing
 * @param successCallback
 *            The callback which will be called when directory listing is successful
 * @param failureCallback
 *            The callback which will be called when directory listing encounters an error
 */
var genericSuccess = function(e) {
    console.log("Success from PayPal plugin " + e);
};

var fail = function(e) {
    console.log("Failure from PayPal plugin " + e);
};

PayPal.prototype.invoke = function(callee, arg, successFunction) {

    var succ = successFunction ? successFunction : genericSuccess;
    return PhoneGap.exec(succ, 
                        fail, 
                        'PayPalPlugin',  // Telling PhoneGap that we want to run "PayPal Plugin"
                        callee, // Telling the plugin, which action we want to perform
                        [ arg ]); // Passing a list of arguments to the plugin, in this case
};

/**
 * <ul>
 * <li>Register the Directory Listing Javascript plugin.</li>
 * <li>Also register native call which will be called when this plugin runs</li>
 * </ul>
 */
PhoneGap.addConstructor(function() {
    // Register the javascript plugin with PhoneGap
    PhoneGap.addPlugin('PayPal', new PayPal());

    // Register the native class of plugin with PhoneGap
    PluginManager.addService("PayPalPlugin", "com.phonegap.plugin.PayPalPlugin");
});

var mpl = {
        construct : function(str) {
            window.plugins.PayPal.invoke('construct', str);
        },
        prepare : function(ptype) {
            window.plugins.PayPal.invoke('prepare', ptype);
        },
        getStatus : function() {
            return window.plugins.PayPal.invoke('getStatus', null, getStatusCallback);
        },
        setPaymentInfo : function(arg) {
            window.plugins.PayPal.invoke('setPaymentInfo', arg);            
        },
        payButton : function(btype) {
            window.plugins.PayPal.invoke('pay', btype);
        }
};

/*
 * Events to listen to after a user touches the payment button 
 */
var PaypalPaymentEvent =
{
    /**
     * Listen for this event to signify Paypal payment success. The event object will have these properties:
     *      transactionID - a string value
     */
    Success : "PaypalPaymentEvent.Success",
    /**
     * Listen for this event to signify Paypal payment canceled. The event object will have these properties:
     *      [no properties available]
     */
    Canceled : "PaypalPaymentEvent.Canceled",
    /**
     * Listen for this event to signify Paypal payment failed. The event object will have these properties:
     *      errorType - an integer value
     */
    Failed : "PaypalPaymentEvent.Failed"
};

/*
 * PaymentType for window.plugins.prepare
 */
var PayPalPaymentType = 
{
    'HARD_GOODS': 0,
    'SERVICE'   : 1,
    'PERSONAL'  : 2,
    'DONATION'  : 3
};
