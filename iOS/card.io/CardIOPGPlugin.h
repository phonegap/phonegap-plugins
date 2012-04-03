//
//  CardIOPGPlugin.h
//
//  Copyright 2012 Lumber Labs (card.io)
//  MIT licensed
//

#import <Foundation/Foundation.h>
#import "CardIO.h"

#ifdef CORDOVA_FRAMEWORK
  #import <Cordova/CDVPlugin.h>
#else
  #import "CDVPlugin.h"
#endif

@interface CardIOPGPlugin : CDVPlugin<CardIOPaymentViewControllerDelegate> {
  CardIOPaymentViewController *paymentViewController;
  NSString *scanCallbackId;
}

- (void)scan:(NSMutableArray *)args withDict:(NSMutableDictionary *)options;
- (void)canScan:(NSMutableArray *)args withDict:(NSMutableDictionary *)options;
- (void)version:(NSMutableArray *)args withDict:(NSMutableDictionary *)options;

@end
