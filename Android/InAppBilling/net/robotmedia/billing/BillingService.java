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

import java.util.LinkedList;

import static net.robotmedia.billing.BillingRequest.*;

import net.robotmedia.billing.utils.Compatibility;

import com.android.vending.billing.IMarketBillingService;

import android.app.Service;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;

public class BillingService extends Service implements ServiceConnection {

	private static enum Action {
		CHECK_BILLING_SUPPORTED, CHECK_SUBSCRIPTION_SUPPORTED, CONFIRM_NOTIFICATIONS, GET_PURCHASE_INFORMATION, REQUEST_PURCHASE, REQUEST_SUBSCRIPTION, RESTORE_TRANSACTIONS
	}

	private static final String ACTION_MARKET_BILLING_SERVICE = "com.android.vending.billing.MarketBillingService.BIND";
	private static final String EXTRA_DEVELOPER_PAYLOAD = "DEVELOPER_PAYLOAD";
	private static final String EXTRA_ITEM_ID = "ITEM_ID";
	private static final String EXTRA_NONCE = "EXTRA_NONCE";
	private static final String EXTRA_NOTIFY_IDS = "NOTIFY_IDS";
	private static LinkedList<BillingRequest> mPendingRequests = new LinkedList<BillingRequest>();

	private static IMarketBillingService mService;

	public static void checkBillingSupported(Context context) {
		final Intent intent = createIntent(context, Action.CHECK_BILLING_SUPPORTED);
		context.startService(intent);
	}

	public static void checkSubscriptionSupported(Context context) {
		final Intent intent = createIntent(context, Action.CHECK_SUBSCRIPTION_SUPPORTED);
		context.startService(intent);
	}
	
	public static void confirmNotifications(Context context, String[] notifyIds) {
		final Intent intent = createIntent(context, Action.CONFIRM_NOTIFICATIONS);
		intent.putExtra(EXTRA_NOTIFY_IDS, notifyIds);
		context.startService(intent);
	}

	private static Intent createIntent(Context context, Action action) {
		final String actionString = getActionForIntent(context, action);
		final Intent intent = new Intent(actionString);
		intent.setClass(context, BillingService.class);
		return intent;
	}

	private static final String getActionForIntent(Context context, Action action) {
		return context.getPackageName() + "." + action.toString();
	}

	public static void getPurchaseInformation(Context context, String[] notifyIds, long nonce) {
		final Intent intent = createIntent(context, Action.GET_PURCHASE_INFORMATION);
		intent.putExtra(EXTRA_NOTIFY_IDS, notifyIds);
		intent.putExtra(EXTRA_NONCE, nonce);
		context.startService(intent);
	}

	public static void requestPurchase(Context context, String itemId, String developerPayload) {
		final Intent intent = createIntent(context, Action.REQUEST_PURCHASE);
		intent.putExtra(EXTRA_ITEM_ID, itemId);
		intent.putExtra(EXTRA_DEVELOPER_PAYLOAD, developerPayload);
		context.startService(intent);
	}
	
	public static void requestSubscription(Context context, String itemId, String developerPayload) {
		final Intent intent = createIntent(context, Action.REQUEST_SUBSCRIPTION);
		intent.putExtra(EXTRA_ITEM_ID, itemId);
		intent.putExtra(EXTRA_DEVELOPER_PAYLOAD, developerPayload);
		context.startService(intent);
	}

	public static void restoreTransations(Context context, long nonce) {
		final Intent intent = createIntent(context, Action.RESTORE_TRANSACTIONS);
		intent.setClass(context, BillingService.class);
		intent.putExtra(EXTRA_NONCE, nonce);
		context.startService(intent);
	}

	private void bindMarketBillingService() {
		try {
			final boolean bindResult = bindService(new Intent(ACTION_MARKET_BILLING_SERVICE), this, Context.BIND_AUTO_CREATE);
			if (!bindResult) {
				Log.e(this.getClass().getSimpleName(), "Could not bind to MarketBillingService");
			}
		} catch (SecurityException e) {
			Log.e(this.getClass().getSimpleName(), "Could not bind to MarketBillingService", e);
		}
	}

	private void checkBillingSupported(int startId) {
		final String packageName = getPackageName();
		final CheckBillingSupported request = new CheckBillingSupported(packageName, startId);
		runRequestOrQueue(request);
	}
	
	private void checkSubscriptionSupported(int startId) {
		final String packageName = getPackageName();
		final CheckSubscriptionSupported request = new CheckSubscriptionSupported(packageName, startId);
		runRequestOrQueue(request);
	}

	private void confirmNotifications(Intent intent, int startId) {
		final String packageName = getPackageName();
		final String[] notifyIds = intent.getStringArrayExtra(EXTRA_NOTIFY_IDS);
		final ConfirmNotifications request = new ConfirmNotifications(packageName, startId, notifyIds);
		runRequestOrQueue(request);
	}

	private Action getActionFromIntent(Intent intent) {
		final String actionString = intent.getAction();
		if (actionString == null) {
			return null;
		}
		final String[] split = actionString.split("\\.");
		if (split.length <= 0) {
			return null;
		}
		return Action.valueOf(split[split.length - 1]);
	}

	private void getPurchaseInformation(Intent intent, int startId) {
		final String packageName = getPackageName();
		final long nonce = intent.getLongExtra(EXTRA_NONCE, 0);
		final String[] notifyIds = intent.getStringArrayExtra(EXTRA_NOTIFY_IDS);
		final GetPurchaseInformation request = new GetPurchaseInformation(packageName, startId, notifyIds);
		request.setNonce(nonce);
		runRequestOrQueue(request);
	}

	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}

	public void onServiceConnected(ComponentName name, IBinder service) {
		mService = IMarketBillingService.Stub.asInterface(service);
		runPendingRequests();
	}

	public void onServiceDisconnected(ComponentName name) {
		mService = null;
	}

	// This is the old onStart method that will be called on the pre-2.0
	// platform.  On 2.0 or later we override onStartCommand() so this
	// method will not be called.
	@Override
	public void onStart(Intent intent, int startId) {
	    handleCommand(intent, startId);
	}

	// @Override // Avoid compile errors on pre-2.0
	public int onStartCommand(Intent intent, int flags, int startId) {
	    handleCommand(intent, startId);
	    return Compatibility.START_NOT_STICKY;
	}
	
	private void handleCommand(Intent intent, int startId) {
		final Action action = getActionFromIntent(intent);
		if (action == null) {
			return;
		}
		switch (action) {			
		case CHECK_BILLING_SUPPORTED:
			checkBillingSupported(startId);
			break;
		case CHECK_SUBSCRIPTION_SUPPORTED:
			checkSubscriptionSupported(startId);
			break;
		case REQUEST_PURCHASE:
			requestPurchase(intent, startId);
			break;
		case REQUEST_SUBSCRIPTION:
			requestSubscription(intent, startId);
			break;
		case GET_PURCHASE_INFORMATION:
			getPurchaseInformation(intent, startId);
			break;
		case CONFIRM_NOTIFICATIONS:
			confirmNotifications(intent, startId);
			break;
		case RESTORE_TRANSACTIONS:
			restoreTransactions(intent, startId);
		}
	}

	private void requestPurchase(Intent intent, int startId) {
		final String packageName = getPackageName();
		final String itemId = intent.getStringExtra(EXTRA_ITEM_ID);
		final String developerPayload = intent.getStringExtra(EXTRA_DEVELOPER_PAYLOAD);
		final RequestPurchase request = new RequestPurchase(packageName, startId, itemId, developerPayload);
		runRequestOrQueue(request);
	}
	
	private void requestSubscription(Intent intent, int startId) {
		final String packageName = getPackageName();
		final String itemId = intent.getStringExtra(EXTRA_ITEM_ID);
		final String developerPayload = intent.getStringExtra(EXTRA_DEVELOPER_PAYLOAD);
		final RequestPurchase request = new RequestSubscription(packageName, startId, itemId, developerPayload);
		runRequestOrQueue(request);
	}

	private void restoreTransactions(Intent intent, int startId) {
		final String packageName = getPackageName();
		final long nonce = intent.getLongExtra(EXTRA_NONCE, 0);
		final RestoreTransactions request = new RestoreTransactions(packageName, startId);
		request.setNonce(nonce);
		runRequestOrQueue(request);
	}

	private void runPendingRequests() {
		BillingRequest request;
		int maxStartId = -1;		
		while ((request = mPendingRequests.peek()) != null) {
			if (mService != null) {
				runRequest(request);
				mPendingRequests.remove();
				if (maxStartId < request.getStartId()) {
					maxStartId = request.getStartId();
				}
			} else {
				bindMarketBillingService();
				return;
			}
		}
		if (maxStartId >= 0) {
			stopSelf(maxStartId);
		}
	}

	private void runRequest(BillingRequest request) {
		try {
			final long requestId = request.run(mService);
			BillingController.onRequestSent(requestId, request);
		} catch (RemoteException e) {
			Log.w(this.getClass().getSimpleName(), "Remote billing service crashed");
			// TODO: Retry?
		}
	}

	private void runRequestOrQueue(BillingRequest request) {
		mPendingRequests.add(request);
		if (mService == null) {			
			bindMarketBillingService();		
		} else {
			runPendingRequests();
		}
	}
	
	@Override
	public void onDestroy() {
		super.onDestroy();
		// Ensure we're not leaking Android Market billing service
		if (mService != null) {
			try {
				unbindService(this);
			} catch (IllegalArgumentException e) {
				// This might happen if the service was disconnected
			}
		}
	}

}
