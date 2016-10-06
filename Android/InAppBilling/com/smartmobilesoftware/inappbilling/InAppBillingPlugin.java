package com.smartmobilesoftware.inappbilling;

import java.util.ArrayList;
import java.util.List;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.json.JSONArray;

import net.robotmedia.billing.BillingController;
import net.robotmedia.billing.BillingRequest.ResponseCode;
import net.robotmedia.billing.helper.AbstractBillingObserver;
import net.robotmedia.billing.model.Transaction;
import net.robotmedia.billing.model.Transaction.PurchaseState;

import android.app.Activity;
import android.util.Log;

// In app billing plugin
public class InAppBillingPlugin extends Plugin {
	// Yes, that's the two variables to edit :)
	private static final String publicKey = "PASTE_HERE_YOUR_PUBLIC_KEY";
	private static final byte[] salt = { 42, -70, -106, -41, 66, -53, 122,
			-110, -127, -96, -88, 77, 127, 115, 1, 73, 17, 110, 48, -116 };

	private static final String INIT_STRING = "init";
	private static final String PURCHASE_STRING = "purchase";
	private static final String OWN_ITEMS_STRING = "ownItems";
	

	private final String TAG = "BILLING";
	// Observer notified of events
	private AbstractBillingObserver mBillingObserver;
	private Activity activity;
	private String callbackId;

	// Plugin action handler
	public PluginResult execute(String action, JSONArray data, String callbackId) {
		// Save the callback id
		this.callbackId = callbackId;
		PluginResult pluginResult;
		
		if (INIT_STRING.equals(action)) {
			// Initialize the plugin
			initialize();
			// Wait for the restore transaction and billing supported test
			pluginResult = new PluginResult(PluginResult.Status.NO_RESULT);
			pluginResult.setKeepCallback(true);
			return pluginResult;
		} else if (PURCHASE_STRING.equals(action)) {
			// purchase the item
			try {

				// Retrieve parameters
				String productId = data.getString(0);
				// Make the purchase
				BillingController.requestPurchase(this.cordova.getContext(), productId, true /* confirm */, null);

				pluginResult = new PluginResult(PluginResult.Status.NO_RESULT);
				pluginResult.setKeepCallback(true);
			} catch (Exception ex) {
				pluginResult = new PluginResult(
						PluginResult.Status.JSON_EXCEPTION, "Invalid parameter");
			}

			return pluginResult;

		} else if (OWN_ITEMS_STRING.equals(action)){
			// retrieve already bought items
			
			ArrayList<String> ownItems = new ArrayList<String>();
			ownItems = getOwnedItems();
			// convert the list of strings to a json list of strings
			JSONArray ownItemsJson = new JSONArray();
			for (String item : ownItems){
				ownItemsJson.put(item);
			}
			
			// send the result to the app
			pluginResult = new PluginResult(PluginResult.Status.OK, ownItemsJson);
			return pluginResult;
		}

		return null;
	}

	// Initialize the plugin
	private void initialize() {
		BillingController.setDebug(true);
		// configure the in app billing
		BillingController
				.setConfiguration(new BillingController.IConfiguration() {

					public byte[] getObfuscationSalt() {
						return InAppBillingPlugin.salt;
					}

					public String getPublicKey() {
						return InAppBillingPlugin.publicKey;
					}
				});

		// Get the activity from the Plugin
		// Activity test = this.cordova.getContext().
		activity = cordova.getActivity();

		// create a billingObserver
		mBillingObserver = new AbstractBillingObserver(activity) {

			public void onBillingChecked(boolean supported) {
				InAppBillingPlugin.this.onBillingChecked(supported);
			}

			public void onPurchaseStateChanged(String itemId,
					PurchaseState state) {
				InAppBillingPlugin.this.onPurchaseStateChanged(itemId, state);
			}

			public void onRequestPurchaseResponse(String itemId,
					ResponseCode response) {
				InAppBillingPlugin.this.onRequestPurchaseResponse(itemId,
						response);
			}

			public void onSubscriptionChecked(boolean supported) {
				InAppBillingPlugin.this.onSubscriptionChecked(supported);
			}

		};

		// register observer
		BillingController.registerObserver(mBillingObserver);
		BillingController.checkBillingSupported(activity);

	}

	public void onBillingChecked(boolean supported) {
		PluginResult result;
		if (supported) {
			Log.d("BILLING", "In app billing supported");
			// restores previous transactions, if any.
			restoreTransactions();
			result = new PluginResult(PluginResult.Status.OK, "In app billing supported");
			// stop waiting for the callback
			result.setKeepCallback(false);
			// notify the app
			this.success(result, callbackId);
		} else {
			Log.d("BILLING", "In app billing not supported");
			result = new PluginResult(PluginResult.Status.ERROR,
					"In app billing not supported");
			// stop waiting for the callback
			result.setKeepCallback(false);
			// notify the app
			this.error(result, callbackId);
		}

	}

	// change in the purchase
	public void onPurchaseStateChanged(String itemId, PurchaseState state) {
		PluginResult result;

		Log.i(TAG, "onPurchaseStateChanged() itemId: " + itemId);
		
		// Check the status of the purchase
		if(state == PurchaseState.PURCHASED){
			// Item has been purchased :)
			result = new PluginResult(PluginResult.Status.OK, itemId);
			result.setKeepCallback(false);
			this.success(result, callbackId);
		} else {
			// purchase issue
			String message = "";
			if (state == PurchaseState.CANCELLED){
				message = "canceled";
			} else if (state == PurchaseState.REFUNDED){
				message = "refunded";
			} else if (state == PurchaseState.EXPIRED){
				message = "expired";
			} 
			// send the result to the app
			result = new PluginResult(PluginResult.Status.ERROR, message);
			result.setKeepCallback(false);
			this.error(result, callbackId);

		}

		
	}

	// response from the billing server
	public void onRequestPurchaseResponse(String itemId, ResponseCode response) {
		PluginResult result;

		// check the response
		Log.d(TAG, "response code ");
		
		if(response == ResponseCode.RESULT_OK){
			// purchase succeeded
			result = new PluginResult(PluginResult.Status.OK, itemId);
			result.setKeepCallback(false);
			this.success(result, callbackId);
		} else {
			// purchase error
			String message = "";

			// get the error message
			if (response == ResponseCode.RESULT_USER_CANCELED){
				message = "canceled";
			
			} else if (response == ResponseCode.RESULT_SERVICE_UNAVAILABLE){
				message = "network connection error";
			} else if (response == ResponseCode.RESULT_BILLING_UNAVAILABLE){
				message = "in app billing unavailable";
			} else if (response == ResponseCode.RESULT_ITEM_UNAVAILABLE){
				message = "cannot find the item";
			} else if (response == ResponseCode.RESULT_DEVELOPER_ERROR){
				message = "developer error";
			} else if (response == ResponseCode.RESULT_ERROR){
				message = "unexpected server error";
			} 
			// send the result to the app
			result = new PluginResult(PluginResult.Status.ERROR, message);
			result.setKeepCallback(false);
			this.error(result, callbackId);
		}

	}

	public void onSubscriptionChecked(boolean supported) {

	}

	/**
	 * Restores previous transactions, if any. This happens if the application
	 * has just been installed or the user wiped data. We do not want to do this
	 * on every startup, rather, we want to do only when the database needs to
	 * be initialized.
	 */
	private void restoreTransactions() {
		if (!mBillingObserver.isTransactionsRestored()) {
			BillingController.restoreTransactions(this.cordova.getContext());

		}
	}

	// update bought items 
	private ArrayList<String> getOwnedItems() {
		List<Transaction> transactions = BillingController
				.getTransactions(this.cordova.getContext());
		final ArrayList<String> ownedItems = new ArrayList<String>();
		for (Transaction t : transactions) {
			if (t.purchaseState == PurchaseState.PURCHASED) {
				ownedItems.add(t.productId);
			}
		}
		// The list of purchased items is now stored in "ownedItems"

		return ownedItems;

	}

}
