//
//  ChildBrowserViewController.m
//
//  Created by Jesse MacFadyen on 21/07/09.
//  Copyright 2009 Nitobi. All rights reserved.
//

#import "ChildBrowserViewController.h"


@implementation ChildBrowserViewController

@synthesize imageURL;
@synthesize supportedOrientations;
@synthesize isImage;
@synthesize delegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

+ (NSString*) resolveImageResource:(NSString*)resource
{
	NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
	BOOL isLessThaniOS4 = ([systemVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedAscending);
	
	// the iPad image (nor retina) differentiation code was not in 3.x, and we have to explicitly set the path
	if (isLessThaniOS4)
	{
        return [NSString stringWithFormat:@"%@.png", resource];
	}
	
	return resource;
}


- (ChildBrowserViewController*)initWithScale:(BOOL)enabled
{
    self = [super init];
	
	
	scaleEnabled = enabled;
	
	return self;	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
   // [super viewDidLoad];
    
	refreshBtn.image = [UIImage imageNamed:[[self class] resolveImageResource:@"ChildBrowser.bundle/but_refresh"]];
	backBtn.image = [UIImage imageNamed:[[self class] resolveImageResource:@"ChildBrowser.bundle/arrow_left"]];
	fwdBtn.image = [UIImage imageNamed:[[self class] resolveImageResource:@"ChildBrowser.bundle/arrow_right"]];
	safariBtn.image = [UIImage imageNamed:[[self class] resolveImageResource:@"ChildBrowser.bundle/compass"]];

	webView.delegate = self;
	webView.scalesPageToFit = TRUE;
	webView.backgroundColor = [UIColor colorWithRed:0.118 green:0.161 blue:0.227 alpha:1.000];
	NSLog(@"View did load");
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    
    if ([self respondsToSelector:@selector(presentingViewController)]) { //Reference UIViewController.h Line:179 for update to iOS 5 difference - @RandyMcMillan

        //[[super presentingViewController] didReceiveMemoryWarning];
        [super didReceiveMemoryWarning];
        
    } else {
        webView = nil;        
        [super didReceiveMemoryWarning];
    }

	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	NSLog(@"View did UN-load");
}


- (void)dealloc {

	webView.delegate = nil;
    webView = nil;
	//[webView release];
    closeBtn = nil;
	//[closeBtn release];
    refreshBtn = nil;
	//[refreshBtn release];
    addressLabel = nil;
	//[addressLabel release];
	backBtn = nil;
    //[backBtn release];
	fwdBtn = nil;
    //[fwdBtn release];
	safariBtn = nil;
    //[safariBtn release];
	spinner = nil;
    //[spinner release];
	supportedOrientations = nil;
    //[ supportedOrientations release];
	[super dealloc];
}

-(void)closeBrowser
{
	
	if(delegate != NULL)
	{
		[delegate onClose];		
	}
	
    if ([self respondsToSelector:@selector(presentingViewController)]) { //Reference UIViewController.h Line:179 for update to iOS 5 difference - @RandyMcMillan
        
        [[super presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        
        } else {
            
        [[super parentViewController] dismissModalViewControllerAnimated:YES];
    }

    
}

-(IBAction) onDoneButtonPress:(id)sender
{
	[ self closeBrowser];

    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]];
    //[webView loadRequest:request];
}


-(IBAction) onSafariButtonPress:(id)sender
{
	
	if(delegate != NULL)
	{
		[delegate onOpenInSafari];		
	}
	
	if(isImage)
	{
		NSURL* pURL = [ [NSURL alloc] initWithString:imageURL ];
		[ [ UIApplication sharedApplication ] openURL:pURL  ];
	}
	else
	{
		NSURLRequest *request = webView.request;
		[[UIApplication sharedApplication] openURL:request.URL];
	}

	 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation 
{
	BOOL autoRotate = [self.supportedOrientations count] > 1; // autorotate if only more than 1 orientation supported
	if (autoRotate)
	{
		if ([self.supportedOrientations containsObject:
			 [NSNumber numberWithInt:interfaceOrientation]]) {
			return YES;
		}
    }
	
	return NO;
}




- (void)loadURL:(NSString*)url
{
    
    NSURLCache* cache = [NSURLCache sharedURLCache];
    [cache setMemoryCapacity:4 * 1024 * 1024]; //refer NSURLCache.h line:130 for alt values
    [cache setDiskCapacity:512*1024];
    
	NSLog(@"Opening Url : %@",url);
	 
	if( [url hasSuffix:@".png" ]  || 
	    [url hasSuffix:@".jpg" ]  || 
		[url hasSuffix:@".jpeg" ] || 
		[url hasSuffix:@".bmp" ]  ||
       [url hasSuffix:@".svg" ]  || 
		[url hasSuffix:@".gif" ]  )
	{
		imageURL = nil;
		imageURL = [url copy];
		isImage = YES;
		NSString* htmlText = @"<html><body style='background-color:#333;margin:30%;padding:0px;'><img style='min-height:200px;margin:0px;padding:0px;width:100%;height:auto;' alt='' src='IMGSRC'/></body></html>";
		htmlText = [ htmlText stringByReplacingOccurrencesOfString:@"IMGSRC" withString:url ];

		[webView loadHTMLString:htmlText baseURL:[NSURL URLWithString:@""]];
		
	}
	else
	{
             
		imageURL = @"";
		isImage = NO;
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
		[webView loadRequest:request];
        
	}
	webView.hidden = NO;
}


- (void)webViewDidStartLoad:(UIWebView *)sender {
	addressLabel.text = @"Loading...";
    addressLabel.textColor = [UIColor colorWithRed:0.004 green:0.000 blue:0.506 alpha:1.000];
	backBtn.enabled = webView.canGoBack;
	fwdBtn.enabled = webView.canGoForward;
	
	[ spinner startAnimating ];
	
}

- (void)webViewDidFinishLoad:(UIWebView *)sender 
{
	NSURLRequest *request = webView.request;
	NSLog(@"New Address is : %@",request.URL.absoluteString);
	addressLabel.text = request.URL.absoluteString;
	backBtn.enabled = webView.canGoBack;
	fwdBtn.enabled = webView.canGoForward;
	[ spinner stopAnimating ];
    addressLabel.alpha = 0.0;
	
	if(delegate != NULL)
	{
		[delegate onChildLocationChange:request.URL.absoluteString];		
	}

}


@end
