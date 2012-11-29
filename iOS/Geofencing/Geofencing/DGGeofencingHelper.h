//
//  DGGeofencingHelper.h
//  Geofencing
//
//  Created by Dov Goldberg on 10/18/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Cordova/JSONKit.h>

@class CDVCordovaView;
@interface DGGeofencingHelper : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) CDVCordovaView *webView;
@property (nonatomic, assign) BOOL didLaunchForRegionUpdate;

+(DGGeofencingHelper*)sharedGeofencingHelper;

- (void) dispose;
+ (NSString*) applicationDocumentsDirectory;

@end
