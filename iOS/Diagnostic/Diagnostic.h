//
//  Diagnostic.h
//  Plugin diagnostic
//
//  Copyright (c) 2012 AVANTIC ESTUDIO DE INGENIEROS
//

#import <Cordova/CDVPlugin.h>

@interface Diagnostic : CDVPlugin

- (void) isLocationEnabled: (NSMutableArray*)arguments withDict:(NSMutableDictionary*) options;
- (void) isLocationEnabledOnly: (NSMutableArray*)arguments withDict:(NSMutableDictionary*) options;
- (void) isLocationAuthorized: (NSMutableArray*)arguments withDict:(NSMutableDictionary*) options;
- (void) isWifiEnabled: (NSMutableArray*)arguments withDict:(NSMutableDictionary*) options;
- (void) isCameraEnabled: (NSMutableArray*)arguments withDict:(NSMutableDictionary*) options;

@end
