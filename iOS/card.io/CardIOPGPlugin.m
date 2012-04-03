//
//  CardIOPGPlugin.m
//
//  Copyright 2012 Lumber Labs (card.io)
//  MIT licensed
//

#import "CardIOPGPlugin.h"

#pragma mark -

@interface CardIOPGPlugin ()

- (void)sendSuccessTo:(NSString *)callbackId withObject:(id)objwithObject;
- (void)sendFailureTo:(NSString *)callbackId;

@property(nonatomic, retain, readwrite) CardIOPaymentViewController *paymentViewController;
@property(nonatomic, copy, readwrite) NSString *scanCallbackId;

@end

#pragma mark -

@implementation CardIOPGPlugin

@synthesize paymentViewController;
@synthesize scanCallbackId;

- (void)scan:(NSMutableArray *)args withDict:(NSMutableDictionary *)options {
  self.scanCallbackId = [args objectAtIndex:0];
  NSString *appToken = [args objectAtIndex:1];
  
  self.paymentViewController = [[[CardIOPaymentViewController alloc] initWithPaymentDelegate:self] autorelease];
  self.paymentViewController.appToken = appToken;

  NSNumber *collectCVV = [options objectForKey:@"collect_cvv"];
  if(collectCVV) {
    self.paymentViewController.collectCVV = [collectCVV boolValue];
  }

  NSNumber *collectZip = [options objectForKey:@"collect_zip"];
  if(collectZip) {
    self.paymentViewController.collectZip = [collectZip boolValue];
  }

  NSNumber *collectExpiry = [options objectForKey:@"collect_expiry"];
  if(collectExpiry) {
    self.paymentViewController.collectExpiry = [collectExpiry boolValue];
  }

  NSNumber *disableManualEntryButtons = [options objectForKey:@"disable_manual_entry_buttons"];
  if(disableManualEntryButtons) {
    self.paymentViewController.disableManualEntryButtons = [disableManualEntryButtons boolValue];
  }

  NSNumber *showsFirstUseAlert = [options objectForKey:@"shows_first_use_alert"];
  if(showsFirstUseAlert) {
    self.paymentViewController.showsFirstUseAlert = [showsFirstUseAlert boolValue];
  }

  [self.viewController presentModalViewController:self.paymentViewController animated:YES];
}

- (void)canScan:(NSMutableArray *)args withDict:(NSMutableDictionary *)options {
  NSString *callbackId = [args objectAtIndex:0];
  BOOL canScan = [CardIOPaymentViewController canReadCardWithCamera];
  [self sendSuccessTo:callbackId withObject:[NSNumber numberWithBool:canScan]];
}

- (void)version:(NSMutableArray *)args withDict:(NSMutableDictionary *)options {
  NSString *callbackId = [args objectAtIndex:0];
  NSString *version = [CardIOPaymentViewController libraryVersion];

  if(version) {
    [self sendSuccessTo:callbackId withObject:version];
  } else {
    [self sendFailureTo:callbackId];
  }
}

- (void)dealloc {
  paymentViewController.delegate = nil, [paymentViewController release], paymentViewController = nil;
  [scanCallbackId release], scanCallbackId = nil;
  [super dealloc];
}

#pragma mark - CardIOPaymentViewControllerDelegate methods

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)pvc {
  if(![pvc isEqual:self.paymentViewController]) {
    NSLog(@"card.io received unexpected callback (expected from %@, received from %@", self.paymentViewController, pvc);
    return;
  }

  [self.paymentViewController dismissModalViewControllerAnimated:YES];

  // Convert CardIOCreditCardInfo into dictionary for passing back to javascript
  NSMutableDictionary *response = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   info.cardNumber, @"card_number",
                                   info.redactedCardNumber, @"redacted_card_number",
                                   [CardIOCreditCardInfo displayStringForCardType:info.cardType], @"card_type",
                                   nil];
  if(info.expiryMonth > 0 && info.expiryYear > 0) {
    [response setObject:[NSNumber numberWithUnsignedInteger:info.expiryMonth] forKey:@"expiry_month"];
    [response setObject:[NSNumber numberWithUnsignedInteger:info.expiryYear] forKey:@"expiry_year"];
  }
  if(info.cvv.length > 0) {
    [response setObject:info.cvv forKey:@"cvv"];
  }
  if(info.zip.length > 0) {
    [response setObject:info.zip forKey:@"zip"];
  }

  [self sendSuccessTo:self.scanCallbackId withObject:response];
  
  self.paymentViewController.delegate = nil;
  self.paymentViewController = nil;
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)pvc {
  if(![pvc isEqual:self.paymentViewController]) {
    NSLog(@"card.io received unexpected callback (expected from %@, received from %@", self.paymentViewController, pvc);
    return;
  }

  [self.paymentViewController dismissModalViewControllerAnimated:YES];

  [self sendFailureTo:self.scanCallbackId];

  self.paymentViewController.delegate = nil;
  self.paymentViewController = nil;
}

#pragma mark - Cordova callback helpers

- (void)sendSuccessTo:(NSString *)callbackId withObject:(id)obj {
  CDVPluginResult *result = nil;
  
  if([obj isKindOfClass:[NSString class]]) {
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:obj];
  } else if([obj isKindOfClass:[NSDictionary class]]) {
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:obj];
  } else if ([obj isKindOfClass:[NSNumber class]]) {
    // all the numbers we return are bools
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[obj intValue]];
  } else if(!obj) {
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else {
    NSLog(@"Success callback wrapper not yet implemented for class %@", [obj class]);
  }
  
  NSString *responseJavascript = [result toSuccessCallbackString:callbackId];
  if(responseJavascript) {
    [self writeJavascript:responseJavascript];
  }
}

- (void)sendFailureTo:(NSString *)callbackId {
  CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  NSString *responseJavascript = [result toErrorCallbackString:callbackId];
  if(responseJavascript) {
    [self writeJavascript:responseJavascript];
  }
}

@end
