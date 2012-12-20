#import "StatusBarNotifier.h"

@implementation StatusBarNotifier

@synthesize callbackIds = _callbackIds;
@synthesize messageField;

- (NSMutableDictionary*)callbackIds {
	if(_callbackIds == nil) {
		_callbackIds = [[NSMutableDictionary alloc] init];
	}
	return _callbackIds;
}

- (void)show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
	[self.callbackIds setValue:[arguments pop] forKey:@"show"];	
  AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
  [self setMessageField:[options objectForKey:@"text"] ?: @""];
  float timeOnScreen = [[options objectForKey:@"timeOnScreen"] floatValue] ?: 3.0;
  FDStatusBarNotifierView *notifierView = [[FDStatusBarNotifierView alloc] initWithMessage:self.messageField];
  notifierView.timeOnScreen = timeOnScreen;
  [notifierView showInWindow:appDelegate.window];
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	[self writeJavascript:[pluginResult toSuccessCallbackString:[self.callbackIds valueForKey:@"show"]]];	
}

- (void) dealloc {
	[_callbackIds dealloc];
	[super dealloc];
}

@end
