//
//  PDFView.h
//
//  Created by Nigel Barber on 15/10/2011.
//  Copyright 2011 Mindbrix Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PDFView : UIView 
{

}

@property( nonatomic, assign ) int page;
@property( nonatomic, assign ) NSString *resourceName;
@property( nonatomic, assign ) NSURL *resourceURL;

+(CGRect) mediaRect:(NSString *)resourceName;
+(CGRect) mediaRectForURL:(NSURL *)resourceURL;
+(CGRect) mediaRectForURL:(NSURL *)resourceURL atPage:(int)page;
+(int) pageCountForURL:(NSURL *)resourceURL;
+(NSURL *)resourceURLForName:(NSString *)resourceName;
  
@end
