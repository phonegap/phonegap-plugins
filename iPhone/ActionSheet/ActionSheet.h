//
//  ActionSheet.h
//  
// Created by Olivier Louvignes on 11/27/2011.
//
// Copyright 2011 Olivier Louvignes. All rights reserved.
// MIT Licensed

#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>

@interface ActionSheet : PGPlugin <UIActionSheetDelegate> {
    
	NSString* callbackID;

}

@property (nonatomic, copy) NSString* callbackID;

//Instance Method  
- (void) create:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end