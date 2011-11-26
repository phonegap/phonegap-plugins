//
//  MessageBox.h
//  
// Created by Olivier Louvignes on 11/26/11.
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>

@interface MessageBox : PGPlugin {
    
	NSString* callbackID;  
}

@property (nonatomic, copy) NSString* callbackID;

//Instance Method  
- (void) prompt:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end