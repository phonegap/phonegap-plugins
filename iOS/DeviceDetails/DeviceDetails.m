#import "DeviceDetails.h"
#import <Cordova/JSONKit.h>

@implementation DeviceDetails

@synthesize callbackIds = _callbackIds;

- (NSMutableDictionary*)callbackIds {
	if(_callbackIds == nil) {
		_callbackIds = [[NSMutableDictionary alloc] init];
	}
	return _callbackIds;
}

- (void)getDeviceDetails:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
	[self.callbackIds setValue:[arguments pop] forKey:@"getDeviceDetails"];

  NSMutableDictionary *results = [NSMutableDictionary dictionary];

  // Get the users Device Model, Display Name Token & Version Number
  UIDevice *dev = [UIDevice currentDevice];
  [results setValue:dev.uniqueIdentifier forKey:@"deviceUuid"];
  [results setValue:dev.name forKey:@"deviceName"];
  [results setValue:dev.model forKey:@"deviceModel"];
  [results setValue:dev.systemVersion forKey:@"deviceSystemVersion"];

	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:results];
	[self writeJavascript:[pluginResult toSuccessCallbackString:[self.callbackIds valueForKey:@"getDeviceDetails"]]];
}

- (void)getDeviceUUID:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
	[self.callbackIds setValue:[arguments pop] forKey:@"getDeviceUUID"];

  NSMutableDictionary *results = [NSMutableDictionary dictionary];

  // Get the users Device UUID
  UIDevice *dev = [UIDevice currentDevice];
  [results setValue:dev.uniqueIdentifier forKey:@"deviceUuid"];

	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:results];
	[self writeJavascript:[pluginResult toSuccessCallbackString:[self.callbackIds valueForKey:@"getDeviceUUID"]]];
}

- (void) dealloc {
	[_callbackIds dealloc];
	[super dealloc];
}

@end
