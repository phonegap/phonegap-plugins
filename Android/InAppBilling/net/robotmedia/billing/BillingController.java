/*   Copyright 2011 Robot Media SL (http://www.robotmedia.net)
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

package net.robotmedia.billing;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import net.robotmedia.billing.model.Transaction;
import net.robotmedia.billing.model.TransactionManager;
import net.robotmedia.billing.security.DefaultSignatureValidator;
import net.robotmedia.billing.security.ISignatureValidator;
import net.robotmedia.billing.utils.Compatibility;
import net.robotmedia.billing.utils.Security;

import android.app.Activity;
import android.app.PendingIntent;
import android.app.PendingIntent.CanceledException;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;

public class BillingController {

	public static enum BillingStatus {
		UNKNOWN, SUPPORTED, UNSUPPORTED
	}

	/**
	 * Used to provide on-demand values to the billing controller.
	 */
	public interface IConfiguration {

		/**
		 * Returns a salt for the obfuscation of purchases in local memory.
		 * 
		 * @return array of 20 random bytes.
		 */
		public byte[] getObfuscationSalt();

		/**
		 * Returns the public key used to verify the signature of responses of
		 * the Market Billing service.
		 * 
		 * @return Base64 encoded public key.
		 */
		public String getPublicKey();
	}

	private static BillingStatus billingStatus = BillingStatus.UNKNOWN;
	private static BillingStatus subscriptionStatus = BillingStatus.UNKNOWN;

	private static Set<String> automaticConfirmations = new HashSet<String>();
	private static IConfiguration configuration = null;
	private static boolean debug = false;
	private static ISignatureValidator validator = null;

	private static final String JSON_NONCE = "nonce";
	private static final String JSON_ORDERS = "orders";
	private static HashMap<String, Set<String>> manualConfirmations = new HashMap<String, Set<String>>();

	private static Set<IBillingObserver> observers = new HashSet<IBillingObserver>();

	public static final String LOG_TAG = "Billing";

	private static HashMap<Long, BillingRequest> pendingRequests = new HashMap<Long, BillingRequest>();

	/**
	 * Adds the specified notification to the set of manual confirmations of the
	 * specified item.
	 * 
	 * @param itemId
	 *            id of the item.
	 * @param notificationId
	 *            id of the notification.
	 */
	private static final void addManualConfirmation(String itemId, String notificationId) {
		Set<String> notifications = manualConfirmations.get(itemId);
		if (notifications == null) {
			notifications = new HashSet<String>();
			manualConfirmations.put(itemId, notifications);
		}
		notifications.add(notificationId);
	}

	/**
	 * Returns the in-app product billing support status, and checks it
	 * asynchronously if it is currently unknown. Observers will receive a
	 * {@link IBillingObserver#onBillingChecked(boolean)} notification in either
	 * case.
	 * <p>
	 * In-app product support does not imply subscription support. To check if
	 * subscriptions are supported, use
	 * {@link BillingController#checkSubscriptionSupported(Context)}.
	 * </p>
	 * 
	 * @param context
	 * @return the current in-app product billing support status (unknown,
	 *         supported or unsupported). If it is unsupported, subscriptions
	 *         are also unsupported.
	 * @see IBillingObserver#onBillingChecked(boolean)
	 * @see BillingController#checkSubscriptionSupported(Context)
	 */
	public static BillingStatus checkBillingSupported(Context context) {
		if (billingStatus == BillingStatus.UNKNOWN) {
			BillingService.checkBillingSupported(context);
		} else {
			boolean supported = billingStatus == BillingStatus.SUPPORTED;
			onBillingChecked(supported);
		}
		return billingStatus;
	}

	/**
	 * <p>
	 * Returns the subscription billing support status, and checks it
	 * asynchronously if it is currently unknown. Observers will receive a
	 * {@link IBillingObserver#onSubscriptionChecked(boolean)} notification in
	 * either case.
	 * </p>
	 * <p>
	 * No support for subscriptions does not imply that in-app products are also
	 * unsupported. To check if in-app products are supported, use
	 * {@link BillingController#checkBillingSupported(Context)}.
	 * </p>
	 * 
	 * @param context
	 * @return the current subscription billing status (unknown, supported or
	 *         unsupported). If it is supported, in-app products are also
	 *         supported.
	 * @see IBillingObserver#onSubscriptionChecked(boolean)
	 * @see BillingController#checkBillingSupported(Context)
	 */
	public static BillingStatus checkSubscriptionSupported(Context context) {
		if (subscriptionStatus == BillingStatus.UNKNOWN) {
			BillingService.checkSubscriptionSupported(context);
		} else {
			boolean supported = subscriptionStatus == BillingStatus.SUPPORTED;
			onSubscriptionChecked(supported);
		}
		return subscriptionStatus;
	}

	/**
	 * Requests to confirm all pending notifications for the specified item.
	 * 
	 * @param context
	 * @param itemId
	 *            id of the item whose purchase must be confirmed.
	 * @return true if pending notifications for this item were found, false
	 *         otherwise.
	 */
	public static boolean confirmNotifications(Context context, String itemId) {
		final Set<String> notifications = manualConfirmations.get(itemId);
		if (notifications != null) {
			confirmNotifications(context, notifications.toArray(new String[] {}));
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Requests to confirm all specified notifications.
	 * 
	 * @param context
	 * @param notifyIds
	 *            array with the ids of all the notifications to confirm.
	 */
	private static void confirmNotifications(Context context, String[] notifyIds) {
		BillingService.confirmNotifications(context, notifyIds);
	}

	/**
	 * Returns the number of purchases for the specified item. Refunded and
	 * cancelled purchases are not subtracted. See
	 * {@link #countPurchasesNet(Context, String)} if they need to be.
	 * 
	 * @param context
	 * @param itemId
	 *            id of the item whose purchases will be counted.
	 * @return number of purchases for the specified item.
	 */
	public static int countPurchases(Context context, String itemId) {
		final byte[] salt = getSalt();
		itemId = salt != null ? Security.obfuscate(context, salt, itemId) : itemId;
		return TransactionManager.countPurchases(context, itemId);
	}

	protected static void debug(String message) {
		if (debug) {
			Log.d(LOG_TAG, message);
		}
	}

	/**
	 * Requests purchase information for the specified notification. Immediately
	 * followed by a call to
	 * {@link #onPurchaseInformationResponse(long, boolean)} and later to
	 * {@link #onPurchaseStateChanged(Context, String, String)}, if the request
	 * is successful.
	 * 
	 * @param context
	 * @param notifyId
	 *            id of the notification whose purchase information is
	 *            requested.
	 */
	private static void getPurchaseInformation(Context context, String notifyId) {
		final long nonce = Security.generateNonce();
		BillingService.getPurchaseInformation(context, new String[] { notifyId }, nonce);
	}

	/**
	 * Gets the salt from the configuration and logs a warning if it's null.
	 * 
	 * @return salt.
	 */
	private static byte[] getSalt() {
		byte[] salt = null;
		if (configuration == null || ((salt = configuration.getObfuscationSalt()) == null)) {
			Log.w(LOG_TAG, "Can't (un)obfuscate purchases without salt");
		}
		return salt;
	}

	/**
	 * Lists all transactions stored locally, including cancellations and
	 * refunds.
	 * 
	 * @param context
	 * @return list of transactions.
	 */
	public static List<Transaction> getTransactions(Context context) {
		List<Transaction> transactions = TransactionManager.getTransactions(context);
		unobfuscate(context, transactions);
		return transactions;
	}

	/**
	 * Lists all transactions of the specified item, stored locally.
	 * 
	 * @param context
	 * @param itemId
	 *            id of the item whose transactions will be returned.
	 * @return list of transactions.
	 */
	public static List<Transaction> getTransactions(Context context, String itemId) {
		final byte[] salt = getSalt();
		itemId = salt != null ? Security.obfuscate(context, salt, itemId) : itemId;
		List<Transaction> transactions = TransactionManager.getTransactions(context, itemId);
		unobfuscate(context, transactions);
		return transactions;
	}

	/**
	 * Returns true if the specified item has been registered as purchased in
	 * local memory, false otherwise. Also note that the item might have been
	 * purchased in another installation, but not yet registered in this one.
	 * 
	 * @param context
	 * @param itemId
	 *            item id.
	 * @return true if the specified item is purchased, false otherwise.
	 */
	public static boolean isPurchased(Context context, String itemId) {
		final byte[] salt = getSalt();
		itemId = salt != null ? Security.obfuscate(context, salt, itemId) : itemId;
		return TransactionManager.isPurchased(context, itemId);
	}

	/**
	 * Notifies observers of the purchase state change of the specified item.
	 * 
	 * @param itemId
	 *            id of the item whose purchase state has changed.
	 * @param state
	 *            new purchase state of the item.
	 */
	private static void notifyPurchaseStateChange(String itemId, Transaction.PurchaseState state) {
		for (IBillingObserver o : observers) {
			o.onPurchaseStateChanged(itemId, state);
		}
	}

	/**
	 * Obfuscates the specified purchase. Only the order id, product id and
	 * developer payload are obfuscated.
	 * 
	 * @param context
	 * @param purchase
	 *            purchase to be obfuscated.
	 * @see #unobfuscate(Context, Transaction)
	 */
	static void obfuscate(Context context, Transaction purchase) {
		final byte[] salt = getSalt();
		if (salt == null) {
			return;
		}
		purchase.orderId = Security.obfuscate(context, salt, purchase.orderId);
		purchase.productId = Security.obfuscate(context, salt, purchase.productId);
		purchase.developerPayload = Security.obfuscate(context, salt, purchase.developerPayload);
	}

	/**
	 * Called after the response to a
	 * {@link net.robotmedia.billing.request.CheckBillingSupported} request is
	 * received.
	 * 
	 * @param supported
	 */
	protected static void onBillingChecked(boolean supported) {
		billingStatus = supported ? BillingStatus.SUPPORTED : BillingStatus.UNSUPPORTED;
		if (billingStatus == BillingStatus.UNSUPPORTED) { // Save us the
															// subscription
															// check
			subscriptionStatus = BillingStatus.UNSUPPORTED;
		}
		for (IBillingObserver o : observers) {
			o.onBillingChecked(supported);
		}
	}

	/**
	 * Called when an IN_APP_NOTIFY message is received.
	 * 
	 * @param context
	 * @param notifyId
	 *            notification id.
	 */
	protected static void onNotify(Context context, String notifyId) {
		debug("Notification " + notifyId + " available");

		getPurchaseInformation(context, notifyId);
	}

	/**
	 * Called after the response to a
	 * {@link net.robotmedia.billing.request.RequestPurchase} request is
	 * received.
	 * 
	 * @param itemId
	 *            id of the item whose purchase was requested.
	 * @param purchaseIntent
	 *            intent to purchase the item.
	 */
	protected static void onPurchaseIntent(String itemId, PendingIntent purchaseIntent) {
		for (IBillingObserver o : observers) {
			o.onPurchaseIntent(itemId, purchaseIntent);
		}
	}

	/**
	 * Called after the response to a
	 * {@link net.robotmedia.billing.request.GetPurchaseInformation} request is
	 * received. Registers all transactions in local memory and confirms those
	 * who can be confirmed automatically.
	 * 
	 * @param context
	 * @param signedData
	 *            signed JSON data received from the Market Billing service.
	 * @param signature
	 *            data signature.
	 */
	protected static void onPurchaseStateChanged(Context context, String signedData, String signature) {
		debug("Purchase state changed");
		
		if (TextUtils.isEmpty(signedData)) {
			Log.w(LOG_TAG, "Signed data is empty");
			return;
		} else {
			debug(signedData);
		}

		if (!debug) {
			if (TextUtils.isEmpty(signature)) {
				Log.w(LOG_TAG, "Empty signature requires debug mode");
				return;
			}
			final ISignatureValidator validator = BillingController.validator != null ? BillingController.validator
					: new DefaultSignatureValidator(BillingController.configuration);
			if (!validator.validate(signedData, signature)) {
				Log.w(LOG_TAG, "Signature does not match data.");
				return;
			}
		}

		List<Transaction> purchases;
		try {
			JSONObject jObject = new JSONObject(signedData);
			if (!verifyNonce(jObject)) {
				Log.w(LOG_TAG, "Invalid nonce");
				return;
			}
			purchases = parsePurchases(jObject);
		} catch (JSONException e) {
			Log.e(LOG_TAG, "JSON exception: ", e);
			return;
		}

		ArrayList<String> confirmations = new ArrayList<String>();
		for (Transaction p : purchases) {
			if (p.notificationId != null && automaticConfirmations.contains(p.productId)) {
				confirmations.add(p.notificationId);
			} else {
				// TODO: Discriminate between purchases, cancellations and
				// refunds.
				addManualConfirmation(p.productId, p.notificationId);
			}
			storeTransaction(context, p);
			notifyPurchaseStateChange(p.productId, p.purchaseState);
		}
		if (!confirmations.isEmpty()) {
			final String[] notifyIds = confirmations.toArray(new String[confirmations.size()]);
			confirmNotifications(context, notifyIds);
		}
	}

	/**
	 * Called after a {@link net.robotmedia.billing.BillingRequest} is sent.
	 * 
	 * @param requestId
	 *            the id the request.
	 * @param request
	 *            the billing request.
	 */
	protected static void onRequestSent(long requestId, BillingRequest request) {
		debug("Request " + requestId + " of type " + request.getRequestType() + " sent");

		if (request.isSuccess()) {
			pendingRequests.put(requestId, request);
		} else if (request.hasNonce()) {
			Security.removeNonce(request.getNonce());
		}
	}

	/**
	 * Called after a {@link net.robotmedia.billing.BillingRequest} is sent.
	 * 
	 * @param context
	 * @param requestId
	 *            the id of the request.
	 * @param responseCode
	 *            the response code.
	 * @see net.robotmedia.billing.request.ResponseCode
	 */
	protected static void onResponseCode(Context context, long requestId, int responseCode) {
		final BillingRequest.ResponseCode response = BillingRequest.ResponseCode.valueOf(responseCode);
		debug("Request " + requestId + " received response " + response);

		final BillingRequest request = pendingRequests.get(requestId);
		if (request != null) {
			pendingRequests.remove(requestId);
			request.onResponseCode(response);
		}
	}

	/**
	 * Called after the response to a
	 * {@link net.robotmedia.billing.request.CheckSubscriptionSupported} request
	 * is received.
	 * 
	 * @param supported
	 */
	protected static void onSubscriptionChecked(boolean supported) {
		subscriptionStatus = supported ? BillingStatus.SUPPORTED : BillingStatus.UNSUPPORTED;
		if (subscriptionStatus == BillingStatus.SUPPORTED) { // Save us the
																// billing check
			billingStatus = BillingStatus.SUPPORTED;
		}
		for (IBillingObserver o : observers) {
			o.onSubscriptionChecked(supported);
		}
	}

	protected static void onTransactionsRestored() {
		for (IBillingObserver o : observers) {
			o.onTransactionsRestored();
		}
	}

	/**
	 * Parse all purchases from the JSON data received from the Market Billing
	 * service.
	 * 
	 * @param data
	 *            JSON data received from the Market Billing service.
	 * @return list of purchases.
	 * @throws JSONException
	 *             if the data couldn't be properly parsed.
	 */
	private static List<Transaction> parsePurchases(JSONObject data) throws JSONException {
		ArrayList<Transaction> purchases = new ArrayList<Transaction>();
		JSONArray orders = data.optJSONArray(JSON_ORDERS);
		int numTransactions = 0;
		if (orders != null) {
			numTransactions = orders.length();
		}
		for (int i = 0; i < numTransactions; i++) {
			JSONObject jElement = orders.getJSONObject(i);
			Transaction p = Transaction.parse(jElement);
			purchases.add(p);
		}
		return purchases;
	}

	/**
	 * Registers the specified billing observer.
	 * 
	 * @param observer
	 *            the billing observer to add.
	 * @return true if the observer wasn't previously registered, false
	 *         otherwise.
	 * @see #unregisterObserver(IBillingObserver)
	 */
	public static boolean registerObserver(IBillingObserver observer) {
		return observers.add(observer);
	}

	/**
	 * Requests the purchase of the specified item. The transaction will not be
	 * confirmed automatically.
	 * <p>
	 * For subscriptions, use {@link #requestSubscription(Context, String)}
	 * instead.
	 * </p>
	 * 
	 * @param context
	 * @param itemId
	 *            id of the item to be purchased.
	 * @see #requestPurchase(Context, String, boolean)
	 */
	public static void requestPurchase(Context context, String itemId) {
		requestPurchase(context, itemId, false, null);
	}

	/**
	 * <p>
	 * Requests the purchase of the specified item with optional automatic
	 * confirmation.
	 * </p>
	 * <p>
	 * For subscriptions, use
	 * {@link #requestSubscription(Context, String, boolean, String)} instead.
	 * </p>
	 * 
	 * @param context
	 * @param itemId
	 *            id of the item to be purchased.
	 * @param confirm
	 *            if true, the transaction will be confirmed automatically. If
	 *            false, the transaction will have to be confirmed with a call
	 *            to {@link #confirmNotifications(Context, String)}.
	 * @param developerPayload
	 *            a developer-specified string that contains supplemental
	 *            information about the order.
	 * @see IBillingObserver#onPurchaseIntent(String, PendingIntent)
	 */
	public static void requestPurchase(Context context, String itemId, boolean confirm, String developerPayload) {
		if (confirm) {
			automaticConfirmations.add(itemId);
		}
		BillingService.requestPurchase(context, itemId, developerPayload);
	}

	/**
	 * Requests the purchase of the specified subscription item. The transaction
	 * will not be confirmed automatically.
	 * 
	 * @param context
	 * @param itemId
	 *            id of the item to be purchased.
	 * @see #requestSubscription(Context, String, boolean, String)
	 */
	public static void requestSubscription(Context context, String itemId) {
		requestSubscription(context, itemId, false, null);
	}

	/**
	 * Requests the purchase of the specified subscription item with optional
	 * automatic confirmation.
	 * 
	 * @param context
	 * @param itemId
	 *            id of the item to be purchased.
	 * @param confirm
	 *            if true, the transaction will be confirmed automatically. If
	 *            false, the transaction will have to be confirmed with a call
	 *            to {@link #confirmNotifications(Context, String)}.
	 * @param developerPayload
	 *            a developer-specified string that contains supplemental
	 *            information about the order.
	 * @see IBillingObserver#onPurchaseIntent(String, PendingIntent)
	 */
	public static void requestSubscription(Context context, String itemId, boolean confirm, String developerPayload) {
		if (confirm) {
			automaticConfirmations.add(itemId);
		}
		BillingService.requestSubscription(context, itemId, developerPayload);
	}

	/**
	 * Requests to restore all transactions.
	 * 
	 * @param context
	 */
	public static void restoreTransactions(Context context) {
		final long nonce = Security.generateNonce();
		BillingService.restoreTransations(context, nonce);
	}

	/**
	 * Sets the configuration instance of the controller.
	 * 
	 * @param config
	 *            configuration instance.
	 */
	public static void setConfiguration(IConfiguration config) {
		configuration = config;
	}

	/**
	 * Sets debug mode.
	 * 
	 * @param value
	 */
	public static final void setDebug(boolean value) {
		debug = value;
	}

	/**
	 * Sets a custom signature validator. If no custom signature validator is
	 * provided,
	 * {@link net.robotmedia.billing.signature.DefaultSignatureValidator} will
	 * be used.
	 * 
	 * @param validator
	 *            signature validator instance.
	 */
	public static void setSignatureValidator(ISignatureValidator validator) {
		BillingController.validator = validator;
	}

	/**
	 * Starts the specified purchase intent with the specified activity.
	 * 
	 * @param activity
	 * @param purchaseIntent
	 *            purchase intent.
	 * @param intent
	 */
	public static void startPurchaseIntent(Activity activity, PendingIntent purchaseIntent, Intent intent) {
		if (Compatibility.isStartIntentSenderSupported()) {
			// This is on Android 2.0 and beyond. The in-app buy page activity
			// must be on the activity stack of the application.
			Compatibility.startIntentSender(activity, purchaseIntent.getIntentSender(), intent);
		} else {
			// This is on Android version 1.6. The in-app buy page activity must
			// be on its own separate activity stack instead of on the activity
			// stack of the application.
			try {
				purchaseIntent.send(activity, 0 /* code */, intent);
			} catch (CanceledException e) {
				Log.e(LOG_TAG, "Error starting purchase intent", e);
			}
		}
	}

	static void storeTransaction(Context context, Transaction t) {
		final Transaction t2 = t.clone();
		obfuscate(context, t2);
		TransactionManager.addTransaction(context, t2);
	}

	static void unobfuscate(Context context, List<Transaction> transactions) {
		for (Transaction p : transactions) {
			unobfuscate(context, p);
		}
	}

	/**
	 * Unobfuscate the specified purchase.
	 * 
	 * @param context
	 * @param purchase
	 *            purchase to unobfuscate.
	 * @see #obfuscate(Context, Transaction)
	 */
	static void unobfuscate(Context context, Transaction purchase) {
		final byte[] salt = getSalt();
		if (salt == null) {
			return;
		}
		purchase.orderId = Security.unobfuscate(context, salt, purchase.orderId);
		purchase.productId = Security.unobfuscate(context, salt, purchase.productId);
		purchase.developerPayload = Security.unobfuscate(context, salt, purchase.developerPayload);
	}

	/**
	 * Unregisters the specified billing observer.
	 * 
	 * @param observer
	 *            the billing observer to unregister.
	 * @return true if the billing observer was unregistered, false otherwise.
	 * @see #registerObserver(IBillingObserver)
	 */
	public static boolean unregisterObserver(IBillingObserver observer) {
		return observers.remove(observer);
	}

	private static boolean verifyNonce(JSONObject data) {
		long nonce = data.optLong(JSON_NONCE);
		if (Security.isNonceKnown(nonce)) {
			Security.removeNonce(nonce);
			return true;
		} else {
			return false;
		}
	}

	protected static void onRequestPurchaseResponse(String itemId, BillingRequest.ResponseCode response) {
		for (IBillingObserver o : observers) {
			o.onRequestPurchaseResponse(itemId, response);
		}
	}

}
