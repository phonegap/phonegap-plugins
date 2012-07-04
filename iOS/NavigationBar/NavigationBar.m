/*
 NavigationBar.m

 Work based on the NativeControls plugin (Jesse MacFadyen, MIT licensed) and additions made by Hiedi Utley
 (https://github.com/hutley/HelloPhoneGap1.0/) and zSprawl (https://github.com/zSprawl/NativeControls/).

 Navigation bar API cleaned, improved and moved in a separate plugin by Andreas Sommer
 (AndiDog, https://github.com/AndiDog/phonegap-plugins).
 */

#import "NavigationBar.h"
#import <QuartzCore/QuartzCore.h>

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVDebug.h>
#else
#import "CDVDebug.h"
#endif

@implementation NavigationBar
#ifndef __IPHONE_3_0
@synthesize webView;
#endif
@synthesize navBarController;

-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (NavigationBar*)[super initWithWebView:theWebView];
    if (self)
	{
		originalWebViewBounds = theWebView.bounds;
        navBarHeight = 44.0f;
    }
    return self;
}

- (void)dealloc
{
    if (navBar)
        [navBar release];

    if (navBarController)
        [navBarController release];

    [super dealloc];
}

-(void)correctWebViewBounds
{
    // This plugin has to play nice with the tab bar plugin, so let's only change the top bound, not the one at the
    // bottom. Of course this assumes that the tab bar plugin does not relayout in parallel (can that happen?).

    // TODO: does this still work if the application was started in landscape mode and thus originalWebViewBounds are switched?
    CGFloat left = originalWebViewBounds.origin.x;
    CGFloat right = left + originalWebViewBounds.size.width;
    CGFloat top = originalWebViewBounds.origin.y;
    CGFloat bottom = top + originalWebViewBounds.size.height;

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation)
    {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            // No need to change width/height from original bounds
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            right = left + (bottom - top) + 20.0f;
            bottom = top + (right - left) - 20.0f;
            break;
    }

    if(navBar != nil && !navBar.hidden)
        top += navBarHeight;

    CGRect webViewBounds = CGRectMake(left, top, right - left, bottom - top);

    [self.webView setFrame:webViewBounds];
}

/*********************************************************************************/

-(void) create:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    if (!navBar)
    {
        navBarController = [[CDVNavigationBarController alloc] init];
        navBar = (UINavigationBar*)[navBarController view];

        NSString * style = [arguments objectAtIndex:0];

        if(style && [style isEqualToString:@"BlackTranslucent"])
            navBar.barStyle = UIBarStyleBlackTranslucent;
        else if(style && [style isEqualToString:@"BlackOpaque"])
            navBar.barStyle = UIBarStyleBlackOpaque;
        else if(style && [style isEqualToString:@"Black"])
            navBar.barStyle = UIBarStyleBlack;
        // else the default will be used

        [navBarController setDelegate:self];

        [[navBarController view] setFrame:CGRectMake(0, 0, originalWebViewBounds.size.width, navBarHeight)];
        [[[self webView] superview] addSubview:[navBarController view]];
        [navBar setHidden:YES];
    }
}

+ (UIBarButtonSystemItem)getUIBarButtonSystemItemForString:(NSString*)imageName
{
    UIBarButtonSystemItem systemItem = -1;

    if([imageName isEqualToString:@"barButton:Action"])        systemItem = UIBarButtonSystemItemAction;
    else if([imageName isEqualToString:@"barButton:Add"])           systemItem = UIBarButtonSystemItemAdd;
    else if([imageName isEqualToString:@"barButton:Bookmarks"])     systemItem = UIBarButtonSystemItemBookmarks;
    else if([imageName isEqualToString:@"barButton:Camera"])        systemItem = UIBarButtonSystemItemCamera;
    else if([imageName isEqualToString:@"barButton:Cancel"])        systemItem = UIBarButtonSystemItemCancel;
    else if([imageName isEqualToString:@"barButton:Compose"])       systemItem = UIBarButtonSystemItemCompose;
    else if([imageName isEqualToString:@"barButton:Done"])          systemItem = UIBarButtonSystemItemDone;
    else if([imageName isEqualToString:@"barButton:Edit"])          systemItem = UIBarButtonSystemItemEdit;
    else if([imageName isEqualToString:@"barButton:FastForward"])   systemItem = UIBarButtonSystemItemFastForward;
    else if([imageName isEqualToString:@"barButton:FixedSpace"])    systemItem = UIBarButtonSystemItemFixedSpace;
    else if([imageName isEqualToString:@"barButton:FlexibleSpace"]) systemItem = UIBarButtonSystemItemFlexibleSpace;
    else if([imageName isEqualToString:@"barButton:Organize"])      systemItem = UIBarButtonSystemItemOrganize;
    else if([imageName isEqualToString:@"barButton:PageCurl"])      systemItem = UIBarButtonSystemItemPageCurl;
    else if([imageName isEqualToString:@"barButton:Pause"])         systemItem = UIBarButtonSystemItemPause;
    else if([imageName isEqualToString:@"barButton:Play"])          systemItem = UIBarButtonSystemItemPlay;
    else if([imageName isEqualToString:@"barButton:Redo"])          systemItem = UIBarButtonSystemItemRedo;
    else if([imageName isEqualToString:@"barButton:Refresh"])       systemItem = UIBarButtonSystemItemRefresh;
    else if([imageName isEqualToString:@"barButton:Reply"])         systemItem = UIBarButtonSystemItemReply;
    else if([imageName isEqualToString:@"barButton:Rewind"])        systemItem = UIBarButtonSystemItemRewind;
    else if([imageName isEqualToString:@"barButton:Save"])          systemItem = UIBarButtonSystemItemSave;
    else if([imageName isEqualToString:@"barButton:Search"])        systemItem = UIBarButtonSystemItemSearch;
    else if([imageName isEqualToString:@"barButton:Stop"])          systemItem = UIBarButtonSystemItemStop;
    else if([imageName isEqualToString:@"barButton:Trash"])         systemItem = UIBarButtonSystemItemTrash;
    else if([imageName isEqualToString:@"barButton:Undo"])          systemItem = UIBarButtonSystemItemUndo;

    return systemItem;
}

- (void)setupLeftButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    NSString * title = [arguments objectAtIndex:0];
    NSString * imageName = [arguments objectAtIndex:1];

    if (title && [title length] > 0)
    {
        [[navBarController leftButton] setTitle:title];
        [[navBarController leftButton] setImage:nil];
    }
    else if (imageName && [imageName length] > 0)
    {
        UIBarButtonSystemItem systemItem = [NavigationBar getUIBarButtonSystemItemForString:imageName];

        if (systemItem != -1)
        {
            UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(leftButtonTapped)];
            navBarController.navItem.leftBarButtonItem = newButton;
            navBarController.leftButton = newButton;
            [newButton release];
            return;
        }
        else
            [[navBarController leftButton] setImage:[UIImage imageNamed:imageName]];

        [[navBarController leftButton] setTitle:nil];
    }
    else
    {
        [[navBarController leftButton] setImage:nil];
        [[navBarController leftButton] setTitle:nil];
    }
}

- (void)setupRightButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    NSString * title = [arguments objectAtIndex:0];
    NSString * imageName = [arguments objectAtIndex:1];

    if (title && [title length] > 0)
    {
        [[navBarController rightButton] setTitle:title];
        [[navBarController rightButton] setImage:nil];
    }
    else if (imageName && [imageName length] > 0)
    {
        UIBarButtonSystemItem systemItem = [NavigationBar getUIBarButtonSystemItemForString:imageName];

        if (systemItem != -1)
        {
            UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(rightButtonTapped)];
            navBarController.navItem.rightBarButtonItem = newButton;
            navBarController.rightButton = newButton;
            [newButton release];
            return;
        }
        else
            [[navBarController rightButton] setImage:[UIImage imageNamed:imageName]];

        [[navBarController rightButton] setTitle:nil];
    }
    else
    {
        [[navBarController rightButton] setImage:nil];
        [[navBarController rightButton] setTitle:nil];
    }
}

- (void)hideLeftButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    [[navBarController navItem] setLeftBarButtonItem:nil];
}

- (void)showLeftButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    [[navBarController navItem] setLeftBarButtonItem:[navBarController leftButton]];
}

- (void)hideRightButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    [[navBarController navItem] setRightBarButtonItem:nil];
}

- (void)showRightButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    [[navBarController navItem] setRightBarButtonItem:[navBarController rightButton]];
}

-(void) leftButtonTapped
{
    NSString * jsCallBack = @"window.plugins.navigationBar.leftButtonTapped();";
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

-(void) rightButtonTapped
{
    NSString * jsCallBack = @"window.plugins.navigationBar.rightButtonTapped();";
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

-(void) show:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    if (!navBar)
        [self create:nil withDict:nil];

    if ([navBar isHidden])
    {
        [navBar setHidden:NO];
        [self correctWebViewBounds];
    }
}


-(void) hide:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    if (navBar && ![navBar isHidden])
    {
        [navBar setHidden:YES];
        [self correctWebViewBounds];
    }

}

-(void) setTitle:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    if (navBar)
    {
        NSString  *name = [arguments objectAtIndex:0];
        [navBarController navItem].title = name;

        // Reset otherwise overriding logo reference
        [navBarController navItem].titleView = NULL;
    }
}

-(void) setLogo:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString * logoURL = [arguments objectAtIndex:0];
    UIImage * image = nil;

    if (logoURL && logoURL != @"")
    {
        if ([logoURL hasPrefix:@"http://"] || [logoURL hasPrefix:@"https://"])
        {
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoURL]];
            image = [UIImage imageWithData:data];
        }
        else
            image = [UIImage imageNamed:logoURL];

        if (image)
        {
            UIImageView * view = [[[UIImageView alloc] initWithImage:image] autorelease];
            [view setContentMode:UIViewContentModeScaleAspectFit];
            [view setBounds: CGRectMake(0, 0, 100, 30)];
            [[navBarController navItem] setTitleView:view];
        }
    }
}

@end
