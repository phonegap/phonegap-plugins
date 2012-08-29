/* PayPal Mobile Payment Library - JavaScript-Java bridge
 *
 * Copyright (C) 2011, Appception, Inc.. All Rights Reserved.
 * Copyright (C) 2011, Mobile Developer Solutions All Rights Reserved.
 * Copyright (C) 2012, Bucka IT, Tomaz Kregar s.p. All Rights Reserved.
 */

package com.phonegap.plugin;

import java.math.BigDecimal;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import com.paypal.android.MEP.PayPal;
import com.paypal.android.MEP.PayPalInvoiceData;
import com.paypal.android.MEP.PayPalInvoiceItem;
import com.paypal.android.MEP.PayPalPayment;
import com.paypal.android.MEP.PayPalPreapproval;
import org.apache.cordova.DroidGap;

public class mpl {

    mpl mpjs_mpl = this;
    Context mpl_context;
    Activity mpl_activity;

    // Default configuration
    String mpjs_language = "en_US";
    String mpjs_fees = "receiver";
    String mpjs_shipping = "0";
    String mpjs_dynamic = "0";

    String mpjs_subtotal = "0.0";
    String mpjs_currency = "JPY";
    String mpjs_recipient = "nobody@nobody.com";
    String mpjs_paymentType = "goods";
    String mpjs_merchantName = "";
    String mpjs_description = "";
    String mpjs_customID = "0.0";
    String mpjs_ipnUrl = "0.0";
    String mpjs_memo = "0.0";
    String mpjs_tax = "0.0";
// TBD: list of invoice items
    String mpjs_name = "";
    String mpjs_id = "";
    String mpjs_totalPrice = "0.0";
    String mpjs_unitPrice = "0.0";
    String mpjs_quantity = "0";
    
    private String mpjs_server = "";
	
    // The PayPal server to be used - can also be ENV_NONE and ENV_LIVE
    // N.B. server and applID now dynamic
    //    private static final int server = PayPal.ENV_SANDBOX;
    //    private static int server = PayPal.ENV_NONE;
    private int server = PayPal.ENV_NONE; // default standalone
    // The ID of your application that you received from PayPal
    //    private static String appID = "APP-80W284485P519543T";
    //    private static String appID = "";
    private String appID = "";  //default standalone

    public static final String build = "10.12.09.8053";

    // UI message types
    protected static final int MPJS_INITIALIZE_SUCCESS = 0;
    protected static final int MPJS_INITIALIZE_FAILURE = 1;
    protected static final int MPJS_INITIALIZE = 2;
    protected static final int MPJS_GET_STATUS = 3;
    protected static final int MPJS_GET_BUTTON = 4;
    protected static final int MPJS_CLICK_BUTTON = 5;
    protected static final int MPJS_INITIALIZE_NATIVE = 6;
    protected static final int MPJS_SHOW = 10;
    protected static final int MPJS_HIDE = 11;

	// Construct new instance with information from main activity
	public mpl(Context context, int serverType, String serverAppId) {
		mpl_activity = (Activity) context;
		mpl_context = context.getApplicationContext();
		server = serverType;
		appID = serverAppId;
	}
	
	// Construct new instance with information from main activity
	public mpl(Context ctx, String JSONdata) {
		mpl_activity = (Activity) ctx;
		mpl_context = ctx.getApplicationContext();
		parseConstructArg(JSONdata);
		if (mpjs_server.equals("ENV_NONE")) {
			server = PayPal.ENV_NONE;
		} else if (mpjs_server.equals("ENV_SANDBOX")) {
			server = PayPal.ENV_SANDBOX;
		} else if (mpjs_server.equals("ENV_LIVE")) {
			server = PayPal.ENV_LIVE;
		}
	}

	/**
	 * The initLibrary function takes care of all the basic Library
	 * initialization.
	 * 
	 * @return The return will be true if the initialization was successful and
	 *         false if
	 */
	private void initLibrary() {
		Log.i("mpl", "initLibrary");
		PayPal pp = PayPal.getInstance();

		// If the library is already initialized, then we don't need to
		// initialize it again.
		if (pp == null) {
			// This is the main initialization call that takes in your Context,
			// the Application ID, and the server you would like to connect to.
			try {
				pp = PayPal.initWithAppID(mpl_context, appID, server);
			} catch (IllegalStateException e) {
				throw new RuntimeException(e);
			}

			// -- These are required settings.
			if (mpjs_language.equals(""))
				pp.setLanguage("en_US"); // Sets the language for the library.
			else
				pp.setLanguage(mpjs_language); // Sets the language for the
												// library.

			// Set to true if the transaction will require shipping.
			if (mpjs_shipping.equals("1"))
				pp.setShippingEnabled(true);
			else
				pp.setShippingEnabled(false);

			// Dynamic Amount Calculation allows you to set tax and shipping
			// amounts based on the user's shipping address. Shipping must be
			// enabled for Dynamic Amount Calculation. This also requires you to
			// create a class that implements PaymentAdjuster and Serializable.
			// pp.setDynamicAmountCalculationEnabled(false);
			// --
		}
	}
	private void parseConstructArg(String str) {
		JSONObject obj;

		if (TextUtils.isEmpty(str))
			return;

		try {
			obj = (JSONObject) new JSONTokener(str).nextValue();
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			mpjs_server = obj.getString("server");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			appID = obj.getString("appId");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
	}

	// Helper for: Submit payment
	private PayPalPayment getSimplePayment() {
		int ptype = PayPal.PAYMENT_TYPE_GOODS;
		PayPalPayment payment = new PayPalPayment();
		payment.setSubtotal(new BigDecimal(mpjs_subtotal));
		payment.setCurrencyType(mpjs_currency);
		payment.setRecipient(mpjs_recipient);
		if (mpjs_paymentType.equals("goods"))
			ptype = PayPal.PAYMENT_TYPE_GOODS;
		else if (mpjs_paymentType.equals("service"))
			ptype = PayPal.PAYMENT_TYPE_SERVICE;
		else if (mpjs_paymentType.equals("personal"))
			ptype = PayPal.PAYMENT_TYPE_PERSONAL;
		else if (mpjs_paymentType.equals("none"))
			ptype = PayPal.PAYMENT_TYPE_NONE;
		payment.setPaymentType(ptype);

		if (!mpjs_tax.equals("") || !mpjs_shipping.equals("")) {
			// PayPalInvoiceData can contain tax and shipping amounts. It also
			// contains an ArrayList of PayPalInvoiceItem which can
			// be filled out. These are not required for any transaction.
			PayPalInvoiceData invoice = new PayPalInvoiceData();
			// Sets the tax amount.
			invoice.setTax(new BigDecimal(mpjs_tax));
			// Sets the shipping amount.
			invoice.setShipping(new BigDecimal(mpjs_shipping));

			// PayPalInvoiceItem has several parameters available to it.
			// None of these parameters is required.
			PayPalInvoiceItem item1 = new PayPalInvoiceItem();
			// Sets the name of the item.
			item1.setName(mpjs_name);
			// Sets the ID. This is any ID that you would like to have
			// associated with the item.
			item1.setID(mpjs_id);
			// Sets the total price which should be (quantity * unit price).
			// The total prices of all PayPalInvoiceItem should add up
			// to less than or equal the subtotal of the payment.
			item1.setTotalPrice(new BigDecimal(mpjs_totalPrice));
			// Sets the unit price.
			item1.setUnitPrice(new BigDecimal(mpjs_unitPrice));
			// Sets the quantity.
			item1.setQuantity(Integer.parseInt(mpjs_quantity));
			// Add the PayPalInvoiceItem to the PayPalInvoiceData.
			// Alternatively, you can create an ArrayList<PayPalInvoiceItem>
			// and pass it to the PayPalInvoiceData function
			// setInvoiceItems().
			invoice.getInvoiceItems().add(item1);

			// Sets the PayPalPayment invoice data.
			payment.setInvoiceData(invoice);
		}

		if (mpjs_merchantName.equals("") || mpjs_description.equals("")
				|| mpjs_customID.equals("") || mpjs_ipnUrl.equals("")
				|| mpjs_memo.equals("")) {
			;
		} else {
			// Sets the merchant name. This is the name of your Application or
			// Company.
			payment.setMerchantName(mpjs_merchantName);
			// Sets the description of the payment.
			payment.setDescription(mpjs_description);
			// Sets the Custom ID. This is any ID that you would like to have
			// associated with the payment.
			payment.setCustomID(mpjs_customID);
			// Sets the Instant Payment Notification url. This url will be hit
			// by the PayPal server upon completion of the payment.
			payment.setIpnUrl(mpjs_ipnUrl);
			// Sets the memo. This memo will be part of the notification sent by
			// PayPal to the necessary parties.
			payment.setMemo(mpjs_memo);
		}

		return payment;
	}

	//
	// External API - may be exported and accessed from JavaScript
	//

	// Initialize PayPal library
	private void initialize() {

		// Initialize the library. We'll do it in a separate thread because it
		// requires communication with the server
		// which may take some time depending on the connection strength/speed.
		Thread libraryInitializationThread = new Thread() {
			public void run() {
				initLibrary();

				// The library is initialized so let's create our CheckoutButton
				// and update the UI.
				if (PayPal.getInstance().isLibraryInitialized()) {
					// hRefresh.sendEmptyMessage(MPJS_INITIALIZE_SUCCESS);
				} else {
					// hRefresh.sendEmptyMessage(MPJS_INITIALIZE_FAILURE);
				}
			}
		};
		libraryInitializationThread.start();
	}

	// Get PayPal library initialization status
	public String getStatus() {
		PayPal pp = PayPal.getInstance();
		Log.i("mpl", "getStatus: after instance");
		if (pp == null)
			return "0";
		if (pp.isLibraryInitialized()) {
			Log.i("mpl", "getStatus: after instance1");
			return "1";
		} else
			return "0";
	}

	// Set simple payment details - no throw in catch block implies optional field
	public void setPaymentInfo(String str) {

		JSONObject obj;
		try {
			obj = (JSONObject) new JSONTokener(str).nextValue();
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			mpjs_mpl.mpjs_subtotal = obj.getString("paymentAmount");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			mpjs_mpl.mpjs_currency = obj.getString("paymentCurrency");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			mpjs_mpl.mpjs_recipient = obj.getString("recipient");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			mpjs_mpl.mpjs_description = obj.getString("itemDesc");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			mpjs_mpl.mpjs_merchantName = obj.getString("merchantName");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}

		// Optional parameters
		try {
			mpjs_mpl.mpjs_customID = obj.getString("customID");
		} catch (JSONException e) {

		}
		try {
			mpjs_mpl.mpjs_ipnUrl = obj.getString("ipnUrl");
		} catch (JSONException e) {

		}
		try {
		    mpjs_mpl.mpjs_language = obj.getString("language");
		} catch (JSONException e) {

		}
		try {
		    mpjs_mpl.mpjs_fees = obj.getString("fees");
		} catch (JSONException e) {

		}
		try {
		    mpjs_mpl.mpjs_shipping = obj.getString("shipping");
		} catch (JSONException e) {
		    
		}
		try {
		    mpjs_mpl.mpjs_dynamic = obj.getString("dynamic");
		} catch (JSONException e) {
		    
		}
		try {
			mpjs_mpl.mpjs_memo = obj.getString("memo");
		} catch (JSONException e) {
		    throw new RuntimeException(e);
		}
		try {
			mpjs_mpl.mpjs_tax = obj.getString("tax");
		} catch (JSONException e) {
			 
		}
	}


	// Set an invoice item
	protected void setInvoiceItem(String str) {
		JSONObject obj;
		try {
			obj = (JSONObject) new JSONTokener(str).nextValue();
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			mpjs_mpl.mpjs_name = obj.getString("name");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			mpjs_mpl.mpjs_id = obj.getString("id");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			mpjs_mpl.mpjs_totalPrice = obj.getString("total_price");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			mpjs_mpl.mpjs_unitPrice = obj.getString("unit_price");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			mpjs_mpl.mpjs_quantity = obj.getString("quantity");
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
	}

	// Submit payment (i.e. "checkout")
	public void pay(Integer btype) {
		PayPalPayment payment;

		PayPal pp = PayPal.getInstance();
		if (pp == null)
			return;

		// mpjs_buttonType;

		// TBD: payment type: simple, parallel, chained
		payment = getSimplePayment();

		// Intent checkoutIntent = PayPal.getInstance().checkout(payment, this);
		Intent checkoutIntent = pp.checkout(payment, mpl_context,
				new ResultDelegate());

		// The next two lines should be exchanged for the following commented
		// line when PhoneGap is not used
		DroidGap dgActivity = (DroidGap) mpl_activity;
		dgActivity.startActivityForResult(PayPalPlugin.thisPlugin,
				checkoutIntent, 1);
		// mpl_activity.startActivityForResult(checkoutIntent, 1);
	}

	// JSONify results of payment
	protected static String getPaymentResults(String resultTitle,
			String resultInfo, String resultExtra) {
		JSONObject obj;
		String str;
		obj = new JSONObject();

		try {
			obj.put("result_title", resultTitle);
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			obj.put("result_info", resultInfo);
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		try {
			obj.put("result_extra", resultExtra);
		} catch (JSONException e) {
			throw new RuntimeException(e);
		}
		str = obj.toString();

		return str;
	}

	public void preapproval() {
		PayPalPreapproval preapproval = new PayPalPreapproval();
		preapproval.setCurrencyType("USD");
		preapproval.setMerchantName("Preapproval Merchant");
		Intent preapproveIntent = PayPal.getInstance().preapprove(preapproval,
				mpl_context, new ResultDelegate());
		mpl_activity.startActivityForResult(preapproveIntent, 1);
	}

	// Test function: echo a string back to caller
	public String echo(String str) {
		return str;
	}

	//
	// iOS I/F (untested)
	//
	public void prepare(int ptype) {
        String str;

        str = "goods";
        if (ptype == PayPal.PAYMENT_TYPE_GOODS)
            str = "goods";
        else if (ptype == PayPal.PAYMENT_TYPE_SERVICE)
                str = "service";
        else if (ptype == PayPal.PAYMENT_TYPE_PERSONAL)
                str = "personal";
        else if (ptype == PayPal.PAYMENT_TYPE_NONE)
                str = "none";
        mpjs_paymentType = str;

        initialize();
	}
}
