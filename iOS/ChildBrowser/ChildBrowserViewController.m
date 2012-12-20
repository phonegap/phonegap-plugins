// /  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//  Copyright 2012, Randy McMillan

#import "ChildBrowserViewController.h"

@implementation ChildBrowserViewController

@synthesize imageURL, isImage;
@synthesize delegate, orientationDelegate;
@synthesize spinner, webView, addressLabel;
@synthesize closeBtn, refreshBtn, backBtn, fwdBtn, safariBtn;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

+ (NSString*)resolveImageResource:(NSString*)resource
{
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    BOOL isLessThaniOS4 = ([systemVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedAscending);

    if (isLessThaniOS4) {
        return [NSString stringWithFormat:@"%@.png", resource];
    } else {
        if (([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES) && ([[UIScreen mainScreen] scale] == 2.00)) {
            return [NSString stringWithFormat:@"%@@2x.png", resource];
        }
    }

    return resource; // if all else fails
}

- (ChildBrowserViewController*)initWithScale:(BOOL)enabled
{
    self = [super init];
    self.scaleEnabled = enabled;
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.refreshBtn.image = [UIImage imageNamed:[[self class] resolveImageResource:@"ChildBrowser.bundle/but_refresh"]];
    self.backBtn.image = [UIImage imageNamed:[[self class] resolveImageResource:@"ChildBrowser.bundle/arrow_left"]];
    self.fwdBtn.image = [UIImage imageNamed:[[self class] resolveImageResource:@"ChildBrowser.bundle/arrow_right"]];
    self.safariBtn.image = [UIImage imageNamed:[[self class] resolveImageResource:@"ChildBrowser.bundle/compass"]];

    self.webView.delegate = self;
    self.webView.scalesPageToFit = TRUE;
    self.webView.backgroundColor = [UIColor whiteColor];
    NSLog(@"View did load");
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSLog(@"View did UN-load");
}

- (void)dealloc
{
    self.webView.delegate = nil;
    self.delegate = nil;
    self.orientationDelegate = nil;

#if !__has_feature(objc_arc)
    self.webView = nil;
    self.closeBtn = nil;
    self.refreshBtn = nil;
    self.addressLabel = nil;
    self.backBtn = nil;
    self.fwdBtn = nil;
    self.safariBtn = nil;
    self.spinner = nil;

    [super dealloc];
#endif
}

- (void)closeBrowser
{
    if (self.delegate != nil) {
        [self.delegate onClose];
    }
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        // Reference UIViewController.h Line:179 for update to iOS 5 difference - @RandyMcMillan
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)onDoneButtonPress:(id)sender
{
    [self closeBrowser];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]];
    [self.webView loadRequest:request];
}

- (IBAction)onSafariButtonPress:(id)sender
{
    if (self.delegate != nil) {
        [self.delegate onOpenInSafari];
    }

    if (self.isImage) {
        NSURL* pURL = [NSURL URLWithString:self.imageURL];
        [[UIApplication sharedApplication] openURL:pURL];
    } else {
        NSURLRequest* request = self.webView.request;
        [[UIApplication sharedApplication] openURL:request.URL];
    }
}

- (void)loadURL:(NSString*)url
{
    NSLog(@"Opening Url : %@", url);

    if ([url hasSuffix:@".png"] ||
        [url hasSuffix:@".jpg"] ||
        [url hasSuffix:@".jpeg"] ||
        [url hasSuffix:@".bmp"] ||
        [url hasSuffix:@".gif"]) {
        self.imageURL = nil;
        self.imageURL = url;
        self.isImage = YES;
        NSString* htmlText = @"<html><body style='background-color:#333;margin:0px;padding:0px;'><img style='min-height:200px;margin:0px;padding:0px;width:100%;height:auto;' alt='' src='IMGSRC'/></body></html>";
        htmlText = [htmlText stringByReplacingOccurrencesOfString:@"IMGSRC" withString:url];

        [self.webView loadHTMLString:htmlText baseURL:[NSURL URLWithString:@""]];
    } else {
        self.imageURL = @"";
        self.isImage = NO;
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
    }
    self.webView.hidden = NO;
}

- (void)webViewDidStartLoad:(UIWebView*)sender
{
    self.addressLabel.text = @"Loading...";
    self.backBtn.enabled = self.webView.canGoBack;
    self.fwdBtn.enabled = self.webView.canGoForward;

    [self.spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView*)sender
{
    NSURLRequest* request = self.webView.request;

    NSLog(@"New Address is : %@", request.URL.absoluteString);
    self.addressLabel.text = request.URL.absoluteString;
    self.backBtn.enabled = self.webView.canGoBack;
    self.fwdBtn.enabled = self.webView.canGoForward;
    [self.spinner stopAnimating];

    if (self.delegate != NULL) {
        [self.delegate onChildLocationChange:request.URL.absoluteString];
    }
}

/*- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    NSLog (@"webView:didFailLoadWithError");
    [spinner stopAnimating];
    addressLabel.text = @"Failed";
    if (error != NULL) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: [error localizedDescription]
                                   message: [error localizedFailureReason]
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }
}
*/

#pragma mark CDVOrientationDelegate

- (BOOL)shouldAutorotate
{
    if ((self.orientationDelegate != nil) && [self.orientationDelegate respondsToSelector:@selector(shouldAutorotate)]) {
        return [self.orientationDelegate shouldAutorotate];
    }

    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ((self.orientationDelegate != nil) && [self.orientationDelegate respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [self.orientationDelegate supportedInterfaceOrientations];
    }

    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ((self.orientationDelegate != nil) && [self.orientationDelegate respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)]) {
        return [self.orientationDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }

    return YES;
}

@end
