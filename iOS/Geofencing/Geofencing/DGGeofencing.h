//
//  Geofencing.h
//  TikalTimeTracker
//  Sections of this code adapted from Apache Cordova
//
//  Created by Dov Goldberg on 5/3/12.
//  Copyright (c) 2012 Ogonium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import <Cordova/CDVPlugin.h>

#import "DGGeofencingHelper.h"

#define KEY_REGION_ID       @"fid"
#define KEY_REGION_LAT      @"latitude"
#define KEY_REGION_LNG      @"longitude"
#define KEY_REGION_RADIUS   @"radius"
#define KEY_REGION_ACCURACY @"accuracy"

enum DGLocationStatus {
    PERMISSIONDENIED = 1,
    POSITIONUNAVAILABLE,
    TIMEOUT,
    REGIONMONITORINGPERMISSIONDENIED,
    REGIONMONITORINGUNAVAILABLE
};
typedef NSInteger DGLocationStatus;

enum DGLocationAccuracy {
    DGLocationAccuracyBestForNavigation,
    DGLocationAccuracyBest,
    DGLocationAccuracyNearestTenMeters,
    DGLocationAccuracyHundredMeters,
    DGLocationAccuracyThreeKilometers
};
typedef NSInteger DGLocationAccuracy;

// simple ojbect to keep track of location information
@interface DGLocationData : NSObject

@property (nonatomic, assign) DGLocationStatus locationStatus;
@property (nonatomic, retain) CLLocation* locationInfo;
@property (nonatomic, retain) NSMutableArray* locationCallbacks;

@end

@interface DGGeofencing : CDVPlugin <CLLocationManagerDelegate>

//@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) DGLocationData* locationData;

- (BOOL) isLocationServicesEnabled;
- (BOOL) isAuthorized;
- (BOOL) isRegionMonitoringAvailable;
- (BOOL) isRegionMonitoringEnabled;
- (void) saveGeofenceCallbackId:(NSString *) callbackId;
- (void) addRegionToMonitor:(NSMutableDictionary *)params;
- (void) removeRegionToMonitor:(NSMutableDictionary *)params;

- (void) returnLocationError: (NSUInteger) errorCode withMessage: (NSString*) message;
- (void) returnRegionSuccess;

#pragma mark Plugin Functions
- (void) addRegion:(CDVInvokedUrlCommand*)command;
- (void) removeRegion:(CDVInvokedUrlCommand*)command;
- (void) getWatchedRegionIds:(CDVInvokedUrlCommand*)command;
- (void) getPendingRegionUpdates:(CDVInvokedUrlCommand*)command;
//- (void)addRegion:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
//- (void)removeRegion:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
//- (void)getWatchedRegionIds:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
