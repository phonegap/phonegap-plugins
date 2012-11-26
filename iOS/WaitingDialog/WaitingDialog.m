//
//  WaitingDialog.m
// 
//
//  Created by Guido Sabatini in 2012
//

#import "WaitingDialog.h"

@interface WaitingDialog () {
    UIAlertView *waitingDialog;
}

@property (nonatomic, retain) UIAlertView *waitingDialog;
-(void)showWaitingDialogWithText:(NSString*)text;
-(void)hideWaitingDialog;

@end

@implementation WaitingDialog

@synthesize waitingDialog = _waitingDialog;

-(UIAlertView *)waitingDialog {
    if (!_waitingDialog) {
        _waitingDialog = [[[UIAlertView alloc] initWithTitle:@"" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
    }
    return _waitingDialog;
}

// UNCOMMENT THIS METHOD if you want to use the plugin with versions of cordova < 2.2.0
//- (void) show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
//    NSString *text = @"Please wait...";
//    @try {
//        text = [options valueForKey:@"text"];
//    }
//    @catch (NSException *exception) {
//        DLog(@"Cannot read text argument")
//    }
//
//    [self showWaitingDialogWithText:text];
//}

// COMMENT THIS METHOD if you want to use the plugin with versions of cordova < 2.2.0
- (void) show:(CDVInvokedUrlCommand*)command {
    NSString *text = @"Please wait...";
    @try {
        text = [command.arguments objectAtIndex:0];
    }
    @catch (NSException *exception) {
        DLog(@"Cannot read text argument")
    }
    
    [self showWaitingDialogWithText:text];
}

// UNCOMMENT THIS METHOD if you want to use the plugin with versions of cordova < 2.2.0
//- (void) hide:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
//    [self hideWaitingDialog];
//}

// COMMENT THIS METHOD if you want to use the plugin with versions of cordova < 2.2.0
- (void) hide:(CDVInvokedUrlCommand*)command {
    [self hideWaitingDialog];
}

#pragma mark - PRIVATE METHODS

-(void)showWaitingDialogWithText:(NSString *)text {
    [self.waitingDialog setTitle:text];
    [self.waitingDialog show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(self.waitingDialog.bounds.size.width / 2, self.waitingDialog.bounds.size.height - 50);
    [indicator startAnimating];
    [self.waitingDialog addSubview:indicator];
    [indicator release];
}

-(void)hideWaitingDialog {
    if (_waitingDialog) {
        [self.waitingDialog dismissWithClickedButtonIndex:0 animated:YES];
        _waitingDialog = nil;
    }
}



@end