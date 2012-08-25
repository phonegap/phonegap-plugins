//
//  CDVAnnotation.h
//  Cordova
//
//  Created by Brett Rudd on 17/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CDVAnnotation : NSObject <MKAnnotation> {
@private
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
	NSString *_subTitle;
	NSString *_imageURL;
	NSInteger _index;
	MKPlacemark *_placemark;
	NSString *pinColor;
	BOOL selected;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) MKPlacemark *placemark;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *pinColor;
@property (nonatomic, assign) BOOL selected;

- (void)notifyCalloutInfo:(MKPlacemark *)placemark;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate index:(NSInteger)index title:(NSString*)title subTitle:(NSString*)subTitle imageURL:(NSString*)imageURL;

@end

