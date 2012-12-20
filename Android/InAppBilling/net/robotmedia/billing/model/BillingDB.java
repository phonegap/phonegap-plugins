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

import net.robotmedia.billing.model.Transaction.PurchaseState;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class BillingDB {
    static final String DATABASE_NAME = "billing.db";
    static final int DATABASE_VERSION = 1;
    static final String TABLE_TRANSACTIONS = "purchases";

    public static final String COLUMN__ID = "_id";
    public static final String COLUMN_STATE = "state";
    public static final String COLUMN_PRODUCT_ID = "productId";
    public static final String COLUMN_PURCHASE_TIME = "purchaseTime";
    public static final String COLUMN_DEVELOPER_PAYLOAD = "developerPayload";

    private static final String[] TABLE_TRANSACTIONS_COLUMNS = {
    	COLUMN__ID, COLUMN_PRODUCT_ID, COLUMN_STATE,
    	COLUMN_PURCHASE_TIME, COLUMN_DEVELOPER_PAYLOAD
    };

    SQLiteDatabase mDb;
    private DatabaseHelper mDatabaseHelper;

    public BillingDB(Context context) {
        mDatabaseHelper = new DatabaseHelper(context);
        mDb = mDatabaseHelper.getWritableDatabase();
    }

    public void close() {
        mDatabaseHelper.close();
    }

    public void insert(Transaction transaction) {
        ContentValues values = new ContentValues();
        values.put(COLUMN__ID, transaction.orderId);
        values.put(COLUMN_PRODUCT_ID, transaction.productId);
        values.put(COLUMN_STATE, transaction.purchaseState.ordinal());
        values.put(COLUMN_PURCHASE_TIME, transaction.purchaseTime);
        values.put(COLUMN_DEVELOPER_PAYLOAD, transaction.developerPayload);
        mDb.replace(TABLE_TRANSACTIONS, null /* nullColumnHack */, values);
    }
    
    public Cursor queryTransactions() {
        return mDb.query(TABLE_TRANSACTIONS, TABLE_TRANSACTIONS_COLUMNS, null,
                null, null, null, null);
    }
    
    public Cursor queryTransactions(String productId) {
        return mDb.query(TABLE_TRANSACTIONS, TABLE_TRANSACTIONS_COLUMNS, COLUMN_PRODUCT_ID + " = ?", 
                new String[] {productId}, null, null, null);
    }
    
    public Cursor queryTransactions(String productId, PurchaseState state) {
        return mDb.query(TABLE_TRANSACTIONS, TABLE_TRANSACTIONS_COLUMNS, COLUMN_PRODUCT_ID + " = ? AND " + COLUMN_STATE + " = ?", 
                new String[] {productId, String.valueOf(state.ordinal())}, null, null, null);
    }
    
    protected static final Transaction createTransaction(Cursor cursor) {
    	final Transaction purchase = new Transaction();
    	purchase.orderId = cursor.getString(0);
    	purchase.productId = cursor.getString(1);
    	purchase.purchaseState = PurchaseState.valueOf(cursor.getInt(2));
    	purchase.purchaseTime = cursor.getLong(3);
    	purchase.developerPayload = cursor.getString(4);
    	return purchase;
    }

    private class DatabaseHelper extends SQLiteOpenHelper {
        public DatabaseHelper(Context context) {
            super(context, DATABASE_NAME, null, DATABASE_VERSION);
        }

        @Override
        public void onCreate(SQLiteDatabase db) {
            createTransactionsTable(db);
        }

        private void createTransactionsTable(SQLiteDatabase db) {
            db.execSQL("CREATE TABLE " + TABLE_TRANSACTIONS + "(" +
            		COLUMN__ID + " TEXT PRIMARY KEY, " +
            		COLUMN_PRODUCT_ID + " INTEGER, " +
            		COLUMN_STATE + " TEXT, " +
            		COLUMN_PURCHASE_TIME + " TEXT, " +
            		COLUMN_DEVELOPER_PAYLOAD + " INTEGER)");
        }

		@Override
		public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {}
    }
}
