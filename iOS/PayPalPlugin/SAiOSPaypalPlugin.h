//
//  SAiOSPaypalPlugin.h
//  Paypal Plugin for PhoneGap
//
//  Created by shazron on 10-10-08.
//  Copyright 2010 Shazron Abdullah. All rights reserved.

#import <Foundation/Foundation.h>
#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif
#import "PayPal.h"

@interface PaypalPaymentInfo : NSObject
{
	NSString* paymentCurrency;
	NSString* paymentAmount;
	NSString* itemDesc;
	NSString* recipient;
	NSString* merchantName;
}

@property (nonatomic, copy) NSString* paymentCurrency;
@property (nonatomic, copy) NSString* paymentAmount;
@property (nonatomic, copy) NSString* itemDesc;
@property (nonatomic, copy) NSString* recipient;
@property (nonatomic, copy) NSString* merchantName;

@end


@interface SAiOSPaypalPlugin : CDVPlugin<PayPalMEPDelegate> {
	UIButton* paypalButton;
	PaypalPaymentInfo* paymentInfo;
}

@property (nonatomic, retain) UIButton* paypalButton;
@property (nonatomic, retain) PaypalPaymentInfo* paymentInfo;

- (void) prepare:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) pay:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) setPaymentInfo:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void) payWithPaypal;
@end
