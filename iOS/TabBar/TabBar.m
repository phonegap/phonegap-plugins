/*
 TabBar.m

 Created by Jesse MacFadyen on 10-02-03.
 MIT Licensed

 Originally this code was developed my Michael Nachbaur
 Formerly -> PhoneGap :: UIControls.h
 Created by Michael Nachbaur on 13/04/09.
 Copyright 2009 Decaf Ninja Software. All rights reserved.

 API cleaned up and improved by Andreas Sommer (https://github.com/AndiDog/phonegap-plugins).
 */

#import <objc/runtime.h>
#import "TabBar.h"
#import <UIKit/UINavigationBar.h>
#import <QuartzCore/QuartzCore.h>

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVDebug.h>
#else
#import "CDVDebug.h"
#endif

@implementation TabBar
#ifndef __IPHONE_3_0
@synthesize webView;
#endif

-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (TabBar*)[super initWithWebView:theWebView];
    if (self)
	{
        // The original web view bounds must be retrieved here. On iPhone, it would be 0,0,320,460 for example. Since
        // Cordova seems to initialize plugins on the first call, there is a plugin method init() that has to be called
        // in order to make Cordova call *this* method. If someone forgets the init() call and uses the navigation bar
        // and tab bar plugins together, these values won't be the original web view bounds and layout will be wrong.
        tabBarItems = [[NSMutableDictionary alloc] initWithCapacity:5];
		originalWebViewBounds = theWebView.bounds;
        tabBarHeight = 49.0f;
        navBarHeight = 44.0f;
        tabBarAtBottom = true;
    }
    return self;
}

- (void)dealloc
{
    if (tabBar)
        [tabBar release];

    [super dealloc];
}

-(void)correctWebViewBounds
{
    if(!tabBar)
        return;

    const bool tabBarShown = !tabBar.hidden;
    bool navBarShown = false;

    UIView *parent = [tabBar superview];
    for(UIView *view in parent.subviews)
        if([view isMemberOfClass:[UINavigationBar class]])
        {
            navBarShown = !view.hidden;
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

    // NOTE: Following part again for tab bar plugin only

    if(tabBarShown)
    {
        if(tabBarAtBottom)
            [tabBar setFrame:CGRectMake(left, bottom, right - left, tabBarHeight)];
        else
            [tabBar setFrame:CGRectMake(left, originalWebViewBounds.origin.y, right - left, tabBarHeight)];
    }
}

/**
 * Create a native tab bar at either the top or the bottom of the display.
 * @brief creates a tab bar
 * @param arguments unused
 * @param options unused
 */
- (void)create:(NSArray*)arguments withDict:(NSDictionary*)options
{
    tabBar = [UITabBar new];
    [tabBar sizeToFit];
    tabBar.delegate = self;
    tabBar.multipleTouchEnabled   = NO;
    tabBar.autoresizesSubviews    = YES;
    tabBar.hidden                 = YES;
    tabBar.userInteractionEnabled = YES;
	tabBar.opaque = YES;

	self.webView.superview.autoresizesSubviews = YES;

	[ self.webView.superview addSubview:tabBar];
}

-(void) init:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    // Dummy function, see initWithWebView
}

/**
 * Show the tab bar after its been created.
 * @brief show the tab bar
 * @param arguments unused
 * @param options used to indicate options for where and how the tab bar should be placed
 * - \c height integer indicating the height of the tab bar (default: \c 49)
 * - \c position specifies whether the tab bar will be placed at the \c top or \c bottom of the screen (default: \c bottom)
 */
- (void)show:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self create:nil withDict:nil];

	// if we are calling this again when its shown, reset
	if (!tabBar.hidden)
		return;

    //	CGRect offsetRect = [ [UIApplication sharedApplication] statusBarFrame];

    if(options)
	{
        tabBarHeight = [[options objectForKey:@"height"] floatValue];
        tabBarAtBottom = [[options objectForKey:@"position"] isEqualToString:@"bottom"];
    }

    tabBar.tabBarAtBottom = tabBarAtBottom;

	if(tabBarHeight == 0)
        tabBarHeight = 49.0f;

    tabBar.hidden = NO;

    [self correctWebViewBounds];
}

/**
 * Resize the tab bar (this should be called on orientation change)
 * @brief resize the tab bar on rotation
 * @param arguments unused
 * @param options unused
 */
- (void)resize:(NSArray*)arguments withDict:(NSDictionary*)options
{
    [self correctWebViewBounds];
}

/**
 * Hide the tab bar
 * @brief hide the tab bar
 * @param arguments unused
 * @param options unused
 */
- (void)hide:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self create:nil withDict:nil];

    tabBar.hidden = YES;

    [self correctWebViewBounds];
}

/**
 * Create a new tab bar item for use on a previously created tab bar.  Use ::showTabBarItems to show the new item on the tab bar.
 *
 * If the supplied image name is one of the labels listed below, then this method will construct a tab button
 * using the standard system buttons.  Note that if you use one of the system images, that the \c title you supply will be ignored.
 * - <b>Tab Buttons</b>
 *   - tabButton:More
 *   - tabButton:Favorites
 *   - tabButton:Featured
 *   - tabButton:TopRated
 *   - tabButton:Recents
 *   - tabButton:Contacts
 *   - tabButton:History
 *   - tabButton:Bookmarks
 *   - tabButton:Search
 *   - tabButton:Downloads
 *   - tabButton:MostRecent
 *   - tabButton:MostViewed
 * @brief create a tab bar item
 * @param arguments Parameters used to create the tab bar
 *  -# \c name internal name to refer to this tab by
 *  -# \c title title text to show on the tab, or null if no text should be shown
 *  -# \c image image filename or internal identifier to show, or null if now image should be shown
 *  -# \c tag unique number to be used as an internal reference to this button
 * @param options Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if nil or unspecified, the badge will be hidden
 */
- (void)createItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self create:nil withDict:nil];

    NSString  *name      = [arguments objectAtIndex:0];
    NSString  *title     = [arguments objectAtIndex:1];
    NSString  *imageName = [arguments objectAtIndex:2];
    int tag              = [[arguments objectAtIndex:3] intValue];

    UITabBarItem *item = nil;
    if ([imageName length] > 0)
    {
        UITabBarSystemItem systemItem = -1;
             if ([imageName isEqualToString:@"tabButton:More"])       systemItem = UITabBarSystemItemMore;
        else if ([imageName isEqualToString:@"tabButton:Favorites"])  systemItem = UITabBarSystemItemFavorites;
        else if ([imageName isEqualToString:@"tabButton:Featured"])   systemItem = UITabBarSystemItemFeatured;
        else if ([imageName isEqualToString:@"tabButton:TopRated"])   systemItem = UITabBarSystemItemTopRated;
        else if ([imageName isEqualToString:@"tabButton:Recents"])    systemItem = UITabBarSystemItemRecents;
        else if ([imageName isEqualToString:@"tabButton:Contacts"])   systemItem = UITabBarSystemItemContacts;
        else if ([imageName isEqualToString:@"tabButton:History"])    systemItem = UITabBarSystemItemHistory;
        else if ([imageName isEqualToString:@"tabButton:Bookmarks"])  systemItem = UITabBarSystemItemBookmarks;
        else if ([imageName isEqualToString:@"tabButton:Search"])     systemItem = UITabBarSystemItemSearch;
        else if ([imageName isEqualToString:@"tabButton:Downloads"])  systemItem = UITabBarSystemItemDownloads;
        else if ([imageName isEqualToString:@"tabButton:MostRecent"]) systemItem = UITabBarSystemItemMostRecent;
        else if ([imageName isEqualToString:@"tabButton:MostViewed"]) systemItem = UITabBarSystemItemMostViewed;
        if (systemItem != -1)
            item = [[UITabBarItem alloc] initWithTabBarSystemItem:systemItem tag:tag];
    }

    if (item == nil)
        item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageName] tag:tag];

    if ([options objectForKey:@"badge"])
        item.badgeValue = [options objectForKey:@"badge"];

    [tabBarItems setObject:item forKey:name];
	[item release];
}


/**
 * Update an existing tab bar item to change its badge value.
 * @brief update the badge value on an existing tab bar item
 * @param arguments Parameters used to identify the tab bar item to update
 *  -# \c name internal name used to represent this item when it was created
 * @param options Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if nil or unspecified, the badge will be hidden
 */
- (void)updateItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self create:nil withDict:nil];

    NSString  *name = [arguments objectAtIndex:0];
    UITabBarItem *item = [tabBarItems objectForKey:name];
    if (item)
        item.badgeValue = [options objectForKey:@"badge"];
}


/**
 * Show previously created items on the tab bar
 * @brief show a list of tab bar items
 * @param arguments the item names to be shown
 * @param options dictionary of options, notable options including:
 *  - \c animate indicates that the items should animate onto the tab bar
 * @see createItem
 * @see create
 */
- (void)showItems:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self create:nil withDict:nil];

    int i, count = [arguments count];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:count];
    for (i = 0; i < count; i++) {
        NSString *itemName = [arguments objectAtIndex:i];
        UITabBarItem *item = [tabBarItems objectForKey:itemName];
        if (item)
            [items addObject:item];
    }

    BOOL animateItems = NO;
    if ([options objectForKey:@"animate"])
        animateItems = [(NSString*)[options objectForKey:@"animate"] boolValue];
    [tabBar setItems:items animated:animateItems];
	[items release];
}

/**
 * Manually select an individual tab bar item, or nil for deselecting a currently selected tab bar item.
 * @brief manually select a tab bar item
 * @param arguments the name of the tab bar item to select
 * @see createItem
 * @see showItems
 */
- (void)selectItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self create:nil withDict:nil];

    NSString *itemName = [arguments objectAtIndex:0];
    UITabBarItem *item = [tabBarItems objectForKey:itemName];
    if (item)
        tabBar.selectedItem = item;
    else
        tabBar.selectedItem = nil;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.tabBar.onItemSelected(%d);", item.tag];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

@end


@implementation UIView (NavBarCompat)

- (void)setTabBarAtBottom:(bool)tabBarAtBottom
{
	objc_setAssociatedObject(self, @"NavBarCompat_tabBarAtBottom", [NSNumber numberWithBool:tabBarAtBottom], OBJC_ASSOCIATION_COPY);
}

- (bool)tabBarAtBottom
{
	return [(objc_getAssociatedObject(self, @"NavBarCompat_tabBarAtBottom")) boolValue];
}

@end
