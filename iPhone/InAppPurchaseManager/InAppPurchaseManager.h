//
//  InAppPurchaseManager.h
//  beetight
//
//  Created by Matt Kane on 20/02/2011.
//  Copyright 2011 Matt Kane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import <Cordova/CDVPlugin.h>
#import <Cordova/NSData+Base64.h>

#import "SKProduct+LocalizedPrice.h"

@interface InAppPurchaseManager : CDVPlugin <SKPaymentTransactionObserver> {
    NSMutableDictionary* list;
}
@property (nonatomic, retain) NSMutableDictionary* list;
- (void) setup:(CDVInvokedUrlCommand*)command;
- (void) makePurchase:(CDVInvokedUrlCommand*)command;
- (void) requestProductData:(CDVInvokedUrlCommand*)command;
- (void) requestProductsData:(CDVInvokedUrlCommand*)command;
- (void) restoreCompletedTransactions:(CDVInvokedUrlCommand*)command;
//- (void) setup:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
//- (void) makePurchase:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
//- (void) requestProductData:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
//- (void) requestProductsData:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error;
- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue;
@end

@interface ProductsRequestDelegate : NSObject <SKProductsRequestDelegate>
{
    InAppPurchaseManager* plugin;
	CDVInvokedUrlCommand* command;
}
@property (nonatomic, retain) InAppPurchaseManager* plugin;
@property (nonatomic, retain) CDVInvokedUrlCommand* command;
@end;

@interface BatchProductsRequestDelegate : NSObject <SKProductsRequestDelegate> {
	InAppPurchaseManager* plugin;
	CDVInvokedUrlCommand* command;
}
@property (nonatomic, retain) InAppPurchaseManager* plugin;
@property (nonatomic, retain) CDVInvokedUrlCommand* command;
@end;
