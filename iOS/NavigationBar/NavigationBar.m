/*
 NavigationBar.m

 Work based on the NativeControls plugin (Jesse MacFadyen, MIT licensed) and additions made by Hiedi Utley
 (https://github.com/hutley/HelloPhoneGap1.0/) and zSprawl (https://github.com/zSprawl/NativeControls/).

 Navigation bar API cleaned, improved and moved in a separate plugin by Andreas Sommer
 (AndiDog, https://github.com/AndiDog/phonegap-plugins).
 */

#import "NavigationBar.h"
#import <UIKit/UITabBar.h>
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
    if(self)
    {
        // The original web view bounds must be retrieved here. On iPhone, it would be 0,0,320,460 for example. Since
        // Cordova seems to initialize plugins on the first call, there is a plugin method init() that has to be called
        // in order to make Cordova call *this* method. If someone forgets the init() call and uses the navigation bar
        // and tab bar plugins together, these values won't be the original web view bounds and layout will be wrong.
        originalWebViewBounds = theWebView.bounds;
        navBarHeight = 44.0f;
        tabBarHeight = 49.0f;
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

-(UIBarButtonItem*)backgroundButtonFromImage:(NSString*)imageName title:(NSString*)title fixedMarginLeft:(float)fixedMarginLeft fixedMarginRight:(float)fixedMarginRight target:(id)target action:(SEL)action
{
    UIButton *backButton = [[UIButton alloc] init];
    UIImage *imgNormal = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, fixedMarginLeft, 0, fixedMarginRight)];

    [backButton setBackgroundImage:imgNormal forState:UIControlStateNormal];

    backButton.titleLabel.textColor = [UIColor whiteColor];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    backButton.titleLabel.textAlignment = UITextAlignmentCenter;

    CGSize textSize = [title sizeWithFont:backButton.titleLabel.font];

    float buttonWidth = MAX(imgNormal.size.width, textSize.width + fixedMarginLeft + fixedMarginRight);//imgNormal.size.width > (textSize.width + fixedMarginLeft + fixedMarginRight)
                        //? imgNormal.size.width : (textSize.width + fixedMarginLeft + fixedMarginRight);
    backButton.frame = CGRectMake(0, 0, buttonWidth, imgNormal.size.height);

    CGFloat marginTopBottom = (backButton.frame.size.height - textSize.height) / 2;
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(marginTopBottom, fixedMarginLeft, marginTopBottom, fixedMarginRight)];

    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];

    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    [backButton release];
    [imgNormal release];

    return backButtonItem;
}

-(void)correctWebViewBounds
{
    if(!navBar)
        return;

    const bool navBarShown = !navBar.hidden;
    bool tabBarShown = false;
    bool tabBarAtBottom = true;

    UIView *parent = [navBar superview];
    for(UIView *view in parent.subviews)
        if([view isMemberOfClass:[UITabBar class]])
        {
            tabBarShown = !view.hidden;

            // Tab bar height is customizable
            if(tabBarShown)
            {
                tabBarHeight = view.bounds.size.height;

                // Since the navigation bar plugin plays together with the tab bar plugin, and the tab bar can as well
                // be positioned at the top, here's some magic to find out where it's positioned:
                tabBarAtBottom = true;
                if([view respondsToSelector:@selector(tabBarAtBottom)])
                    tabBarAtBottom = [view performSelector:@selector(tabBarAtBottom)];
            }

            break;
        }

    // IMPORTANT: Below code is the same in both the navigation and tab bar plugins!

    CGFloat left = originalWebViewBounds.origin.x;
    CGFloat right = left + originalWebViewBounds.size.width;
    CGFloat top = originalWebViewBounds.origin.y;
    CGFloat bottom = top + originalWebViewBounds.size.height;

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            // No need to change width/height from original bounds
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            right = left + originalWebViewBounds.size.height + 20.0f;
            bottom = top + originalWebViewBounds.size.width - 20.0f;
            break;
        default:
            NSLog(@"Unknown orientation: %d", orientation);
            break;
    }

    if(navBarShown)
        top += navBarHeight;

    if(tabBarShown)
    {
        if(tabBarAtBottom)
            bottom -= tabBarHeight;
        else
            top += tabBarHeight;
    }

    CGRect webViewBounds = CGRectMake(left, top, right - left, bottom - top);

    [self.webView setFrame:webViewBounds];

    // NOTE: Following part again for navigation bar plugin only

    if(navBarShown)
    {
        if(tabBarAtBottom)
            [navBar setFrame:CGRectMake(left, originalWebViewBounds.origin.y, right - left, navBarHeight)];
        else
            [navBar setFrame:CGRectMake(left, originalWebViewBounds.origin.y + tabBarHeight, right - left, navBarHeight)];
    }
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

-(void) init:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    // Dummy function, see initWithWebView
}

- (void)setupLeftButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    NSString * title = [arguments objectAtIndex:0];
    NSString * imageName = [arguments objectAtIndex:1];
    NSNumber *useImageAsBackgroundOpt = [options objectForKey:@"useImageAsBackground"];
    float fixedMarginLeft = [[options objectForKey:@"fixedMarginLeft"] floatValue] ?: 13;
    float fixedMarginRight = [[options objectForKey:@"fixedMarginRight"] floatValue] ?: 13;
    bool useImageAsBackground = useImageAsBackgroundOpt ? [useImageAsBackgroundOpt boolValue] : false;

    if((title && [title length] > 0) || useImageAsBackground)
    {
        if(useImageAsBackground && imageName && [imageName length] > 0)
        {
            UIBarButtonItem *newButton = [self backgroundButtonFromImage:imageName title:title
                                               fixedMarginLeft:fixedMarginLeft fixedMarginRight:fixedMarginRight
                                               target:self action:@selector(leftButtonTapped)];
            navBarController.navItem.leftBarButtonItem = newButton;
            navBarController.leftButton = newButton;
            [newButton release];
        }
        else
        {
            [[navBarController leftButton] setTitle:title];
            [[navBarController leftButton] setImage:nil];
        }
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
        {
            [navBarController.leftButton setImage:[UIImage imageNamed:imageName]];
            [navBarController.leftButton setTitle:nil];
        }
    }
    else
    {
        [navBarController.leftButton setImage:nil];
        [navBarController.leftButton setTitle:nil];
    }
}

- (void)setupRightButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    NSString * title = [arguments objectAtIndex:0];
    NSString * imageName = [arguments objectAtIndex:1];
    NSNumber *useImageAsBackgroundOpt = [options objectForKey:@"useImageAsBackground"];
    float fixedMarginLeft = [[options objectForKey:@"fixedMarginLeft"] floatValue] ?: 13;
    float fixedMarginRight = [[options objectForKey:@"fixedMarginRight"] floatValue] ?: 13;
    bool useImageAsBackground = useImageAsBackgroundOpt ? [useImageAsBackgroundOpt boolValue] : false;

    if((title && [title length] > 0) || useImageAsBackground)
    {
        if(useImageAsBackground && imageName && [imageName length] > 0)
        {
            UIBarButtonItem *newButton = [self backgroundButtonFromImage:imageName title:title
                                               fixedMarginLeft:fixedMarginLeft fixedMarginRight:fixedMarginRight
                                               target:self action:@selector(rightButtonTapped)];
            navBarController.navItem.rightBarButtonItem = newButton;
            navBarController.rightButton = newButton;
            [newButton release];
        }
        else
        {
            [[navBarController rightButton] setTitle:title];
            [[navBarController rightButton] setImage:nil];
        }
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

/**
 * Resize the navigation bar (this should be called on orientation change)
 * This is important in playing together with the tab bar plugin, especially because the tab bar can be placed on top
 * or at the bottom, so the navigation bar bounds also need to be changed.
 *
 * @param arguments unused
 * @param options unused
 */
- (void)resize:(NSArray*)arguments withDict:(NSDictionary*)options
{
    [self correctWebViewBounds];
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
