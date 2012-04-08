//
//  MEPAddress.h
//  PPMEP
//
//  Created by richard smith on 2/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MEPAddress : NSObject {
	NSString *name;
	NSString *street1;
	NSString *street2;
	NSString *city;
	NSString *state;
	NSString *postalcode;
	NSString *countrycode;
	NSString *country;
}
@property (readonly) NSString *name;
@property (readonly) NSString *street1;
@property (readonly) NSString *street2;
@property (readonly) NSString *city;
@property (readonly) NSString *state;
@property (readonly) NSString *postalcode;
@property (readonly) NSString *countrycode;
@property (readonly) NSString *country;
@end
