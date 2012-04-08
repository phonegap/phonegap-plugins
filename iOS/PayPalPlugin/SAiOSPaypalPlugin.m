//
//  SAiOSPaypalPlugin.m
//  Paypal Plugin for PhoneGap
//
//  Created by shazron on 10-10-08.
//  Copyright 2010 Shazron Abdullah. All rights reserved.

#import "SAiOSPaypalPlugin.h"
#import "PayPal.h"
#import "PayPalMEPPayment.h"
#import "MEPAddress.h" // use for dynamic amount calculation
#import "MEPAmounts.h" // use for dynamic amount calculation

@implementation PaypalPaymentInfo

@synthesize paymentCurrency, paymentAmount, itemDesc, recipient, merchantName;

- (void) dealloc
{
	self.paymentCurrency = nil;
	self.paymentAmount = nil;
	self.itemDesc = nil;
	self.recipient = nil;
	self.merchantName = nil;
	
	[super dealloc];
}

@end

@implementation SAiOSPaypalPlugin

@synthesize paypalButton, paymentInfo;

#define NO_APP_ID	@"dummy"

/* Get one from Paypal at developer.paypal.com */
#define PAYPAL_APP_ID	NO_APP_ID

/* valid values are ENV_SANDBOX, ENV_NONE (offline) and ENV_LIVE */
#define PAYPAL_APP_ENV	ENV_NONE


-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (SAiOSPaypalPlugin*)[super initWithWebView:(UIWebView*)theWebView];
    if (self) {
		if ([PAYPAL_APP_ID isEqualToString:NO_APP_ID]) {
			NSLog(@"WARNING: You are using a dummy PayPal App ID.");
		}
		if (PAYPAL_APP_ENV == ENV_NONE) {
			NSLog(@"WARNING: You are using the offline PayPal ENV_NONE environment.");
		}
		
		[PayPal initializeWithAppID:PAYPAL_APP_ID forEnvironment:PAYPAL_APP_ENV];
    }
    return self;
}

- (void) prepare:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	if (self.paypalButton != nil) {
		[self.paypalButton removeFromSuperview];
		self.paypalButton = nil;
	}
	
	int argc = [arguments count];
	if (argc < 1) {
		NSLog(@"SAiOSPaypalPlugin.prepare - missing first argument for paymentType (integer).");
		return;
	}
	
	NSString* strValue = [arguments objectAtIndex:0];
	NSInteger paymentType = [strValue intValue];

	self.paypalButton = [[PayPal getInstance] getPayButton:(UIViewController*)self /* requiring it to be a UIViewController is dumb paypal, it should be 'id' - especially since it's just for delegate callbacks */ 
												buttonType:0
											 startCheckOut:@selector(payWithPaypal) 
											   PaymentType:paymentType
												  withLeft:0 
												   withTop:0];
	
	[super.webView addSubview:self.paypalButton];
	self.paypalButton.hidden = YES;

	NSLog(@"SAiOSPaypalPlugin.prepare - set paymentType: %d", paymentType);
}


- (void) pay:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	if (self.paypalButton != nil) {
		[self.paypalButton sendActionsForControlEvents:UIControlEventTouchUpInside];
	} else {
		NSLog(@"SAiOSPaypalPlugin.pay - payment not initialized. Call SAiOSPaypalPlugin.prepare(paymentType)");
	}
}

- (void) setPaymentInfo:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	self.paymentInfo = nil;
	self.paymentInfo = [[PaypalPaymentInfo alloc] init];
	
	[self.paymentInfo setValuesForKeysWithDictionary:options];
}

- (void) payWithPaypal
{
	if (self.paymentInfo)
	{
		PayPal *pp = [PayPal getInstance];
		PayPalMEPPayment *payment =[[PayPalMEPPayment alloc] init];

		payment.paymentCurrency = self.paymentInfo.paymentCurrency;
		payment.paymentAmount	= self.paymentInfo.paymentAmount;
		payment.itemDesc		= self.paymentInfo.itemDesc;
		payment.recipient		= self.paymentInfo.recipient;
		payment.merchantName	= self.paymentInfo.merchantName;

		[pp Checkout:payment];
		[payment release];

		NSLog(@"SAiOSPaypalPlugin.payWithPaypal - payment sent. currency:%@ amount:%@ desc:%@ recipient:%@ merchantName:%@",
			  self.paymentInfo.paymentCurrency, self.paymentInfo.paymentAmount, self.paymentInfo.itemDesc,
			  self.paymentInfo.recipient, self.paymentInfo.merchantName);
	}
	else
	{
		NSLog(@"SAiOSPaypalPlugin.payWithPaypal - no payment info. Set it using SAiOSPaypalPlugin.setPaymentInfo");
	}
}

#pragma mark -
#pragma mark Paypal delegates

- (void) paymentSuccess:(NSString*)transactionID 
{
	NSString* jsString = 
	@"(function() {"
	"var e = document.createEvent('Events');"
	"e.initEvent('PaypalPaymentEvent.Success');"
	"e.transactionID = '%@';"
	"document.dispatchEvent(e);"
	"})();";
	
	[super writeJavascript:[NSString stringWithFormat:jsString, transactionID]];
	
	NSLog(@"SAiOSPaypalPlugin.paymentSuccess - transactionId:%@", transactionID);
}

- (void) paymentCanceled 
{
	NSString* jsString = 
	@"(function() {"
	"var e = document.createEvent('Events');"
	"e.initEvent('PaypalPaymentEvent.Canceled');"
	"document.dispatchEvent(e);"
	"})();";
	
	[super writeJavascript:jsString];	
}

- (void) paymentFailed:(PAYPAL_FAILURE)errorType
{
	NSString* jsString = 
	@"(function() {"
	"var e = document.createEvent('Events');"
	"e.initEvent('PaypalPaymentEvent.Failed');"
	"e.errorType = %d;"
	"document.dispatchEvent(e);"
	"})();";
	
	[super writeJavascript:[NSString stringWithFormat:jsString, errorType]];	

	NSLog(@"SAiOSPaypalPlugin.paymentFailed - errorType:%d", errorType);
}

@end
