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
		 * The results of the call can be captured in a callback function initializeNapiCallback with parameters as a json object <code>r</code>. 
		 * Implement the callback object as below.
		 * <code>
		 * var initializeNapiCallback = function(r){
		 *     // do your stuff here.
		 * }
		 * </code>
		 * 
		 * In this version of plugin the callback json object r is null.
		 */ 
        initializeNapi : function(appId, credential, secret, devname, redirectOAuthURI) {
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
            return window.plugins.Napi.invoke('initializeNapi', args, initializeNapiCallback);
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
		 * Fetches the list of product items for the current application 
		 */ 
        productList : function() {
            return window.plugins.Napi.invoke('productList', null, productListCallback);
        },
		
		/**
		 * The function can be called to do an Express payment. The function takes Item Id selected by the user to do the charge payment.
		 * The results of the call can be captured in a callback function chargePaymentCallback with parameters as a json object <code>r</code>. 
		 * Implement the callback object as below.
		 * <code>
		 * var chargePaymentCallback = function(r){
		 *     // do your stuff here.
		 * }
		 * </code>
		 */
        chargePayment : function(itemId) {
            return window.plugins.Napi.invoke('chargePayment', itemId, chargePaymentCallback);
        },
		
		/**
         * Reserves the Payment. The payment is held until the capturePayment is made. The function takes Item Id selected by the user to do the reserve payment.
         * This gives the option to pause the payment until the content is delivered to the user.
         * The results of the call can be captured in a callback function reservePaymentCallback with parameters as a json object <code>r</code>. 
		 * Implement the callback object as below.
		 * <code>
		 * var reservePaymentCallback = function(r){
		 *     // do your stuff here like content delivery.
		 *     // Then call capturePayment as below.
		 *     NapiPayment.capturePayment(r.value);
		 * }
		 * </code>
         * 
         */
        reservePayment : function(itemId) {
            return window.plugins.Napi.invoke('reservePayment', itemId, reservePaymentCallback);
        },
		
		/**
         * Captures or makes a Payment after reserving a transaction. This function takes reserved transaction data as a parameter for making the payment. 
         * The results of the call can be captured in a callback function capturePaymentCallback with parameters as a json object <code>r</code>. 
		 * Implement the callback object as below.
		 * <code>
		 * var capturePaymentCallback = function(r){
		 *     // do your stuff here.
		 * }
		 * </code>
         */
        capturePayment : function(reservedTransactionObj) {
            return window.plugins.Napi.invoke('capturePayment', reservedTransactionObj, capturePaymentCallback);
        },
		
		/**
         * List the transaction details for a user.
         * The results of the call can be captured in a callback function transactionListCallback with parameters as a json object <code>r</code>. 
		 * Implement the callback object as below.
		 * <code>
		 * var transactionListCallback = function(r){
		 *     // do your stuff here.
		 * }
		 * </code>
         */
        transactionList : function() {
            return window.plugins.Napi.invoke('transactionList', null, transactionListCallback);
        },
		
		/**
         * Provides the transaction details for a given transaction ID. The method takes two arguments. 
         * The first one is the server reference code of the item selected and the second one is the item Id.
         * The results of the call can be captured in a callback function checkTransactionCallback with parameters as a json object <code>r</code>. 
		 * Implement the callback object as below.
		 * <code>
		 * var checkTransactionCallback = function(r){
		 *     // do your stuff here.
		 * }
		 * </code>
         */
        checkTransaction : function(serverReferenceCode, itemId) {
        	var args = {"serverReferenceCode": serverReferenceCode, "itemId": itemId};
            return window.plugins.Napi.invoke('checkTransaction', args, checkTransactionCallback);
        }
};



