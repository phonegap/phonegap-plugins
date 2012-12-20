//
//  MyClass.h
//  hello
//
//  Created by kissthink on 12-4-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface callvenderapp : CDVPlugin

{
    NSString * callbackID;
    
}

@property (nonatomic,copy) NSString* callbackID;

- (void) run:(NSMutableString*) arguments withDict : (NSMutableDictionary*)options;
@end
