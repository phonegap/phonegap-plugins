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

import android.app.PendingIntent;
import android.os.Bundle;
import android.os.RemoteException;
import android.util.Log;

import com.android.vending.billing.IMarketBillingService;

public abstract class BillingRequest {
	
	public static class CheckBillingSupported extends BillingRequest {
		
    	public CheckBillingSupported(String packageName, int startId) {
    		super(packageName, startId);
    	}

    	@Override
    	public String getRequestType() {
    		return REQUEST_TYPE_CHECK_BILLING_SUPPORTED;
    	}

    	@Override
    	protected void processOkResponse(Bundle response) {
    		final boolean supported = this.isSuccess();
    		BillingController.onBillingChecked(supported);
    	}
    	
    }
	
	public static class CheckSubscriptionSupported extends BillingRequest {
		
	    public CheckSubscriptionSupported(String packageName, int startId) {
			super(packageName, startId);
		}
	    
	    @Override
	    protected int getAPIVersion() {
	    	return 2;
	    };
	    
    	@Override
    	public String getRequestType() {
    		return REQUEST_TYPE_CHECK_BILLING_SUPPORTED;
    	}

    	@Override
    	protected void processOkResponse(Bundle response) {
    		final boolean supported = this.isSuccess();
    		BillingController.onSubscriptionChecked(supported);
    	}
		
    	@Override
    	protected void addParams(Bundle request) {
    		request.putString(KEY_ITEM_TYPE, ITEM_TYPE_SUBSCRIPTION);
    	}
    	
    }
	
    public static class ConfirmNotifications extends BillingRequest {

    	private String[] notifyIds;
    	
    	private static final String KEY_NOTIFY_IDS = "NOTIFY_IDS";
    	
    	public ConfirmNotifications(String packageName, int startId, String[] notifyIds) {
    		super(packageName, startId);
    		this.notifyIds = notifyIds;
    	}

    	@Override
    	protected void addParams(Bundle request) {
    		request.putStringArray(KEY_NOTIFY_IDS, notifyIds);
    	}

    	@Override
    	public String getRequestType() {
    		return "CONFIRM_NOTIFICATIONS";
    	}
    	
    }
    public static class GetPurchaseInformation extends BillingRequest {

    	private String[] notifyIds;
    	
    	private static final String KEY_NOTIFY_IDS = "NOTIFY_IDS";
    	
    	public GetPurchaseInformation(String packageName, int startId, String[] notifyIds) {
    		super(packageName,startId);
    		this.notifyIds = notifyIds;
    	}
    	
    	@Override
    	protected void addParams(Bundle request) {
    		request.putStringArray(KEY_NOTIFY_IDS, notifyIds);
    	}

    	@Override
    	public String getRequestType() {
    		return "GET_PURCHASE_INFORMATION";
    	}

    	@Override public boolean hasNonce() { return true; }
    	
    }

    public static class RequestPurchase extends BillingRequest {

    	private String itemId;
    	private String developerPayload;
    	
    	private static final String KEY_ITEM_ID = "ITEM_ID";
    	private static final String KEY_DEVELOPER_PAYLOAD = "DEVELOPER_PAYLOAD";
    	private static final String KEY_PURCHASE_INTENT = "PURCHASE_INTENT";
    	
    	public RequestPurchase(String packageName, int startId, String itemId, String developerPayload) {
    		super(packageName, startId);
    		this.itemId = itemId;
    		this.developerPayload = developerPayload;
    	}

    	@Override
    	protected void addParams(Bundle request) {
    		request.putString(KEY_ITEM_ID, itemId);
    		if (developerPayload != null) {
    			request.putString(KEY_DEVELOPER_PAYLOAD, developerPayload);
    		}
    	}

    	@Override
    	public String getRequestType() {
    		return "REQUEST_PURCHASE";
    	}
    	
    	@Override
    	public void onResponseCode(ResponseCode response) {
    		super.onResponseCode(response);
    		BillingController.onRequestPurchaseResponse(itemId, response);
    	}
    	
    	@Override
    	protected void processOkResponse(Bundle response) {
    		final PendingIntent purchaseIntent = response.getParcelable(KEY_PURCHASE_INTENT);
    		BillingController.onPurchaseIntent(itemId, purchaseIntent);
    	}
    	
    }
    
    public static class RequestSubscription extends RequestPurchase {

    	public RequestSubscription(String packageName, int startId, String itemId, String developerPayload) {
			super(packageName, startId, itemId, developerPayload);
		}

		@Override
    	protected void addParams(Bundle request) {
			super.addParams(request);
    		request.putString(KEY_ITEM_TYPE, ITEM_TYPE_SUBSCRIPTION);
    	}
    	
    	@Override
    	protected int getAPIVersion() {
    		return 2;
    	}
    }
    
    public static enum ResponseCode {
    	RESULT_OK, // 0
    	RESULT_USER_CANCELED, // 1 
    	RESULT_SERVICE_UNAVAILABLE, // 2 
    	RESULT_BILLING_UNAVAILABLE, // 3
    	RESULT_ITEM_UNAVAILABLE, // 4
    	RESULT_DEVELOPER_ERROR, // 5
    	RESULT_ERROR; // 6

    	public static boolean isResponseOk(int response) {
    		return ResponseCode.RESULT_OK.ordinal() == response;
    	}

    	// Converts from an ordinal value to the ResponseCode
    	public static ResponseCode valueOf(int index) {
    		ResponseCode[] values = ResponseCode.values();
    		if (index < 0 || index >= values.length) {
    			return RESULT_ERROR;
    		}
    		return values[index];
    	}
    }
	public static class RestoreTransactions extends BillingRequest {
    	
    	public RestoreTransactions(String packageName, int startId) {
    		super(packageName, startId);
    	}
    	
    	@Override
    	public String getRequestType() {
    		return "RESTORE_TRANSACTIONS";
    	}

    	@Override public boolean hasNonce() { return true; }
    	
    	@Override
    	public void onResponseCode(ResponseCode response) {
    		super.onResponseCode(response);
    		if (response == ResponseCode.RESULT_OK) {
    			BillingController.onTransactionsRestored();
    		}
    	}
    	
    }

	public static final String ITEM_TYPE_SUBSCRIPTION = "subs";
	private static final String KEY_API_VERSION = "API_VERSION";	
    private static final String KEY_BILLING_REQUEST = "BILLING_REQUEST";
	private static final String KEY_ITEM_TYPE = "ITEM_TYPE";
    private static final String KEY_NONCE = "NONCE";
	private static final String KEY_PACKAGE_NAME = "PACKAGE_NAME";
    protected static final String KEY_REQUEST_ID = "REQUEST_ID";
	private static final String KEY_RESPONSE_CODE = "RESPONSE_CODE";
	private static final String REQUEST_TYPE_CHECK_BILLING_SUPPORTED = "CHECK_BILLING_SUPPORTED";
    
    public static final long IGNORE_REQUEST_ID = -1;
	private String packageName;	
    
	private int startId;
    private boolean success;
	private long nonce;
	public BillingRequest(String packageName,int startId) {		
    	this.packageName = packageName;
    	this.startId=startId;
    }
    
	protected void addParams(Bundle request) {
    	// Do nothing by default
    }
	
    protected int getAPIVersion() {
    	return 1;
    }

    public long getNonce() {
		return nonce;
	}
	
    public abstract String getRequestType();
    
    public boolean hasNonce() {
    	return false;
    }
    
    public boolean isSuccess() {
    	return success;
    }
    
    protected Bundle makeRequestBundle() {
        final Bundle request = new Bundle();
        request.putString(KEY_BILLING_REQUEST, getRequestType());
        request.putInt(KEY_API_VERSION, getAPIVersion());
        request.putString(KEY_PACKAGE_NAME, packageName);
        if (hasNonce()) {
    		request.putLong(KEY_NONCE, nonce);
        }
        return request;
    }
    
    public void onResponseCode(ResponseCode responde) {
    	// Do nothing by default
	}
    
    protected void processOkResponse(Bundle response) {    	
    	// Do nothing by default
    }
    
    public long run(IMarketBillingService mService) throws RemoteException {
        final Bundle request = makeRequestBundle();
        addParams(request);
        final Bundle response;
        try {
            response = mService.sendBillingRequest(request);        	
        } catch (NullPointerException e) {
    		Log.e(this.getClass().getSimpleName(), "Known IAB bug. See: http://code.google.com/p/marketbilling/issues/detail?id=25", e);
        	return IGNORE_REQUEST_ID;        	
        }

        if (validateResponse(response)) {
        	processOkResponse(response);
        	return response.getLong(KEY_REQUEST_ID, IGNORE_REQUEST_ID);
        } else {
        	return IGNORE_REQUEST_ID;
        }
	}

    public void setNonce(long nonce) {
		this.nonce = nonce;
	}
    
    protected boolean validateResponse(Bundle response) {
    	final int responseCode = response.getInt(KEY_RESPONSE_CODE);
    	success = ResponseCode.isResponseOk(responseCode);
    	if (!success) {
    		Log.w(this.getClass().getSimpleName(), "Error with response code " + ResponseCode.valueOf(responseCode));
    	}
    	return success;
    }
    
    public int getStartId() {
    	return startId;
    }
    
}