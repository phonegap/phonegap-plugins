//
//  PayPalMEP.h
//  PPMEP
//
//  Created by johanna wilson on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPMEPRootViewController;
@class PayPalContext;
@class MEPAmounts;
@class MEPAddress;
@class PayPalMEPPayment;
@class PayPalMEPButton;

typedef enum PayPalResponse{
	PAYMENT_SUCCESS = 0,
	PAYMENT_FAILED = 1,
	PAYMENT_CANCELED = 2,
}PAYPAL_RESPONSE;

typedef enum PayPalEnvironment {
	ENV_LIVE,
	ENV_SANDBOX,
	ENV_NONE,
} PAYPAL_ENVIRONMENT;

typedef enum PayPalButtonType {
	BUTTON_68x24,
	BUTTON_68x33,
	BUTTON_118x24,
	BUTTON_152x33,
	BUTTON_194x37,
	BUTTON_278x43,
	BUTTON_294x43,
	BUTTON_TYPE_COUNT,
}PayPalButtonType;

typedef enum PayPalPaymentType {
	HARD_GOODS,
	SERVICE,
	PERSONAL,
	DONATION,
}PayPalPaymentType;

typedef enum PayPalFailureType {
	SYSTEM_ERROR,
	RECIPIENT_ERROR,
	APPLICATION_ERROR,
	CONSUMER_ERROR,
}PAYPAL_FAILURE;

@protocol PayPalMEPDelegate
@required
-(void)paymentSuccess:(NSString const *)transactionID;
-(void)paymentCanceled;
-(void)paymentFailed:(PAYPAL_FAILURE)errorType;

@optional
-(MEPAmounts*)AdjustAmounts:(MEPAddress const *)defaultAddress Currency:(NSString const *)inCurrency Amount:(NSString const *)inAmount Tax:(NSString const *)inTax Shipping:(NSString const *)inShipping;
@end

@interface PayPal : NSObject {
	@private 
	id<PayPalMEPDelegate> delegate;
	BOOL paymentsEnabled;
	PPMEPRootViewController *rootvc;
	NSString *appID;
	NSString *lang;
	PAYPAL_ENVIRONMENT environment;
	PayPalPaymentType paymentType;
	
	//items that can change with each purchased item
	NSString *amount;
	NSString *tax;
	NSString *shipping;
	NSString *currencyCode;
	NSString *itemDesc;
	BOOL shippable; //determines if quickpay is available or not
	NSString *recipientEmail; //the email address the payment should go to
	NSString *senderEmail; //the email address or phone number of the user making the payment
	NSString *merchantName;//the merchant name
	
	PAYPAL_RESPONSE paymentStatus;
	PayPalContext *payPalContext;
	
	BOOL initialized;//determines if the initialization call has finished and the PayPal object is initialized. 
	BOOL recipientPaysFee;
	BOOL dynamicAmountUpdate;
	
	NSMutableArray *paypalButtons;
	
	@public
	NSString *errorMessage;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain, readonly) NSString *appID;
@property (nonatomic, retain) NSString *lang;
@property (nonatomic, retain) NSMutableArray *paypalButtons;

//items that can change with each purchased item
@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) NSString *tax;
@property (nonatomic, retain) NSString *shipping;
@property (nonatomic, retain) NSString *currencyCode;
@property (nonatomic, retain) NSString *itemDesc;
@property BOOL shippable;
@property (nonatomic, retain) NSString *recipientEmail;
@property (nonatomic, retain) NSString *senderEmail;
@property (nonatomic, retain) NSString *merchantName;
@property (readonly) NSString *totalAmount;
@property (nonatomic, retain) PayPalContext *payPalContext;
@property (nonatomic, readonly) PayPalPaymentType paymentType;
@property (readonly) BOOL initialized;
@property (nonatomic, retain) NSString *errorMessage;
@property BOOL recipientPaysFee;
@property BOOL dynamicAmountUpdate;

+(PayPal*)getInstance;
+(PayPal*)initializeWithAppID:(NSString const *)inAppID;
+(PayPal*)initializeWithAppID:(NSString const *)inAppID forEnvironment:(PAYPAL_ENVIRONMENT)env;
-(UIButton *)getPayButton:(UIViewController const *)target buttonType:(PayPalButtonType)buttonType startCheckOut:(SEL)payWithPayPal PaymentType:(PayPalPaymentType)inPaymentType withLeft:(int)left withTop:(int)top;
-(void)Checkout:(PayPalMEPPayment *)currentPayment;
-(void)paymentFinished:(PAYPAL_RESPONSE)reponse;
-(void)setLang:(NSString *)language;
-(void)finishPayment;
-(void)setDefaults;
-(void)EnableShipping;
-(void)DisableShipping;
-(void)SetSenderEmailorPhone:(NSString const *)sender;
-(void)feePaidByReceiver;
-(void)enableDynamicAmountUpdate;
-(PAYPAL_ENVIRONMENT)GetEnvironment;
-(NSString const *)getErrorMessage;

@end

