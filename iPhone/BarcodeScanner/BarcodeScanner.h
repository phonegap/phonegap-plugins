//
//  BarcodeScanner.h
//
//  Created by Matt Kane on 12/01/2011.
//  Copyright 2011 Matt Kane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneGapCommand.h"
#import "ZXingWidgetController.h"
#import "QRCodeReader.h"


@interface BarcodeScanner : PhoneGapCommand <ZXingDelegate> {
	NSString* successCallback;
	NSString* failCallback;
}

@property (nonatomic, copy) NSString* successCallback;
@property (nonatomic, copy) NSString* failCallback;

- (void) scan:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
