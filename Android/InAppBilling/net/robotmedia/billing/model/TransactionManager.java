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

import java.util.ArrayList;
import java.util.List;

import net.robotmedia.billing.model.Transaction.PurchaseState;
import android.content.Context;
import android.database.Cursor;

public class TransactionManager {
	
	public synchronized static void addTransaction(Context context, Transaction transaction) {
		BillingDB db = new BillingDB(context);
		db.insert(transaction);
		db.close();
	}
	
	public synchronized static boolean isPurchased(Context context, String itemId) {
		return countPurchases(context, itemId) > 0;
	}
	
	public synchronized static int countPurchases(Context context, String itemId) {
		BillingDB db = new BillingDB(context);
		final Cursor c = db.queryTransactions(itemId, PurchaseState.PURCHASED);
		int count = 0;
        if (c != null) {
        	count = c.getCount();
        	c.close();
        }
		db.close();
		return count;
	}
	
	public synchronized static List<Transaction> getTransactions(Context context) {
		BillingDB db = new BillingDB(context);
		final Cursor c = db.queryTransactions();
		final List<Transaction> transactions = cursorToList(c);
		db.close();
		return transactions;
	}

	private static List<Transaction> cursorToList(final Cursor c) {
		final List<Transaction> transactions = new ArrayList<Transaction>();
        if (c != null) {
        	while (c.moveToNext()) {
        		final Transaction purchase = BillingDB.createTransaction(c);
        		transactions.add(purchase);
        	}
        	c.close();
        }
		return transactions;
	}
	
	public synchronized static List<Transaction> getTransactions(Context context, String itemId) {
		BillingDB db = new BillingDB(context);
		final Cursor c = db.queryTransactions(itemId);
		final List<Transaction> transactions = cursorToList(c);
		db.close();
		return transactions;
	}
	
}
