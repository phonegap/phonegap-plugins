//
//  PayPalContext.h
//  PPMEP
//
//  Created by johanna wilson on 12/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayPal.h"

@interface PayPalContext : NSObject {
	@private
	NSString *sessionToken;
	NSString *amount;
	NSString *tax;
	NSString *shipping;
	NSString *currencyCode;
	NSString *itemDesc;
	BOOL shippable;
	NSString *recipientEmail;
	NSString *merchantName;
	BOOL recipientPaysFee;
	BOOL enableDynamicAmountUpdate;
	PAYPAL_ENVIRONMENT environment;
	PayPalPaymentType paymentType;
}

@property (nonatomic, retain) NSString *sessionToken;
@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) NSString *tax;
@property (nonatomic, retain) NSString *shipping;
@property (nonatomic, retain) NSString *currencyCode;
@property (nonatomic, retain) NSString *itemDesc;
@property BOOL shippable;
@property (nonatomic, retain) NSString *recipientEmail;
@property (nonatomic, retain) NSString *merchantName;
@property PAYPAL_ENVIRONMENT environment;
@property PayPalPaymentType paymentType;
@property BOOL recipientPaysFee;
@property BOOL enableDynamicAmountUpdate;

-(NSDictionary*)serialize;
-(BOOL)deserialize:(NSDictionary*)contextData;

@end
