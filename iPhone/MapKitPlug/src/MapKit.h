//
//  UIControls.h
//  PhoneGap
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#ifdef PHONEGAP_FRAMEWORK
    #import <PhoneGap/PhoneGapCommand.h>
#else
    #import "PhoneGapCommand.h"
#endif


@interface MapKitView : PhoneGapCommand <MKMapViewDelegate> 
{
	UIView* childView;
    MKMapView* mapView;
	NSString* buttonCallback;
	UIButton*  imageButton;
}

@property (nonatomic, retain) NSString *buttonCallback;
@property (nonatomic, retain) UIView* childView;
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) UIButton*  imageButton;

- (void)createView;

- (void)showMap:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)hideMap:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)destroyMap:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)clearMapPins:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)addMapPins:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)setMapData:withDict:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void) closeButton:(id)button;

@end
