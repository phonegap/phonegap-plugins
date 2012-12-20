//
//  DGGeofencingHelper.m
//  Geofencing
//
//  Created by Dov Goldberg on 10/18/12.
//
//

#import "DGGeofencingHelper.h"
#import <Cordova/CDVCordovaView.h>

static DGGeofencingHelper *sharedGeofencingHelper = nil;

@implementation DGGeofencingHelper

@synthesize webView;
@synthesize locationManager;
@synthesize didLaunchForRegionUpdate;

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if (self.didLaunchForRegionUpdate) {
        NSString *path = [DGGeofencingHelper applicationDocumentsDirectory];
        NSString *finalPath = [path stringByAppendingPathComponent:@"notifications.dg"];
        NSMutableArray *updates = [NSMutableArray arrayWithContentsOfFile:finalPath];
        
        if (!updates) {
            updates = [NSMutableArray array];
        }
        
        NSMutableDictionary *update = [NSMutableDictionary dictionary];
        
        [update setObject:region.identifier forKey:@"fid"];
        [update setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
        [update setObject:@"enter" forKey:@"status"];
        
        [updates addObject:update];
        
        [updates writeToFile:finalPath atomically:YES];
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"enter" forKey:@"status"];
        [dict setObject:region.identifier forKey:@"fid"];
        NSString *jsStatement = [NSString stringWithFormat:@"DGGeofencing.regionMonitorUpdate(%@);", [dict cdvjk_JSONString]];
        [self.webView stringByEvaluatingJavaScriptFromString:jsStatement];
    }
}

- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if (self.didLaunchForRegionUpdate) {
        NSString *path = [DGGeofencingHelper applicationDocumentsDirectory];
        NSString *finalPath = [path stringByAppendingPathComponent:@"notifications.dg"];
        NSMutableArray *updates = [NSMutableArray arrayWithContentsOfFile:finalPath];
        
        if (!updates) {
            updates = [NSMutableArray array];
        }
        
        NSMutableDictionary *update = [NSMutableDictionary dictionary];
        
        [update setObject:region.identifier forKey:@"fid"];
        [update setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
        [update setObject:@"left" forKey:@"status"];
        
        [updates addObject:update];
        
        [updates writeToFile:finalPath atomically:YES];
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"left" forKey:@"status"];
        [dict setObject:region.identifier forKey:@"fid"];
        NSString *jsStatement = [NSString stringWithFormat:@"DGGeofencing.regionMonitorUpdate(%@);", [dict cdvjk_JSONString]];
        [self.webView stringByEvaluatingJavaScriptFromString:jsStatement];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
#pragma mark TODO - Monitoring Failure Callback
//    NSMutableDictionary* posError = [NSMutableDictionary dictionaryWithCapacity:2];
//    [posError setObject: [NSNumber numberWithInt: error.code] forKey:@"code"];
//    [posError setObject: region.identifier forKey: @"regionid"];
//    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:posError];
//    NSString *callbackId = [self.locationData.locationCallbacks dequeue];
//    if (callbackId) {
//        [self writeJavascript:[result toErrorCallbackString:callbackId]];
//    }
}

- (id) init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self; // Tells the location manager to send updates to this object
    }
    return self;
}

+(DGGeofencingHelper *)sharedGeofencingHelper
{
	//objects using shard instance are responsible for retain/release count
	//retain count must remain 1 to stay in mem
    
	if (!sharedGeofencingHelper)
	{
		sharedGeofencingHelper = [[DGGeofencingHelper alloc] init];
	}
	
	return sharedGeofencingHelper;
}

- (void) dispose {
    locationManager.delegate = nil;
    [locationManager release];
    [sharedGeofencingHelper release];
}

+ (NSString*) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
