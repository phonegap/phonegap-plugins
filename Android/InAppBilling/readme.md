In app billing documentation
===================================
Requirements
-------------
Tested on Cordova 2.0  

Installation 
-------------
* Get acquainted with the Android In-app Billing documentation.
* Add in your src folder the *com* folder  
It contains:
	* [Google Play In-app Billing library]( http://developer.android.com/guide/google/play/billing/billing_overview.html)
	* Cordova InAppBillingPlugin
* Add in your src folder the *net* folder  
It contains the [Android Billing Library](https://github.com/robotmedia/AndroidBillingLibrary)
* Add inappbilling.js in your www folder 
* Add in your index.html
`<script type="text/javascript" charset="utf-8" src="inappbilling.js"></script>`
* In res/xml/config.xml, add     
`<plugin name="InAppBillingPlugin" value="com.smartmobilesoftware.inappbilling.InAppBillingPlugin"/>`
* Open the AndroidManifest.xml of your application
	* add this permission  
`<uses-permission android:name="com.android.vending.BILLING" />`
	* this service and receiver inside the application element:  
<pre>
&lt;service android:name="net.robotmedia.billing.BillingService" /&gt;
&lt;receiver android:name="net.robotmedia.billing.BillingReceiver"&gt;
	&lt;intent-filter&gt;
		&lt;action android:name="com.android.vending.billing.IN_APP_NOTIFY" /&gt;
		&lt;action android:name="com.android.vending.billing.RESPONSE_CODE" /&gt;
		&lt;action android:name="com.android.vending.billing.PURCHASE_STATE_CHANGED" /&gt;
	&lt;/intent-filter&gt;
&lt;/receiver&gt;
</pre>
* In com.smartmobilesoftware.inappbilling open InAppBillingPlugin.java
	* Add you public key (can be found in your Google Play account)
	* Modify the salt with random numbers
* Read the google testing guide to learn how to test your app : http://developer.android.com/guide/google/play/billing/billing_testing.html

Usage
-------
#### Initialization
    inappbilling.init(success,error)
parameters
* success : The success callback.
* error : The error callback.

#### Purchase
    inappbilling.purchase(success, fail,productId)
parameters
* success : The success callback.
* error : The error callback.
* productId : The in app billing porduct id (example "sword_001")

#### Retrieve own products
	inappbilling.getOwnItems(success, fail)
parameters
* success : The success callback. It provides a json array of the list of owned products as a parameter.
* error : The error callback.

	
Quick example
---------------
```javascript
inappbilling.init(successInit,errorCallback)

function successInit(result) {    
	// display the extracted text   
	alert(result); 
	inappbilling.purchase(successPurchase,errorCallback, "sword_001");
	
}    
function errorCallback(error) {
   alert(error); 
} 

function successPurchase(productId) {
   alert("Your item has been purchased!");
} 
```

Full example
----------------
```html
<!DOCTYPE HTML>
<html>
	<head>
		<title>Cordova</title>
		<script type="text/javascript" charset="utf-8" src="cordova-2.0.0.js"></script>
		<script type="text/javascript" charset="utf-8" src="inappbilling.js"></script>
		<script type="text/javascript" charset="utf-8">
			function successHandler (result) { 
			   alert("SUCCESS: \r\n"+result ); 
			} 
			
			function errorHandler (error) { 
			   alert("ERROR: \r\n"+error ); 
			} 

			// Click on init button
			function init(){
				// Initialize the billing plugin
				inappbilling.init(successHandler, errorHandler); 
			}
			
			// Click on purchase button
			function purchase(){
				// make the purchase
				inappbilling.purchase(successHandler, errorHandler,"sword_001"); 
				
			}
			
			// Click on ownedProducts button
			function ownedProducts(){
				// Initialize the billing plugin
				inappbilling.getOwnItems(successHandler, errorHandler); 
				
			}

		</script>
		
	</head>
	<body>
		<h1>Hello Billing</h1>
		<button onclick="init();">Initalize the billing plugin</button> 
		<button onclick="purchase();">Purchase</button> 
		<button onclick="ownedProducts();">Owned products</button> 
		
		
	</body>
</html>
```

MIT License
----------------

Copyright (c) 2012 Guillaume Charhon - Smart Mobile Software

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.