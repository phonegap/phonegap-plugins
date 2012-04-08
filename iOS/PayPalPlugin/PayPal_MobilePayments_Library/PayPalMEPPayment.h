//
//  PayPalMEPPayment.h
//  PPMEP
//
//  Created by richard smith on 4/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayPalMEPPayment : NSObject {
	NSString *paymentCurrency;
	NSString *paymentAmount;
	NSString *itemDesc;
	NSString *recipient;
	NSString *taxAmount;
	NSString *shippingAmount;
	NSString *merchantName;
}
@property (nonatomic, retain) NSString *paymentCurrency;
@property (nonatomic, retain) NSString *paymentAmount;
@property (nonatomic, retain) NSString *itemDesc;
@property (nonatomic, retain) NSString *recipient;
@property (nonatomic, retain) NSString *taxAmount;
@property (nonatomic, retain) NSString *shippingAmount;
@property (nonatomic, retain) NSString *merchantName;

@end
