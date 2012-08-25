//
//  UIControls.h
//  Cordova
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#ifdef CORDOVA_FRAMEWORK
    #import <Cordova/CDVPlugin.h>
#else
    #import "CDVPlugin.h"
#endif


@interface MapKitView : CDVPlugin <MKMapViewDelegate> 
{
}

@property (nonatomic, copy) NSString *buttonCallback;
@property (nonatomic, retain) UIView* childView;
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) UIButton*  imageButton;

- (void)createView;

- (void)showMap:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)hideMap:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)destroyMap:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)clearMapPins:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)addMapPins:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)setMapData:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void) closeButton:(id)button;

@end
