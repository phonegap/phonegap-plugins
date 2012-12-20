#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "FDStatusBarNotifierView.h"

#import <Cordova/CDVPlugin.h>

@interface StatusBarNotifier: CDVPlugin {
	NSMutableDictionary* callbackIds;
  NSString* messageField;
}

@property (nonatomic, retain) NSMutableDictionary* callbackIds;
@property (nonatomic, retain) NSString* messageField;

-	(void) show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
