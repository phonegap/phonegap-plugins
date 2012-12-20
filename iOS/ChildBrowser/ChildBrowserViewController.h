//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//  Copyright 2012, Randy McMillan

#import <UIKit/UIKit.h>

@protocol ChildBrowserDelegate <NSObject>

/*
 *  onChildLocationChanging:newLoc
 *
 *  Discussion:
 *    Invoked when a new page has loaded
 */
- (void)onChildLocationChange:(NSString*)newLoc;
- (void)onOpenInSafari;
- (void)onClose;

@end

@protocol CDVOrientationDelegate <NSObject>

- (NSUInteger)supportedInterfaceOrientations;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (BOOL)shouldAutorotate;

@end

@interface ChildBrowserViewController : UIViewController <UIWebViewDelegate>{}

@property (nonatomic, strong) IBOutlet UIWebView* webView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* closeBtn;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* refreshBtn;
@property (nonatomic, strong) IBOutlet UILabel* addressLabel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* backBtn;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* fwdBtn;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* safariBtn;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* spinner;

// unsafe_unretained is equivalent to assign - used to prevent retain cycles in the two properties below
@property (nonatomic, unsafe_unretained) id <ChildBrowserDelegate> delegate;
@property (nonatomic, unsafe_unretained) id orientationDelegate;

@property (copy) NSString* imageURL;
@property (assign) BOOL isImage;
@property (assign) BOOL scaleEnabled;

- (ChildBrowserViewController*)initWithScale:(BOOL)enabled;
- (IBAction)onDoneButtonPress:(id)sender;
- (IBAction)onSafariButtonPress:(id)sender;
- (void)loadURL:(NSString*)url;
- (void)closeBrowser;

@end
