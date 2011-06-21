/* PayPal PhoneGap Plugin - Demonstration JavaScript control
*
* Copyright (C) 2011, Appception, Inc.. All Rights Reserved.
* Copyright (C) 2011, Mobile Developer Solutions All Rights Reserved.
*/

function isOpen(id) {
    return document.getElementById(id).style.display === '' ? 1 : 0;
}
function setOpen(id) {
    document.getElementById(id).style.display = '';
}
function setClosed(id) {
    document.getElementById(id).style.display = 'none';
}

function runDemo() {
    setClosed('pmt_container');
    setClosed('pmt_show_initialize');
    setClosed('pmt_show_loading');
    setClosed('pmt_show_details');
    setClosed('pmt_show_details_form');
    setClosed('pmt_show_buttons');
    setClosed('pmt_results');

    setOpen('pmt_container');
    setOpen('pmt_show_initialize');
    return false;
}

function showDemoDetails() {
    if (isOpen('pmt_details')) {
        setClosed('pmt_details');
    } else {
        setOpen('pmt_details');
    }
}

var getStatusTimeout = null;
function pollStatus() {
    mpl.getStatus();
    getStatusTimeout = setTimeout(pollStatus, 1000);
}

var getStatusCallback = function(r) {  // for the PhoneGap callback's asynchronous call
    if (r.str === '1') {
        clearTimeout(getStatusTimeout);
        setClosed('pmt_show_loading');
        setClosed('pmt_show_initialize');
        setOpen('pmt_show_details');
    } 
};

var start_time;

// JavaScript MPL library
function initializeMPL() {

    // Show loading image while waiting for initialization
    setOpen('pmt_show_loading');

    mpl.prepare(PayPalPaymentType.HARD_GOODS);

    start_time = new Date().getTime(); 
    pollStatus();
}

function closePaymentInfoForm() {
    setClosed('pmt_show_details');
    setClosed('pmt_show_details_form');
    setOpen('pmt_show_buttons');
    return false;
}

function submitPaymentInfo(obj) {
    var str;
    obj.ipnUrl = 'http://127.0.0.1';
    obj.customID = '123';

    str = JSON.stringify(obj);

    // Call (with JSON arg)
    mpl.setPaymentInfo(str);
    return false;
}

function setPaymentInfoForm() {
    var obj = {};

    obj.paymentAmount = document.getElementById('pmt_subtotal').value;
    obj.paymentCurrency = document.getElementById('pmt_currency').value;
    obj.recipient = document.getElementById('pmt_recipient').value;
    obj.merchantName = document.getElementById('pmt_merchant').value;
    obj.itemDesc = document.getElementById('pmt_description').value;
    obj.memo = document.getElementById('pmt_memo').value;
    obj.tax = document.getElementById('pmt_tax').value;
    obj.shipping = document.getElementById('pmt_shipping').value;
    
    closePaymentInfoForm();

    submitPaymentInfo(obj);
    return false;
}

function showPaymentInfoForm() {
    if (isOpen('pmt_show_details_form')) {
        closePaymentInfoForm();
    } else {
        setOpen('pmt_show_details_form');
    }
}

function payButton(btype) {
    mpl.payButton(btype);
}

var displayPaymentResults = function(str) {
    var obj = JSON.parse(str);
    var ostr = obj.result_info;
    ostr += '<br>';
    ostr += obj.result_title;
    ostr += '<br>';
    ostr += obj.result_extra;
    ostr += '<br>';
    document.getElementById('pmt_results').innerHTML = ostr;

    setOpen('pmt_results');
};

function onPaymentSuccess(evt)
{
    displayPaymentResults(evt.result);
}

function onPaymentCanceled(evt)
{
    navigator.notification.alert("Payment canceled.");
    displayPaymentResults(evt.result);
}

function onPaymentFailed(evt)
{
    navigator.notification.alert("Payment failed, errorType: " + evt.errorType);
    displayPaymentResults(evt.result);
    // compare evt.errorType to PayPalFailureType enum values
}

/*
 * When this function is called, PhoneGap has been initialized and is ready to roll
 */
function onDeviceReady() {
    try {

        // set up PayPal payment event callbacks

        document.addEventListener(PaypalPaymentEvent.Success, onPaymentSuccess,
                false);
        document.addEventListener(PaypalPaymentEvent.Canceled,
                onPaymentCanceled, false);
        document.addEventListener(PaypalPaymentEvent.Failed, onPaymentFailed,
                false);

        // Construct the JavaScript MPL library
        // Specify The PayPal server to be used - can also be ENV_NONE, ENV_SANDBOX or ENV_LIVE
        // Specify the appId like "APP-80W284485P519543T" (can be empty string for ENV_NONE)

        var obj = {
            server : 'ENV_NONE',
            appId : ''
        };
//        var obj = {
//            server : 'ENV_SANDBOX',
//            appId : 'APP-80W284485P519543T'
//        };

        mpl.construct(JSON.stringify(obj));

    } catch (e) {
        debug.error(e);
    }
}

function onBodyLoad()
{
    document.addEventListener("deviceready", onDeviceReady,false);
}