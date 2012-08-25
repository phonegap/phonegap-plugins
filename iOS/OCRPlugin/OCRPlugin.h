//
//  OCRPlugin.h
//  pruebaTesseract
//
//  Created by Admin on 09/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Cordova/CDV.h>
@class claseAuxiliar;

@interface OCRPlugin : CDVPlugin 

@property (nonatomic, copy) NSString* callbackID;

- (void) recogniseOCR:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options; 

@end
