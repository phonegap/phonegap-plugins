//
//  InAppPurchaseManager.m
//  beetight
//
//  Created by Matt Kane on 20/02/2011.
//  Copyright 2011 Matt Kane. All rights reserved.
//

#import "InAppPurchaseManager.h"

// Help create NSNull objects for nil items (since neither NSArray nor NSDictionary can store nil values).
#define NILABLE(obj) ((obj) != nil ? (NSObject *)(obj) : (NSObject *)[NSNull null])

// To avoid compilation warning, declare JSONKit and SBJson's
// category methods without including their header files.
@interface NSArray (StubsForSerializers)
- (NSString *)JSONString;
- (NSString *)JSONRepresentation;
@end

// Helper category method to choose which JSON serializer to use.
@interface NSArray (JSONSerialize)
- (NSString *)JSONSerialize;
@end

@implementation NSArray (JSONSerialize)
- (NSString *)JSONSerialize {
    return [self respondsToSelector:@selector(JSONString)] ? [self JSONString] : [self JSONRepresentation];
}
@end

@implementation InAppPurchaseManager

-(void) setup:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void) requestProductData:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	if([arguments count] < 3) {
		return;
	}
	NSLog(@"Getting product data");
	NSSet *productIdentifiers = [NSSet setWithObject:[arguments objectAtIndex:0]];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];

	ProductsRequestDelegate* delegate = [[[ProductsRequestDelegate alloc] init] retain];
	delegate.command = self;
	delegate.successCallback = [arguments objectAtIndex:1];
	delegate.failCallback = [arguments objectAtIndex:2];

    productsRequest.delegate = delegate;
    [productsRequest start];

}

/**
 * Request product data for the productIds given in the option with
 * key "productIds". See js for further documentation.
 */
- (void) requestProductsData:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	if([arguments count] < 1) {
		return;
	}

	NSSet *productIdentifiers = [NSSet setWithArray:[options objectForKey:@"productIds"]];

	NSLog(@"Getting products data");
	SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];

	BatchProductsRequestDelegate* delegate = [[[BatchProductsRequestDelegate alloc] init] retain];
	delegate.command = self;
	delegate.callback = [arguments objectAtIndex:0];

	productsRequest.delegate = delegate;
	[productsRequest start];
}

- (void) makePurchase:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	NSLog(@"About to do IAP");
	if([arguments count] < 1) {
		return;
	}

    SKMutablePayment *payment = [SKMutablePayment paymentWithProductIdentifier:[arguments objectAtIndex:0]];

	if([arguments count] > 1) {
		id quantity = [arguments objectAtIndex:1];
		if ([quantity respondsToSelector:@selector(integerValue)]) {
			payment.quantity = [quantity integerValue];
		}
	}
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) restoreCompletedTransactions:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

// SKPaymentTransactionObserver methods
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	NSString *state, *error, *transactionIdentifier, *transactionReceipt, *productId;
	NSInteger errorCode;

    for (SKPaymentTransaction *transaction in transactions)
    {
		error = state = transactionIdentifier = transactionReceipt = productId = @"";
		errorCode = 0;

        switch (transaction.transactionState)
        {
			case SKPaymentTransactionStatePurchasing:
				continue;

            case SKPaymentTransactionStatePurchased:
				state = @"PaymentTransactionStatePurchased";
				transactionIdentifier = transaction.transactionIdentifier;
				transactionReceipt = [[transaction transactionReceipt] base64EncodedString];
				productId = transaction.payment.productIdentifier;
                break;

			case SKPaymentTransactionStateFailed:
				state = @"PaymentTransactionStateFailed";
				error = transaction.error.localizedDescription;
				errorCode = transaction.error.code;
				NSLog(@"error %d %@", errorCode, error);

                break;

			case SKPaymentTransactionStateRestored:
				state = @"PaymentTransactionStateRestored";
				transactionIdentifier = transaction.originalTransaction.transactionIdentifier;
				transactionReceipt = [[transaction transactionReceipt] base64EncodedString];
				productId = transaction.originalTransaction.payment.productIdentifier;
                break;

            default:
				NSLog(@"Invalid state");
                continue;
        }
		NSLog(@"state: %@", state);
        NSArray *callbackArgs = [NSArray arrayWithObjects:
                                 NILABLE(state),
                                 [NSNumber numberWithInt:errorCode],
                                 NILABLE(error),
                                 NILABLE(transactionIdentifier),
                                 NILABLE(productId),
                                 NILABLE(transactionReceipt),
                                 nil];
		NSString *js = [NSString stringWithFormat:@"plugins.inAppPurchaseManager.updatedTransactionCallback.apply(plugins.inAppPurchaseManager, %@)", [callbackArgs JSONSerialize]];
		NSLog(@"js: %@", js);
		[self writeJavascript: js];
		[[SKPaymentQueue defaultQueue] finishTransaction:transaction];

    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
	NSString *js = [NSString stringWithFormat:@"plugins.inAppPurchaseManager.onRestoreCompletedTransactionsFailed(%d)", error.code];
	[self writeJavascript: js];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
	NSString *js = @"plugins.inAppPurchaseManager.onRestoreCompletedTransactionsFinished()";
	[self writeJavascript: js];
}

@end

@implementation ProductsRequestDelegate

@synthesize successCallback, failCallback, command;


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSLog(@"got iap product response");
    for (SKProduct *product in response.products) {
		NSLog(@"sending js for %@", product.productIdentifier);
        NSArray *callbackArgs = [NSArray arrayWithObjects:
                                 NILABLE(product.productIdentifier),
                                 NILABLE(product.localizedTitle),
                                 NILABLE(product.localizedDescription),
                                 NILABLE(product.localizedPrice),
                                 nil];
		NSString *js = [NSString stringWithFormat:@"%@.apply(plugins.inAppPurchaseManager, %@)", successCallback, [callbackArgs JSONSerialize]];
		NSLog(@"js: %@", js);
		[command writeJavascript: js];
    }

    for (NSString *invalidProductId in response.invalidProductIdentifiers) {
		NSLog(@"sending fail (%@) js for %@", failCallback, invalidProductId);

		[command writeJavascript: [NSString stringWithFormat:@"%@('%@')", failCallback, invalidProductId]];
    }
	NSLog(@"done iap");

	[command writeJavascript: [NSString stringWithFormat:@"%@('__DONE')", successCallback]];

	[request release];
	[self release];
}

- (void) dealloc
{
    [successCallback release];
    [failCallback release];
	[command release];
    [super dealloc];
}


@end

/**
 * Receives product data for multiple productIds and passes arrays of
 * js objects containing these data to a single callback method.
 */
@implementation BatchProductsRequestDelegate

@synthesize callback, command;

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

    NSMutableArray *validProducts = [NSMutableArray array];
	for (SKProduct *product in response.products) {
        [validProducts addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:
          NILABLE(product.productIdentifier),    @"id",
          NILABLE(product.localizedTitle),       @"title",
          NILABLE(product.localizedDescription), @"description",
          NILABLE(product.localizedPrice),       @"price",
          nil]];
    }

    NSArray *callbackArgs = [NSArray arrayWithObjects:
                             NILABLE(validProducts),
                             NILABLE(response.invalidProductIdentifiers),
                             nil];
	NSString *js = [NSString stringWithFormat:@"%@.apply(plugins.inAppPurchaseManager, %@);", callback, [callbackArgs JSONSerialize]];
	[command writeJavascript: js];

	[request release];
	[self release];
}

- (void) dealloc {
	[callback release];
	[command release];
	[super dealloc];
}

@end
