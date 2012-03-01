//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//  Copyright (c) 2011, IBM Corporation
//  Copyright 2012, Randy McMillan

#import "ChildBrowserCommand.h"

#ifdef PHONEGAP_FRAMEWORK
//	#import <PhoneGap/PhoneGapViewController.h>
#import <PhoneGap/PGViewController.h>
#else
//	#import <PhoneGap/PhoneGapViewController.h> TODO add based on PhoneGap version
#import "PGViewController.h"
#endif


@implementation ChildBrowserCommand

@synthesize childBrowser;

- (void) showWebPage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options // args: url
{	
	
    if(childBrowser == NULL)
	{
		childBrowser = [[ ChildBrowserViewController alloc ] initWithScale:FALSE ];
		childBrowser.delegate = self;
	}
	
    //Before 1.4.1 PhoneGapViewController* cont = (PhoneGapViewController*)[ super appViewController ];
    PGViewController* cont = (PGViewController*)[ super viewController ];
    childBrowser.supportedOrientations = cont.supportedOrientations;
    
    if ([cont respondsToSelector:@selector(presentViewController)]) {
        //Reference UIViewController.h Line:179 for update to iOS 5 difference - @RandyMcMillan
        [cont presentViewController:childBrowser animated:YES completion:nil];        
    } else {
        [ cont presentModalViewController:childBrowser animated:YES ];
    }                 
    
    NSString *url = (NSString*) [arguments objectAtIndex:0];
    
    [childBrowser loadURL:url  ];
    
}

-(void) close:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options // args: url
{
    [ childBrowser closeBrowser];
	
}

-(void) onClose
{
	NSString* jsCallback = [NSString stringWithFormat:@"ChildBrowser._onClose();",@""];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
}

-(void) onOpenInSafari
{
	NSString* jsCallback = [NSString stringWithFormat:@"ChildBrowser._onOpenExternal();",@""];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
}


-(void) onChildLocationChange:(NSString*)newLoc
{
	
	NSString* tempLoc = [NSString stringWithFormat:@"%@",newLoc];
	NSString* encUrl = [tempLoc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSString* jsCallback = [NSString stringWithFormat:@"ChildBrowser._onLocationChange('%@');",encUrl];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
    
}


@end
