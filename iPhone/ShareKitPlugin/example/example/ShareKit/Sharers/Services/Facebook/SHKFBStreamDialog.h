//
//  SHKFBStreamDialog.h
//  Adds a little bit extra control to FBStreamDialog
//
//  Created by Nathan Weiner on 7/26/10.
//  Copyright 2010 Idea Shower, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBStreamDialog.h"

@interface SHKFBStreamDialog : FBStreamDialog
{
	NSString *defaultStatus;
}

@property (nonatomic, retain) NSString *defaultStatus;

@end
