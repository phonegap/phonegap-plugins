/*******************************************************************************
 * Copyright (c) 2011, WAC Application Services Ltd. All Rights Reserved.
 * The use of this SDK is subject to the terms and conditions in license.txt
 ******************************************************************************/

/**
 * The Napi object.
 */
var Napi = function() {
};

/**
 * A generic success function.
 */
var success = function(e) {
    console.log("Success : " + e);
};

/**
 * A generic failure function.
 */
var failure = function(e) {
	alert("An unexpected error has occurred.");
    console.log("Failure : " + e);
};

Napi.prototype.invoke = function(action, arg, successFunction) {
    var succ = successFunction ? successFunction : success;
    return PhoneGap.exec(succ, 
                        failure, 
                        'NapiPhoneGapPlugin',  // Telling PhoneGap that we want to run "NapiPhoneGap Plugin"
                        action, // Telling the plugin, which action we want to perform
                        [ arg ]); // Passing a list of arguments to the plugin, in this case
};

/**
 * Register the Javascript plugin with PhoneGap.
 */
PhoneGap.addConstructor(function() {
    // Register the javascript plugin with PhoneGap
    PhoneGap.addPlugin('Napi', new Napi());

});

/**
 * Checks whether the string passed is empty or not.
 */
function isEmpty(str){
	var isEmptyStr = false;
	if(str == undefined){
		isEmptyStr = true;
	} else if(str.trim() == ''){
		isEmptyStr = true;
	} else {
		isEmptyStr = false;
	}
	return isEmptyStr;
}

/**
 * The function to trim a string data type.
 */
String.prototype.trim = function() {
	return this.replace(/^\s+|\s+$/g,"");
}

/**
 * The Napi Plugin interface for developers. The developers should use the functions in NapiPayment to integrate their application with WAC Payment gateways. 
 */
var NapiPayment = {
		/**
		 * Initializes the objects required to process the payment (application
		 * ID, credential, secret, developer ID redirectURI and product
		 * information). This data is obtained when the application is
		 * registered with WAC.
		 * 
		 * The results of the call can be captured in a callback function named callback being passed as one of the parameters. 
		 * The callback function should have one parameter which is supposed to be a json object and it holds the result of initializeNapi call.
		 * In this version of plugin the callback json object is null.
		 * 
		 * Implement the callback object as below.
		 * <code>
		 * var initializeNapiCallback = function(r){
		 *     // do your stuff here.
		 * }
		 * </code>
		 * 
		 * and pass the callback object as in NapiPayment.initializeNapi(appId, credential, secret, devname, redirectOAuthURI, initializeNapiCallback);
		 * 
		 */ 
        initializeNapi : function(appId, credential, secret, devname, redirectOAuthURI, callback) {
        	if(isEmpty(appId)){
        		alert('Application Id is null. Cannot initialize Napi.');
        		return;
        	}
        	if(isEmpty(credential)){
        		alert('Credential is null. Cannot initialize Napi.');
        		return;
        	}
        	if(isEmpty(secret)){
        		alert('Secret is null. Cannot initialize Napi.');
        		return;
        	}
        	if(isEmpty(devname)){
        		alert('Developer Name is null. Cannot initialize Napi.');
        		return;
        	}
        	if(isEmpty(redirectOAuthURI)){
        		alert('Redirect OAuth URI is null. Cannot initialize Napi.');
        		return;
        	}
        	var args = {"appId": appId, "credential": credential, "secret": secret, "devname": devname, "redirectOAuthURI": redirectOAuthURI};
            return window.plugins.Napi.invoke('initializeNapi', args, callback);
        },
        
        /**
         * The function is meant for testing purposes only. The application can be spoofed by passing the spoof IP as a string. If not explicitly set by the developer, the application will not be spoofed at all.
         */
        setSpoofIP : function(spoofIPStr) {
            return window.plugins.Napi.invoke('setSpoofIP', spoofIPStr, null);
        },
        
        /**
         * The function is meant for debugging purposes only. We can enable creation of debug logs by passing a boolean value to the function argument.
         */
        setDebugEnabled : function(isDebugEnabled) {
            return window.plugins.Napi.invoke('setDebugEnabled', isDebugEnabled, null);
        },
        
        /**
         * The function can be used to set the WAC end points. Possible values are PRODUCTION and STAGING. If not set explicitly by the developer, the payment gateway runs on PRODUCTION.
         */
        setEndPoint : function(endPointStr) {
            return window.plugins.Napi.invoke('setEndPoint', endPointStr, null);
        },
        
        /**
		 * The method checks whether the server is available for payments or not. 
		 * The results of the call can be captured in a callback function named callback being passed as one of the parameters. 
		 * The callback function should have one parameter which is supposed to be a json object and it holds the result of checkBillingAvailability call.
		 * 
		 * Implement the callback object as below.
		 * <code>
		 * var checkBillingAvailabilityCallback = function(r){
		 *     // do your stuff here.
		 * }
		 * </code>
		 * 
		 * and pass the callback object as in NapiPayment.checkBillingAvailability(checkBillingAvailabilityCallback);
		 * 
		 * Limitations of this method: At the point of calling this method WAC have not yet checked the individual user. In the case the user is out-of-band (e.g. WiFi), we have not yet identified the operator either because we want to avoid having to ask the user for their phone number when this method is called. This means that this method behaves as follows:
         * 		- In-band flow, app not LIVE or not published to this operator: will return "false"
         * 		- Out-of-band flow, app not LIVE or not published in the country of the access point IP address: will return "false"
         * 		- Out-of-band flow, app published in the country of the access point IP address but not the operator of the user: will return "true"
         * 		- Individual user can't use WAC even if other users of this operator can, e.g. user blacklisted, user doesn't have enough credit etc.: will return "false"
         * 		- App is LIVE, published to this operator and individual user can use WAC: will return "true"
		 */ 
        checkBillingAvailability : function(callback) {
            return window.plugins.Napi.invoke('checkBillingAvailability', null, callback);
        },
		
        /**
		 * Fetches the list of product items for the current application 
		 * The results of the call can be captured in a callback function named callback being passed as one of the parameters. 
		 * The callback function should have one parameter which is supposed to be a json object and it holds the result of productList call.
		 * 
		 * Implement the callback object as below.
		 * <code>
		 * var productListCallback = function(r){
		 *     // do your stuff here.
		 * }
		 * </code>
		 * 
		 * and pass the callback object as in NapiPayment.productList(productListCallback);
		 */ 
        productList : function(callback) {
            return window.plugins.Napi.invoke('productList', null, callback);
        },
		
		/**
		 * Deprecated function. The function can be called to do an Express payment. The function takes Item Id selected by the user to do the charge payment.
		 * The results of the call can be captured in a callback function named callback being passed as one of the parameters. 
		 * The callback function should have one parameter which is supposed to be a json object and it holds the result of chargePayment call.
		 * 
		 * Implement the callback object as below.
		 * <code>
		 * var chargePaymentCallback = function(r){
		 *     // do your stuff here.
		 * }
		 * </code>
		 * 
		 * and pass the callback object as in NapiPayment.chargePayment(itemId, chargePaymentCallback);
		 * 
		 */
        chargePayment : function(itemId, callback) {
            return window.plugins.Napi.invoke('chargePayment', itemId, callback);
        },
		
		/**
         * Reserves the Payment. The payment is held until the capturePayment is made. The function takes Item Id selected by the user to do the reserve payment.
         * This gives the option to pause the payment until the content is delivered to the user.
         * The results of the call can be captured in a callback function named callback being passed as one of the parameters. 
		 * The callback function should have one parameter which is supposed to be a json object and it holds the result of reservePayment call.
		 * 
		 * Implement the callback object as below.
		 * <code>
		 * var reservePaymentCallback = function(r){
		 *     // do your stuff here like content delivery.
		 *     // Then call capturePayment as below.
		 *     NapiPayment.capturePayment(r.value);
		 * }
		 * </code>
		 * 
		 * and pass the callback object as in NapiPayment.reservePayment(itemId, reservePaymentCallback);
         * 
         */
        reservePayment : function(itemId, callback) {
            return window.plugins.Napi.invoke('reservePayment', itemId, callback);
        },
		
		/**
         * Captures or makes a Payment after reserving a transaction. This function takes reserved transaction data as a parameter for making the payment. 
         * The results of the call can be captured in a callback function named callback being passed as one of the parameters. 
		 * The callback function should have one parameter which is supposed to be a json object and it holds the result of capturePayment call.
		 * 
		 * Implement the callback object as below.
		 * <code>
		 * var capturePaymentCallback = function(r){
		 *     // do your stuff here.
		 * }
		 * </code>
		 * 
		 * and pass the callback object as in NapiPayment.capturePayment(reserveObj, capturePaymentCallback);
		 * 
         */
        capturePayment : function(reservedTransactionObj, callback) {
            return window.plugins.Napi.invoke('capturePayment', reservedTransactionObj, callback);
        },
		
		/**
         * List the transaction details for a user.
         * The results of the call can be captured in a callback function named callback being passed as one of the parameters. 
		 * The callback function should have one parameter which is supposed to be a json object and it holds the result of transactionList call.
		 * 
		 * Implement the callback object as below.
		 * <code>
		 * var transactionListCallback = function(r){
		 *     // do your stuff here.
		 * }
		 * </code>
		 * 
		 * and pass the callback object as in NapiPayment.transactionList(transactionListCallback);
		 * 
         */
        transactionList : function(callback) {
            return window.plugins.Napi.invoke('transactionList', null, callback);
        },
		
		/**
         * Provides the transaction details for a given transaction ID. The method takes two arguments. 
         * The first one is the server reference code of the item selected and the second one is the item Id.
         * The results of the call can be captured in a callback function named callback being passed as one of the parameters. 
		 * The callback function should have one parameter which is supposed to be a json object and it holds the result of checkTransaction call.
		 * 
		 * Implement the callback object as below.
		 * <code>
		 * var checkTransactionCallback = function(r){
		 *     // do your stuff here.
		 * }
		 * </code>
		 * 
		 * and pass the callback object as in NapiPayment.checkTransaction(serverRef,itemId, checkTransactionCallback);
		 * 
         */
        checkTransaction : function(serverReferenceCode, itemId, callback) {
        	var args = {"serverReferenceCode": serverReferenceCode, "itemId": itemId};
            return window.plugins.Napi.invoke('checkTransaction', args, callback);
        }
};



