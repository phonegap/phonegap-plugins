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
@synthesize list;

-(void) setup:(CDVInvokedUrlCommand*)command
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    CDVPluginResult* pluginResult = nil;
    self.list = [[NSMutableDictionary alloc] init];
    
    // If user can make payments, It'll occur success callback
    if ([SKPaymentQueue canMakePayments]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) requestProductData:(CDVInvokedUrlCommand*)command
{
	NSLog(@"[IAP] Getting product data");
	NSSet *productIdentifiers = [NSSet setWithObject:[command.arguments objectAtIndex:0]];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];

	ProductsRequestDelegate* delegate = [[[ProductsRequestDelegate alloc] init] retain];
	delegate.command = command;
    delegate.plugin = self;
    productsRequest.delegate = delegate;
    [productsRequest start];

}

/**
 * Request product data for the productIds given in the option with
 * key "productIds". See js for further documentation.
 */
- (void) requestProductsData:(CDVInvokedUrlCommand*)command
{
	if([command.arguments count] < 1) {
		return;
	}

	NSSet *productIdentifiers = [NSSet setWithArray:[command.arguments objectAtIndex:0]];

	NSLog(@"[IAP] Getting products data");
	SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];

	BatchProductsRequestDelegate* delegate = [[[BatchProductsRequestDelegate alloc] init] retain];
	delegate.command = command;
    delegate.plugin = self;
	productsRequest.delegate = delegate;
	[productsRequest start];
}

- (void) makePurchase:(CDVInvokedUrlCommand*)command
{
	NSLog(@"[IAP] About to do IAP");
    
	if([command.arguments count] < 1) {
		return;
	}

    // paymentWithProductIndentifier was deprecated in iOS 5.0
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:[self.list objectForKey:[command.arguments objectAtIndex:0]]];

	if([command.arguments count] > 1) {
		id quantity = [command.arguments objectAtIndex:1];
		if ([quantity respondsToSelector:@selector(integerValue)]) {
			payment.quantity = [quantity integerValue];
		}
	}
    
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) restoreCompletedTransactions:(CDVInvokedUrlCommand*)command
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
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
				NSLog(@"[IAP] error %d %@", errorCode, error);

                break;

			case SKPaymentTransactionStateRestored:
				state = @"PaymentTransactionStateRestored";
				transactionIdentifier = transaction.originalTransaction.transactionIdentifier;
				transactionReceipt = [[transaction transactionReceipt] base64EncodedString];
				productId = transaction.originalTransaction.payment.productIdentifier;
                break;

            default:
				NSLog(@"[IAP] Invalid state");
                continue;
        }
		NSLog(@"[IAP] state: %@", state);
        NSArray *callbackArgs = [NSArray arrayWithObjects:
                                 NILABLE(state),
                                 [NSNumber numberWithInt:errorCode],
                                 NILABLE(error),
                                 NILABLE(transactionIdentifier),
                                 NILABLE(productId),
                                 NILABLE(transactionReceipt),
                                 nil];
		NSString *js = [NSString stringWithFormat:@"plugins.inAppPurchaseManager.updatedTransactionCallback.apply(plugins.inAppPurchaseManager, %@)", [callbackArgs JSONSerialize]];
		NSLog(@"[IAP] js: %@", js);
        
        [self.webView stringByEvaluatingJavaScriptFromString:js];
		[[SKPaymentQueue defaultQueue] finishTransaction:transaction];

    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
	NSString *js = [NSString stringWithFormat:@"plugins.inAppPurchaseManager.onRestoreCompletedTransactionsFailed(%d)", error.code];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
	NSString *js = @"plugins.inAppPurchaseManager.onRestoreCompletedTransactionsFinished()";
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

@end


@implementation ProductsRequestDelegate

@synthesize command, plugin;

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSLog(@"[IAP] got iap product response");
    for (SKProduct *product in response.products) {
		NSLog(@"[IAP] sending for %@", product.productIdentifier);
        NSDictionary *callbackArgs = [NSDictionary dictionaryWithObjectsAndKeys:
                                NILABLE(product.productIdentifier),    @"id",
                                NILABLE(product.localizedTitle),       @"title",
                                NILABLE(product.localizedDescription), @"description",
                                NILABLE(product.localizedPrice),       @"price",
                                nil];
        
        [self.plugin.list setObject:product forKey:[NSString stringWithFormat:@"%@", product.productIdentifier]];
        CDVPluginResult* pluginResult = nil;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:callbackArgs];
        [self.plugin.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
    }

    for (NSString *invalidProductId in response.invalidProductIdentifiers) {
		NSLog(@"[IAP] sending fail for %@", invalidProductId);

        CDVPluginResult* pluginResult = nil;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:invalidProductId];
        [self.plugin.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
    }
    
	NSLog(@"[IAP] done iap");
	[request release];
	[self release];
}

- (void) dealloc
{
    [plugin release];
	[command release];
    [super dealloc];
}


@end

/**
 * Receives product data for multiple productIds and passes arrays of
 * js objects containing these data to a single callback method.
 */
@implementation BatchProductsRequestDelegate

@synthesize plugin, command;

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
        
        [self.plugin.list setObject:product forKey:[NSString stringWithFormat:@"%@", product.productIdentifier]];
    }

    NSArray *callbackArgs = [NSArray arrayWithObjects:
                             NILABLE(validProducts),
                             NILABLE(response.invalidProductIdentifiers),
                             nil];
    
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:callbackArgs];
    [self.plugin.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
    
	[request release];
	[self release];
}

- (void) dealloc {
	[plugin release];
	[command release];
	[super dealloc];
}

@end
