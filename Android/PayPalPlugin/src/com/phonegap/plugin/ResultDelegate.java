/* PayPal PhoneGap Plugin - Delegate class to return result via PhoneGap event from PayPal pay
*
* Copyright (C) 2011, Appception, Inc.. All Rights Reserved.
* Copyright (C) 2011, Mobile Developer Solutions All Rights Reserved.
*/

package com.phonegap.plugin;

import java.io.Serializable;

import com.paypal.android.MEP.PayPalResultDelegate;

public class ResultDelegate implements PayPalResultDelegate, Serializable {

	private static final long serialVersionUID = 10001L;
	
	private void fireJavaScriptEvent(String event, String JSONstring) {
		PayPalPlugin.thisPlugin.webView.loadUrl("javascript:" +
				"(function() {" +
				"var e = document.createEvent('Events');" +
				"e.initEvent('" + event + "');" +
				"e.result = '"+ JSONstring + "';" +
				"document.dispatchEvent(e);" +
				"})();");
	}

	/**
	 * Notification that the payment has been completed successfully.
	 * 
	 * @param payKey			the pay key for the payment
	 * @param paymentStatus		the status of the transaction
	 */
	public void onPaymentSucceeded(String payKey, String paymentStatus) {
		fireJavaScriptEvent("PaypalPaymentEvent.Success", 
				mpl.getPaymentResults("SUCCESS",
						"You have successfully completed your transaction.",
						"Key: " + payKey));	
		// fireEvent would be simpler to call but doesn't support adding data to event
//		PayPalPlugin.thisPlugin.webView.loadUrl("javascript:PhoneGap.fireEvent('PaypalPaymentEvent.Success');");
	}

	/**
	 * Notification that the payment has failed.
	 * 
	 * @param paymentStatus		the status of the transaction
	 * @param correlationID		the correlationID for the transaction failure
	 * @param payKey			the pay key for the payment
	 * @param errorID			the ID of the error that occurred
	 * @param errorMessage		the error message for the error that occurred
	 */
	public void onPaymentFailed(String paymentStatus, String correlationID,
			String payKey, String errorID, String errorMessage) {
		
		fireJavaScriptEvent("PaypalPaymentEvent.Success", 
				mpl.getPaymentResults("FAILURE",
						errorMessage,
						"Error ID: " + errorID + "\nCorrelation ID: "
						+ correlationID + "\nPay Key: " + payKey));	
	}

	/**
	 * Notification that the payment was canceled.
	 * 
	 * @param paymentStatus		the status of the transaction
	 */
	public void onPaymentCanceled(String paymentStatus) {
		fireJavaScriptEvent("PaypalPaymentEvent.Success", 
				mpl.getPaymentResults("CANCELED",
						"The transaction has been cancelled.",
						""));
	}
}
