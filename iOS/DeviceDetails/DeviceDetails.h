#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface DeviceDetails : CDVPlugin {
	NSMutableDictionary* callbackIds;
}

@property (nonatomic, retain) NSMutableDictionary* callbackIds;

- (void)getDeviceDetails:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)getDeviceUUID:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;

@end