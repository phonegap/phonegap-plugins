//
//  UIView+Image.h
//
//  Created by Nigel Barber on 21/07/2011.
//  Copyright 2011 Mindbrix Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView( Image )

-(UIImage *) image;
-(void) savePNG:(NSString *)filePath;
-(void) saveJPEG:(NSString *)filePath :(float)quality;

@end
