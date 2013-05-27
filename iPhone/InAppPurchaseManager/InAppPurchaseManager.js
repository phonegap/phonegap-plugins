/** 
 * A plugin to enable iOS In-App Purchases.
 *
 * Copyright (c) Matt Kane 2011
 * Copyright (c) Guillaume Charhon 2012
 */

var InAppPurchaseManager = function() { 
	cordova.exec(null, function () {
		// It occurs when user can't purchase anything
	}, "InAppPurchaseManager", "setup", []);
}

/**
 * Makes an in-app purchase. 
 * 
 * @param {String} productId The product identifier. e.g. "com.example.MyApp.myproduct"
 * @param {int} quantity 
 */

InAppPurchaseManager.prototype.makePurchase = function(productId, quantity) {
	var q = parseInt(quantity);
	if(!q) {
		q = 1;
	}
    
    // return
    cordova.exec(null, null, "InAppPurchaseManager", "makePurchase", [productId, q]);
}

/**
 * Asks the payment queue to restore previously completed purchases.
 * The restored transactions are passed to the onRestored callback, so make sure you define a handler for that first.
 * 
 */

InAppPurchaseManager.prototype.restoreCompletedTransactions = function() {
	// return
    cordova.exec(null, null, "InAppPurchaseManager", "restoreCompletedTransactions", []);
}


/**
 * Retrieves the localised product data, including price (as a localised string), name, description.
 * You must call this before attempting to make a purchase.
 *
 * @param {String} productId The product identifier. e.g. "com.example.MyApp.myproduct"
 * @param {Function} successCallback Called once for each returned product id. Signature is function(productId, title, description, price)
 * @param {Function} failCallback Called once for each invalid product id. Signature is function(productId)
 */

InAppPurchaseManager.prototype.requestProductData = function(productId, successCallback, failCallback) {
    cordova.exec(successCallback, failCallback, "InAppPurchaseManager", "requestProductData", [productId]);	
}

/**
 * Retrieves localised product data, including price (as localised
 * string), name, description of multiple products.
 *
 * @param {Array} productIds
 *   An array of product identifier strings.
 *
 * @param {Function} callback
 *   Called once with the result of the products request. Signature:
 *
 *     function(validProducts, invalidProductIds)
 *
 *   where validProducts receives an array of objects of the form
 *
 *     {
 *      id: "<productId>",
 *      title: "<localised title>",
 *      description: "<localised escription>",
 *      price: "<localised price>"
 *     }
 *
 *  and invalidProductIds receives an array of product identifier
 *  strings which were rejected by the app store.
 */
InAppPurchaseManager.prototype.requestProductsData = function(productIds, callback) {
	cordova.exec(callback, null, "InAppPurchaseManager", "requestProductsData", [productIds]);
};

/* function(transactionIdentifier, productId, transactionReceipt) */
InAppPurchaseManager.prototype.onPurchased = null;

/* function(originalTransactionIdentifier, productId, originalTransactionReceipt) */
InAppPurchaseManager.prototype.onRestored = null;

/* function(errorCode, errorText) */
InAppPurchaseManager.prototype.onFailed = null;

/* function() */
InAppPurchaseManager.prototype.onRestoreCompletedTransactionsFinished = function () {
	console.log("restored transaction");
};

/* function(errorCode) */
InAppPurchaseManager.prototype.onRestoreCompletedTransactionsFailed = null;

/* This is called from native.*/

InAppPurchaseManager.prototype.updatedTransactionCallback = function(state, errorCode, errorText, transactionIdentifier, productId, transactionReceipt) {
	switch(state) {
		case "PaymentTransactionStatePurchased":
			if(window.plugins.inAppPurchaseManager.onPurchased)
                window.plugins.inAppPurchaseManager.onPurchased(transactionIdentifier, productId, transactionReceipt);
			
			return; 
			
		case "PaymentTransactionStateFailed":
			if(window.plugins.inAppPurchaseManager.onFailed)
				window.plugins.inAppPurchaseManager.onFailed(errorCode, errorText);
			
			return;
            
		case "PaymentTransactionStateRestored":
            if(window.plugins.inAppPurchaseManager.onRestored)
                window.plugins.inAppPurchaseManager.onRestored(transactionIdentifier, productId, transactionReceipt);
			return;
	}
};

InAppPurchaseManager.prototype.restoreCompletedTransactionsFinished = function() {
    if (this.onRestoreCompletedTransactionsFinished) {
        this.onRestoreCompletedTransactionsFinished();
    }
};

InAppPurchaseManager.prototype.restoreCompletedTransactionsFailed = function(errorCode) {
    if (this.onRestoreCompletedTransactionsFailed) {
        this.onRestoreCompletedTransactionsFailed(errorCode);
    }
};

/*
 * This queue stuff is here because we may be sent events before listeners have been registered. This is because if we have 
 * incomplete transactions when we quit, the app will try to run these when we resume. If we don't register to receive these
 * right away then they may be missed. As soon as a callback has been registered then it will be sent any events waiting
 * in the queue.
 */

InAppPurchaseManager.prototype.runQueue = function() {
	if(!this.eventQueue.length || (!this.onPurchased && !this.onFailed && !this.onRestored)) {
		return;
	}

	var args;
	/* We can't work directly on the queue, because we're pushing new elements onto it */
	var queue = this.eventQueue.slice();
	this.eventQueue = [];
	while(args = queue.shift()) {
		this.updatedTransactionCallback.apply(this, args);
	}
	if(!this.eventQueue.length) {	
		this.unWatchQueue();
	}
}

InAppPurchaseManager.prototype.watchQueue = function() {
	if(this.timer) {
		return;
	}
	this.timer = setInterval("window.plugins.inAppPurchaseManager.runQueue()", 10000);
}

InAppPurchaseManager.prototype.unWatchQueue = function() {
	if(this.timer) {
		clearInterval(this.timer);
		this.timer = null;
	}
}

InAppPurchaseManager.prototype.callbackMap = {};
InAppPurchaseManager.prototype.callbackIdx = 0;
InAppPurchaseManager.prototype.eventQueue = [];
InAppPurchaseManager.prototype.timer = null;

document.addEventListener("deviceready", function()  {
	window.plugins = window.plugins || {};
	window.plugins.inAppPurchaseManager = InAppPurchaseManager.manager = new InAppPurchaseManager();

	window.plugins.inAppPurchaseManager.onPurchased = function(transactionIdentifier, productId, transactionReceipt) {
        console.log('purchased: ' + productId);

        // If failed a receipt validation on server, you can restore transaction this payment.
        // window.plugins.inAppPurchaseManager.restoreCompletedTransactions();
    }

    // Perhaps It did rollback a transaction
    window.plugins.inAppPurchaseManager.onRestored = function(transactionIdentifier, productId, transactionReceipt) {
        console.log('restored: ' + productId);
        /* See the developer guide for details of what to do with this */
    }

    // Failed to purchase an item
    window.plugins.inAppPurchaseManager.onFailed = function(errno, errtext) {
    	alert(errtext);
    }

    // requestProductData -> { id, title, description, price }
    // requestProductsData -> [[{ id, title, description, price }, ... ], [invaildID]]
    // plugins.inAppPurchaseManager.requestProductData("1", function(result) {
    //         window.plugins.inAppPurchaseManager.makePurchase(result.id, 1 /* quantity */);
    //     }, function(id) {
    //         console.log("[In JS] Invalid product id: " + id);
    //     }
    // );
});