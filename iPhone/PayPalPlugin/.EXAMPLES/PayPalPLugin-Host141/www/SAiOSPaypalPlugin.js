// //////////////////////////////////////
// Paypal PhoneGap Plugin
// by Shazron Abdullah
// Oct 8th 2010
// 

/*
 * buttonType (unused currently)
 */
var PayPalButtonType = {
	'BUTTON_68x24' : 0,
	'BUTTON_68x33' : 1,
	'BUTTON_118x24': 2,
	'BUTTON_152x33': 3,
	'BUTTON_194x37': 4,
	'BUTTON_278x43': 5,
	'BUTTON_294x43': 6,
	'BUTTON_TYPE_COUNT': 7
};

/*
 * PaymentType for window.plugins.prepare
 */
var PayPalPaymentType = 
{
	'HARD_GOODS': 0,
	'SERVICE'	: 1,
	'PERSONAL'	: 2,
	'DONATION'	: 3
};

/*
 * errorType for PaypalPaymentEvent.Failed
 */
var PayPalFailureType  = 
{
	'SYSTEM_ERROR' 		: 0,
	'RECIPIENT_ERROR'	: 1,
	'APPLICATION_ERROR' : 2,
	'CONSUMER_ERROR'	: 3
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

/**
 * Constructor
 */
function SAiOSPaypalPlugin()
{
}

/**
 * Prepare payment type
 *     paymentType is from the PayPalPaymentType enum
 */
SAiOSPaypalPlugin.prototype.prepare = function(paymentType)
{
	PhoneGap.exec("SAiOSPaypalPlugin.prepare", paymentType);
}

/**
 * Initiate payment
 */
SAiOSPaypalPlugin.prototype.pay = function()
{
	PhoneGap.exec("SAiOSPaypalPlugin.pay");
}

/**
 * Sets the payment information for when the Paypal button is clicked.
 * Takes in an object (paymentProperties). Properties available to be set:
 *      paymentCurrency - a string value (required)
 *      paymentAmount - a double value (required)
 *      itemDesc - a string value (required)
 *      recipient - a string value (e-mail address, required)
 *      merchantName - a string value (required)
 */
SAiOSPaypalPlugin.prototype.setPaymentInfo = function(paymentProperties)
{
	PhoneGap.exec("SAiOSPaypalPlugin.setPaymentInfo", paymentProperties);
}



/**
 * Install function
 */
SAiOSPaypalPlugin.install = function()
{
	if ( !window.plugins ) {
		window.plugins = {};
	} 
	if ( !window.plugins.paypal ) {
		window.plugins.paypal = new SAiOSPaypalPlugin();
	}
}

/**
 * Add to PhoneGap constructor
 */
PhoneGap.addConstructor(SAiOSPaypalPlugin.install);