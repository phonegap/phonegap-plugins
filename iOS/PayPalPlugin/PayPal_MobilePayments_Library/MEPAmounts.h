//
//  MEPAmounts.h
//  PPMEP
//
//  Created by richard smith on 2/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MEPAmounts : NSObject {
	NSString *currency;
	NSString *payment_amount;
	NSString *tax;
	NSString *shipping;
}
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, retain) NSString *payment_amount;
@property (nonatomic, retain) NSString *tax;
@property (nonatomic, retain) NSString *shipping;
@end
