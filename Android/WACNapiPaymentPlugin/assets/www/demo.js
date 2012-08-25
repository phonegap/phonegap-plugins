/**
 * WAC Napi PhoneGap Plugin - Demonstration JavaScript control
 */

/**
 * Called on the page load. 
 */
function onPageLoad() {
    document.addEventListener("deviceready", onDeviceReady,false);
}

/**
 * PhoneGap has been initialized and is ready to roll
 * initializeNapi Phonegap plugin call
 */
function onDeviceReady() { 
	// Initalize Napi  
	
	var appId = 'wac-af76d90c-9ced-418b-a8d8-f6c45d0837a1';
	var credential = 'wac-3fcd2cbb8e806ef88311451818232a80d843af56';
	var secret = 'c48d214b98a0bc539b191076b61858f616fd3d25';
	var devname = 'developer1';
	var redirectOAuthURI = 'https://gateway.wacapps.net/redirect/9dc31536-026d-4c00-adf1-6957d80366da';
	var spoofIPStr = '12.207.19.229';
	var endPoint = 'PRODUCTION';
	var isDebugEnabled = true;
	
	NapiPayment.setDebugEnabled(isDebugEnabled);
	NapiPayment.setEndPoint(endPoint);
	NapiPayment.setSpoofIP(spoofIPStr);
    NapiPayment.initializeNapi(appId, credential, secret, devname, redirectOAuthURI, initializeNapiCallback);
}

/**
 * The Initialize Napi Callback
 */
var initializeNapiCallback = function(r){
	// Check the availability of the server.
	//checkBillingAvailability can be used to find the availability of WAC billing services. (Optional)
	NapiPayment.checkBillingAvailability(checkBillingAvailabilityCallback);
}

/**
 * The callback method after checking the availability of the server.
 */
var checkBillingAvailabilityCallback = function(r){
	hide('payment_option_loading');
	show('WAC_payment_option');
	if(!r.isBillingAvailable){
		document.getElementById('WAC_payment').onclick = null;
		show('billing_not_available');
	}
	
}

/**
 * Called when the user selects the WAC Payment 
 */
  
function startPayment() {
    hide('payment_options');
    hide('product_list');
    show('show_loading');
    // Get the list of all the operators.
	NapiPayment.productList(productListCallback);
    return false;
}

/**
 * The method gets the product list.
 */
var productListCallback = function(r) { 	
    hide('show_loading');   
    show('product_list');
    var result = '';
    // create the drop down from the result got in the callback.
    result += '<select id="productList">';
    for (i = 0; i < r.itemList.length;i++) {		
		result += '<option value=' + r.itemList[i].itemId + '>' + r.itemList[i].itemDesc + '</option>';		  		
	}
	result += '</select>';
	// Set the drop down HTML in the item Column div.
	document.getElementById('itemColumn').innerHTML = result;
};

/**
 * The method starts the reserve payment process.
 */
function reservePayment(){
	show('show_loading');
	show('product_list');
	hide('payment_options');
	// Get the selected product from the drop down.
   	var selObj = document.getElementById('productList');
	var itemId = selObj.options[selObj.selectedIndex].value;
	//Reserve the payment.
	NapiPayment.reservePayment(itemId, reservePaymentCallback);
	hide('show_loading');
}

/**
 * The Reserve Payment Callback
 */
var reservePaymentCallback = function(r){
	if(r.key != undefined && r.key != ''){
		if(r.key == 'reservedTransaction'){
			// do something here.
			hide('product_list');
			hide('show_loading');
			show('file_downloading');
			
			NapiPayment.capturePayment(r.value, capturePaymentCallback);
		}
	} else if(r.error != undefined && r.error != ''){
		showFailedTransaction(r);
	}
}

/**
 * The Capture Payment Callback
 */
var capturePaymentCallback = function(r){
	hide('file_downloading');
	if(r.key != undefined && r.key != ''){
		if(r.key == 'transactionDetails'){
			showSuccessTransaction(r);
		}
	} else if(r.error != undefined && r.error != ''){
		showFailedTransaction(r);
	}
}

/**
 * PhoneGap asynchronous call callback for capturePayment
 */
var showSuccessTransaction = function(r) {
	hide('show_loading');
	hide('product_list');
    show('products_bought');
    document.getElementById('productName').innerText = r.value.amountTransaction.paymentAmount.chargingInformation.description;
    document.getElementById('amount').innerText = r.value.amountTransaction.paymentAmount.chargingInformation.currency + ' ' + r.value.amountTransaction.paymentAmount.chargingInformation.amount;    
};


/**
 * Shows the failed transaction page.
 */
var showFailedTransaction = function(r) {
	hide('show_loading');
	hide('product_list');
    show('transaction_failed');
    document.getElementById('error').innerText = r.error;
    document.getElementById('errorDescription').innerText = r.errorDescription;    
};


/**
 * Shows the operator list page.
 */
function showOperatorListPage(){
	show('show_loading');
    hide('payment_options');
    hide('product_list');
    hide('show_loading');
}

/**
 * Show the home page.
 */
function continueShopping(){
	hide('show_loading');
    show('payment_options');
	hide('product_list');
	hide('transaction_failed');
	hide('products_bought');
	hide('view_transaction');
	closeCollapablePanel();
}

/**
 * Functions for showing and hiding the div tags
 * @param id Id of the div open
 * @returns boolean
 */
function isOpen(id) {
    return document.getElementById(id).style.display === '' ? 1 : 0;
}

/**
 * Change the display of the div to show.
 */
function show(id) {
    document.getElementById(id).style.display = '';
}

/**
 * Change the display of the div to hide.
 */
function hide(id) {
    document.getElementById(id).style.display = 'none';
}

/**
 * Gets an array of URL parameters.
 * @param location The URL.
 * @returns {Array} The array of URL parameters.
 */
function getUrlVars(location) {
    var vars = [],
        hash;
    var hashes = location.slice(location.indexOf('#') + 1).split('&');
    for (var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

var transactionTableHeader = '<tr align="left"><th>Product</th> <th>Amount</th></tr>';
var noProductsFound = '<tr><td colspan = "2">No Products found</td></tr>';

/**
 * Gets the transaction list
 */
function transactionList(){
	expandCollapablePanel();
	NapiPayment.transactionList(transactionListCallback);
}

/**
 * The transaction list callback.
 * @param r The json object containing the transaction list.
 */
function transactionListCallback(r){
	var str = '' + noProductsFound;
	if(r.dummy == undefined) {
		if(r.key == 'transactionList'){
			var transactionsList = r.value;
			
			if(!isEmpty(transactionsList.paymentTransactionList)){
				var transactions = transactionsList.paymentTransactionList.amountTransaction;
				if(transactions.length > 0){
					str = '';
					str += transactionTableHeader;
				}
				for (var i = 0; i < transactions.length; i++) {
					transaction = transactions[i];
					var description = transaction.paymentAmount.chargingInformation.description;
					var currency = transaction.paymentAmount.chargingInformation.currency;
					var amount = transaction.paymentAmount.chargingInformation.amount;
					var itemId = transaction.paymentAmount.chargingInformation.code;
					var serverReferenceCode = transaction.serverReferenceCode;
					var argString =  description + ', ' +  currency + ', ' + amount + ', ' + serverReferenceCode;
					str = str + '<tr align="left" onclick="checkTransaction(\'' + description + '\', \'' + currency + '\' , \'' + amount + '\', \'' + serverReferenceCode + '\', \'' + itemId + '\')"> <td>' + description+ '</td> <td nowrap="nowrap">' + currency + ' ' + amount+ '</td> </tr>';
			    }
			}
		}
		hide('show_loading');
		expandCollapablePanel();
		document.getElementById('transaction_list_products').innerHTML = str;
	}
	
}

/**
 * Utility function returning whether the json object passed is empty or not.
 * @param jsonObject
 * @returns {Boolean}
 */
function isEmpty(jsonObject){
	for (member in jsonObject) {
	    if (jsonObject[member] != null)
	       return false;
	}
	return true;
}

/**
 * The check transaction callback.
 * @param r The json object containing the transaction details.
 */
function checkTransactionCallback(r){
	if(r.value != undefined){
		hide('show_loading');
		if(r.value.amountTransaction != undefined){
			alert('Transaction Status : ' + r.value.amountTransaction.transactionOperationStatus);
		} 
	}
}

/**
 * The function checks the transaction details.
 * @param name The name of the item purchased.
 * @param currency The currency of purchase.
 * @param amount The amount charged.
 * @param serverRef The server reference code.
 * @param itemId The Item id of the item purchased.
 */
function checkTransaction(name, currency, amount, serverRef, itemId){
	hide('payment_options');
	show('view_transaction');
	document.getElementById('check_transaction_name').innerHTML = name;
	document.getElementById('check_transaction_amount').innerHTML = currency + ' ' + amount;
	document.getElementById('check_transaction_ref').innerHTML = serverRef;
	document.getElementById('check_transaction_item_id').innerHTML = itemId;
	document.getElementById('check_transaction_btn').onclick = function (){
		var args=[];
		NapiPayment.checkTransaction(serverRef,itemId, checkTransactionCallback);
	};
}

/**
 * The function to close the collapsable panel.
 */
function closeCollapablePanel(){
	document.getElementById('collapable_image').src = './images/toggle-expand-alt.png';
	hide('transaction_list_products');
}

/**
 * The function to expand the collapsable panel.
 */
function expandCollapablePanel(){
	document.getElementById('collapable_image').src = './images/toggle-collapse-alt.png';
	show('transaction_list_products');
}

/**
 * The function to toggle the collapsable panel.
 */
function toggle(){
		if(document.getElementById('transaction_list_products').innerHTML.trim() == '') document.getElementById('transaction_list_products').innerHTML = noProductsFound;
		var source = document.getElementById('collapable_image').src
		if(source.indexOf('toggle-collapse-alt.png') != -1){
			document.getElementById('collapable_image').src = './images/toggle-expand-alt.png';
			hide('transaction_list_products');
		} else {
			document.getElementById('collapable_image').src = './images/toggle-collapse-alt.png';
			
			show('transaction_list_products');
		}
}

