//
//  CDVNavigationBarController.m
//  HelloPhoneGap1
//
//  Created by Hiedi Utley on 8/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CDVNavigationBarController.h"

@implementation CDVNavigationBarController
@synthesize navItem;
@synthesize leftButton;
@synthesize rightButton;
@synthesize delegate;

-(id) init
{
    self = [super initWithNibName:@"CDVNavigationBar" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) dealloc
{
    [navItem release];
    [leftButton release];
    [rightButton release];
    [delegate release];
    [super dealloc];
    
}
#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)leftNavButtonTapped:(id)sender
{
    [delegate leftNavButtonTapped];
}
-(IBAction)rightNavButtonTapped:(id)sender
{
    [delegate rightNavButtonTapped];
}


@end
