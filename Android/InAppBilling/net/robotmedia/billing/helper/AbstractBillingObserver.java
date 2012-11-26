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

package net.robotmedia.billing.helper;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.PreferenceManager;
import net.robotmedia.billing.BillingController;
import net.robotmedia.billing.IBillingObserver;

/**
 * Abstract subclass of IBillingObserver that provides default implementations
 * for {@link IBillingObserver#onPurchaseIntent(String, PendingIntent)} and
 * {@link IBillingObserver#onTransactionsRestored()}.
 * 
 */
public abstract class AbstractBillingObserver implements IBillingObserver {

	protected static final String KEY_TRANSACTIONS_RESTORED = "net.robotmedia.billing.transactionsRestored";

	protected Activity activity;

	public AbstractBillingObserver(Activity activity) {
		this.activity = activity;
	}

	public boolean isTransactionsRestored() {
		final SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(activity);
		return preferences.getBoolean(KEY_TRANSACTIONS_RESTORED, false);
	}

	/**
	 * Called after requesting the purchase of the specified item. The default
	 * implementation simply starts the pending intent.
	 * 
	 * @param itemId
	 *            id of the item whose purchase was requested.
	 * @param purchaseIntent
	 *            a purchase pending intent for the specified item.
	 */
	public void onPurchaseIntent(String itemId, PendingIntent purchaseIntent) {
		BillingController.startPurchaseIntent(activity, purchaseIntent, null);
	}

	public void onTransactionsRestored() {
		final SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(activity);
		final Editor editor = preferences.edit();
		editor.putBoolean(KEY_TRANSACTIONS_RESTORED, true);
		editor.commit();
	}

}
