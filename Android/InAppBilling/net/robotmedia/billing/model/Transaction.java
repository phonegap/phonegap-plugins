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

package net.robotmedia.billing.model;

import org.json.JSONException;
import org.json.JSONObject;

public class Transaction {

    public enum PurchaseState {
		// Responses to requestPurchase or restoreTransactions.
		PURCHASED, // 0: User was charged for the order.
		CANCELLED, // 1: The charge failed on the server.
		REFUNDED, // 2: User received a refund for the order.
		EXPIRED; // 3: Sent at the end of a billing cycle to indicate that the
					// subscription expired without renewal because of
					// non-payment or user-cancellation. Your app does not need
					// to grant continued access to the subscription content.

        // Converts from an ordinal value to the PurchaseState
        public static PurchaseState valueOf(int index) {
            PurchaseState[] values = PurchaseState.values();
            if (index < 0 || index >= values.length) {
                return CANCELLED;
            }
            return values[index];
        }
    }
	static final String DEVELOPER_PAYLOAD = "developerPayload";
	static final String NOTIFICATION_ID = "notificationId";
	static final String ORDER_ID = "orderId";
	static final String PACKAGE_NAME = "packageName";
	static final String PRODUCT_ID = "productId";
	static final String PURCHASE_STATE = "purchaseState";

	static final String PURCHASE_TIME = "purchaseTime";
	
    public static Transaction parse(JSONObject json) throws JSONException {
    	final Transaction transaction = new Transaction();
        final int response = json.getInt(PURCHASE_STATE);
        transaction.purchaseState = PurchaseState.valueOf(response);
        transaction.productId = json.getString(PRODUCT_ID);
        transaction.packageName = json.getString(PACKAGE_NAME);
        transaction.purchaseTime = json.getLong(PURCHASE_TIME);
        transaction.orderId = json.optString(ORDER_ID, null);
        transaction.notificationId = json.optString(NOTIFICATION_ID, null);
        transaction.developerPayload = json.optString(DEVELOPER_PAYLOAD, null);
        return transaction;
    }

	public String developerPayload;
    public String notificationId;
    public String orderId;
    public String packageName;
    public String productId;
    public PurchaseState purchaseState;
    public long purchaseTime;
    
    public Transaction() {}
    
    public Transaction(String orderId, String productId, String packageName, PurchaseState purchaseState,
			String notificationId, long purchaseTime, String developerPayload) {
		this.orderId = orderId;
		this.productId = productId;
		this.packageName = packageName;
		this.purchaseState = purchaseState;
		this.notificationId = notificationId;
		this.purchaseTime = purchaseTime;
		this.developerPayload = developerPayload;
	}
    
	public Transaction clone() {
		return new Transaction(orderId, productId, packageName, purchaseState, notificationId, purchaseTime, developerPayload);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Transaction other = (Transaction) obj;
		if (developerPayload == null) {
			if (other.developerPayload != null)
				return false;
		} else if (!developerPayload.equals(other.developerPayload))
			return false;
		if (notificationId == null) {
			if (other.notificationId != null)
				return false;
		} else if (!notificationId.equals(other.notificationId))
			return false;
		if (orderId == null) {
			if (other.orderId != null)
				return false;
		} else if (!orderId.equals(other.orderId))
			return false;
		if (packageName == null) {
			if (other.packageName != null)
				return false;
		} else if (!packageName.equals(other.packageName))
			return false;
		if (productId == null) {
			if (other.productId != null)
				return false;
		} else if (!productId.equals(other.productId))
			return false;
		if (purchaseState != other.purchaseState)
			return false;
		if (purchaseTime != other.purchaseTime)
			return false;
		return true;
	}
	
	@Override
	public String toString() {
		return String.valueOf(orderId);
	}
    
}
