//
//  WTWikitudeSDK.m
//  HelloWorld
//
//  Created by Andreas Schacherbauer on 8/24/12.
//
//

#import "WTWikitudePlugin.h"

// Wikitude SDK
#import "WTArchitectView.h"




@interface WTWikitudePlugin () <WTArchitectViewDelegate>

@property (nonatomic, strong) WTArchitectView                               *architectView;

@property (nonatomic, strong) NSString                                      *currentARchitectViewCallbackID;
@property (nonatomic, strong) NSString                                      *currentPlugInErrorCallback;

@property (nonatomic, assign) BOOL                                          isUsingInjectedLocation;

@end


@implementation WTWikitudePlugin
@synthesize architectView=_architectView;


#pragma mark - View Lifecycle
/* View Lifecycle */
- (void)isDeviceSupported:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    @try {
        //        NSString* echo = [arguments objectAtIndex:1];
        
        BOOL isDeviceSupported = [WTArchitectView isDeviceSupported];
        
        if (isDeviceSupported) {
        
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:isDeviceSupported];
            javaScript = [pluginResult toSuccessCallbackString:callbackId];
            
        } else {
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:isDeviceSupported];
            javaScript = [pluginResult toErrorCallbackString:callbackId];
        }
                
        
    } @catch (NSException* exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:javaScript];
}


- (void)open:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    @try {
//        NSString* echo = [arguments objectAtIndex:1];
        
        
        BOOL success = [WTArchitectView isDeviceSupported];
        if ( success ) {
            
            NSString *sdkKey = [options objectForKey:@"apiKey"];
            NSString *architectWorldFilePath = [options objectForKey:@"filePath"];
            
            // First, lets check if we need to init a new sdk view
            if ( !_architectView ) {
                self.architectView = [[WTArchitectView alloc] initWithFrame:self.viewController.view.bounds];
                self.architectView.delegate = self;
                [self.architectView initializeWithKey:sdkKey motionManager:nil];
            }
            
            // then add the view in its own navController to the ui. we need a own navController to have a backButton which can be used to dismiss the view
            UIViewController *viewController = [[UIViewController alloc] init];
            viewController.view = self.architectView;
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            navController.navigationBar.tintColor = [UIColor blackColor];
            navController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissARchitectView)];
            [self.viewController presentViewController:navController animated:NO completion:^{
                // completion code
            }];
                            
            
            
            // and finaly load the architect world, specified in the open function in js
            if (architectWorldFilePath) {
                
                NSString *worldName = [architectWorldFilePath lastPathComponent];
                worldName = [worldName stringByDeletingPathExtension];
                NSString *worldNameExtension = [architectWorldFilePath pathExtension];
                
                NSString *architectWorldDirectoryPath = [architectWorldFilePath stringByDeletingLastPathComponent];

                NSString *loadablePath = [[NSBundle mainBundle] pathForResource:worldName ofType:worldNameExtension inDirectory:architectWorldDirectoryPath];
                [self.architectView loadArchitectWorldFromUrl:loadablePath];
            }
        }
    
        // start the sdk view updates
        [self.architectView start];
        
        
        if ( success ) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nil];
            javaScript = [pluginResult toSuccessCallbackString:callbackId];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            javaScript = [pluginResult toErrorCallbackString:callbackId];
        }
    } @catch (NSException* exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:javaScript];
}

- (void)close:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    @try {
//        NSString* echo = [arguments objectAtIndex:1];
        
        if (self.architectView) {
            
            [self.architectView stop];
//            [self.architectView removeFromSuperview];
        }
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nil];
        javaScript = [pluginResult toSuccessCallbackString:callbackId];
    
    
    } @catch (NSException* exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:javaScript];
}

- (void)show:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    @try {
//        NSString* echo = [arguments objectAtIndex:1];
        
        if (self.architectView) {
            self.architectView.hidden = NO;
        }
        

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nil];
        javaScript = [pluginResult toSuccessCallbackString:callbackId];
    } @catch (NSException* exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:javaScript];
}

- (void)hide:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    @try {
        //        NSString* echo = [arguments objectAtIndex:1];
        
        if (self.architectView) {
            self.architectView.hidden = YES;
        }
        
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nil];
        javaScript = [pluginResult toSuccessCallbackString:callbackId];
    } @catch (NSException* exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:javaScript];
}

- (void)onResume:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    @try {
        //        NSString* echo = [arguments objectAtIndex:1];

        if (self.architectView) {
            [self.architectView start];
        }
        
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:nil];
        javaScript = [pluginResult toSuccessCallbackString:callbackId];
    } @catch (NSException* exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:javaScript];
}

- (void)onPause:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    @try {
        //        NSString* echo = [arguments objectAtIndex:1];

        if (self.architectView) {
            [self.architectView stop];
        }
        
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:nil];
        javaScript = [pluginResult toSuccessCallbackString:callbackId];
    } @catch (NSException* exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:javaScript];
}

#pragma mark - Location Handling

- (void)setLocation:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    @try {
        //        NSString* echo = [arguments objectAtIndex:1];
        
        if (self.architectView) {
            
            float latitude = [[options objectForKey:@"lat"] floatValue];
            float longitude = [[options objectForKey:@"lon"] floatValue];
            float altitude = [[options objectForKey:@"alt"] floatValue];
            float accuracy = [[options objectForKey:@"acc"] floatValue];
            
            if (!self.isUsingInjectedLocation) {
                [self.architectView setUseInjectedLocation:YES];
                self.isUsingInjectedLocation = YES;
            }
            
            [self.architectView injectLocationWithLatitude:latitude longitude:longitude altitude:altitude accuracy:accuracy];
        }
        
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        javaScript = [pluginResult toSuccessCallbackString:callbackId];
    } @catch (NSException* exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:javaScript];
}


#pragma mark - Javascript

- (void)callJavascript:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    
    @try {
        
        if (arguments.count >= 1) {
            
            NSMutableString *javascriptToCall = [[arguments objectAtIndex:1] mutableCopy];
            for (NSUInteger i = 2; i < arguments.count; i++) {
                [javascriptToCall appendString:[arguments objectAtIndex:i]];
            }
            
            if (self.architectView) {
                [self.architectView callJavaScript:javascriptToCall];
            }
                        
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nil];
            javaScript = [pluginResult toSuccessCallbackString:callbackId];
            
        }else
        {
            // return error no javascript to call found
        }
        
        
    } @catch (NSException* exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:javaScript];
}


- (void)onUrlInvoke:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    NSString* javaScript = nil;
    
    @try {

        
        self.currentARchitectViewCallbackID = callbackId;
        self.currentPlugInErrorCallback = callbackId;
        
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
        [pluginResult setKeepCallbackAsBool:YES];
        javaScript = [pluginResult toSuccessCallbackString:callbackId];

        
    } @catch (NSException* exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
        javaScript = [pluginResult toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:javaScript];
}

#pragma mark - WTArchitectView Delegate
- (void)urlWasInvoked:(NSString *)url
{

    CDVPluginResult *pluginResult = nil;
    NSString *javaScriptResult = nil;
    
    
    if (url && self.currentARchitectViewCallbackID) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:url];
        [pluginResult setKeepCallbackAsBool:YES];
        javaScriptResult = [pluginResult toSuccessCallbackString:self.currentARchitectViewCallbackID];

        
    }else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        javaScriptResult = [pluginResult toSuccessCallbackString:self.currentPlugInErrorCallback];
    }
    
    [self writeJavascript:javaScriptResult];
}

- (void)dismissARchitectView
{
    [self.viewController dismissModalViewControllerAnimated:NO];
    [self.architectView stop];
}

@end
