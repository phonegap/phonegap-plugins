//
//  UIImage+PDF.h
//
//  Created by Nigel Barber on 15/10/2011.
//  Copyright 2011 Mindbrix Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Image.h"
#import "PDFView.h"
#import "NSString+MD5.h"


#define UIIMAGE_PDF_CACHEING    1


@interface UIImage( PDF )

+(UIImage *) imageOrPDFNamed:(NSString *)resourceName; 
+(UIImage *) imageOrPDFWithContentsOfFile:(NSString *)path;


+(UIImage *) imageWithPDFNamed:(NSString *)resourceName atSize:(CGSize)size atPage:(int)page;
+(UIImage *) imageWithPDFNamed:(NSString *)resourceName atSize:(CGSize)size;

+(UIImage *) imageWithPDFNamed:(NSString *)resourceName atWidth:(CGFloat)width atPage:(int)page;
+(UIImage *) imageWithPDFNamed:(NSString *)resourceName atWidth:(CGFloat)width;

+(UIImage *) imageWithPDFNamed:(NSString *)resourceName atHeight:(CGFloat)height atPage:(int)page;
+(UIImage *) imageWithPDFNamed:(NSString *)resourceName atHeight:(CGFloat)height;

+(UIImage *) originalSizeImageWithPDFNamed:(NSString *)resourceName atPage:(int)page;
+(UIImage *) originalSizeImageWithPDFNamed:(NSString *)resourceName;



+(UIImage *) imageWithPDFURL:(NSURL *)URL atSize:(CGSize)size atPage:(int)page;
+(UIImage *) imageWithPDFURL:(NSURL *)URL atSize:(CGSize)size;

+(UIImage *) imageWithPDFURL:(NSURL *)URL atWidth:(CGFloat)width atPage:(int)page;
+(UIImage *) imageWithPDFURL:(NSURL *)URL atWidth:(CGFloat)width;


+(UIImage *) imageWithPDFURL:(NSURL *)URL atHeight:(CGFloat)height atPage:(int)page;
+(UIImage *) imageWithPDFURL:(NSURL *)URL atHeight:(CGFloat)height;

+(UIImage *) originalSizeImageWithPDFURL:(NSURL *)URL atPage:(int)page;
+(UIImage *) originalSizeImageWithPDFURL:(NSURL *)URL;


@end
