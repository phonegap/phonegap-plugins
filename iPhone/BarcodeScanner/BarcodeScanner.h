//
//  BarcodeScanner.h
//
//  Created by Matt Kane on 12/01/2011.
//  Copyright 2011 Matt Kane. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif
#import "ZXingWidgetController.h"
#import "QRCodeReader.h"


@interface BarcodeScanner : PGPlugin <ZXingDelegate> {
	NSString* successCallback;
	NSString* failCallback;
}

@property (nonatomic, copy) NSString* successCallback;
@property (nonatomic, copy) NSString* failCallback;

- (void) scan:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
