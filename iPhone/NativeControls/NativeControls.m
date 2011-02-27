//
//  NativeControls.h
//  
//
//  Created by Jesse MacFadyen on 10-02-03.
//  MIT Licensed

//  Originally this code was developed my Michael Nachbaur
//  Formerly -> PhoneGap :: UIControls.h
//  Created by Michael Nachbaur on 13/04/09.
//  Copyright 2009 Decaf Ninja Software. All rights reserved.

#import "NativeControls.h"

#import <QuartzCore/QuartzCore.h>

@implementation NativeControls
#ifndef __IPHONE_3_0
@synthesize webView;
#endif

-(PhoneGapCommand*) initWithWebView:(UIWebView*)theWebView
{
    self = (NativeControls*)[super initWithWebView:theWebView];
    if (self) 
	{
        tabBarItems = [[NSMutableDictionary alloc] initWithCapacity:5];
		originalWebViewBounds = theWebView.bounds;
    }
    return self;
}

- (void)dealloc
{
    if (tabBar)
        [tabBar release];
    [super dealloc];
}

#pragma mark -
#pragma mark TabBar

/**
 * Create a native tab bar at either the top or the bottom of the display.
 * @brief creates a tab bar
 * @param arguments unused
 * @param options unused
 */
- (void)createTabBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    tabBar = [UITabBar new];
    [tabBar sizeToFit];
    tabBar.delegate = self;
    tabBar.multipleTouchEnabled   = NO;
    tabBar.autoresizesSubviews    = YES;
    tabBar.hidden                 = YES;
    tabBar.userInteractionEnabled = YES;
	tabBar.opaque = YES;
	
	webView.superview.autoresizesSubviews = YES;
	
	[ webView.superview addSubview:tabBar];    
}

/**
 * Show the tab bar after its been created.
 * @brief show the tab bar
 * @param arguments unused
 * @param options used to indicate options for where and how the tab bar should be placed
 * - \c height integer indicating the height of the tab bar (default: \c 49)
 * - \c position specifies whether the tab bar will be placed at the \c top or \c bottom of the screen (default: \c bottom)
 */
- (void)showTabBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];
	
	// if we are calling this again when its shown, reset
	if (!tabBar.hidden) {
		return;
	}

    CGFloat height = 0.0f;
    BOOL atBottom = YES;
	
	CGRect offsetRect = [ [UIApplication sharedApplication] statusBarFrame];
    
    if (options) 
	{
        height   = [[options objectForKey:@"height"] floatValue];
        atBottom = [[options objectForKey:@"position"] isEqualToString:@"bottom"];
    }
	if(height == 0)
	{
		height = 49.0f;
	}
	
    tabBar.hidden = NO;
     CGRect webViewBounds = originalWebViewBounds;
     CGRect tabBarBounds;
	
	NSNotification* notif = [NSNotification notificationWithName:@"PGLayoutSubviewAdded" object:tabBar];
	[[NSNotificationQueue defaultQueue] enqueueNotification:notif postingStyle: NSPostASAP];
	
     if (atBottom) 
	 {
         tabBarBounds = CGRectMake(
             webViewBounds.origin.x,
             webViewBounds.origin.y + webViewBounds.size.height - height, // - offsetRect.size.height,
             webViewBounds.size.width,
             height
         );
         webViewBounds = CGRectMake(
            webViewBounds.origin.x,
            webViewBounds.origin.y,
            webViewBounds.size.width,
            webViewBounds.size.height - height // - offsetRect.size.height
         );
     } 
	 else 
	 {
         tabBarBounds = CGRectMake(
             webViewBounds.origin.x,
             webViewBounds.origin.y,
             webViewBounds.size.width,
             height
         );
         webViewBounds = CGRectMake(
            webViewBounds.origin.x,
            webViewBounds.origin.y + height,
            webViewBounds.size.width,
            webViewBounds.size.height - height
         );
     }
     
    [tabBar setFrame:tabBarBounds];
	
	
    [webView setFrame:webViewBounds];
}

/**
 * Hide the tab bar
 * @brief hide the tab bar
 * @param arguments unused
 * @param options unused
 */
- (void)hideTabBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];
    tabBar.hidden = YES;
	
	NSNotification* notif = [NSNotification notificationWithName:@"PGLayoutSubviewRemoved" object:tabBar];
	[[NSNotificationQueue defaultQueue] enqueueNotification:notif postingStyle: NSPostASAP];
	
	
	[webView setFrame:originalWebViewBounds];
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
- (void)createTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];

    NSString  *name      = [arguments objectAtIndex:0];
    NSString  *title     = [arguments objectAtIndex:1];
    NSString  *imageName = [arguments objectAtIndex:2];
    int tag              = [[arguments objectAtIndex:3] intValue];

    UITabBarItem *item = nil;    
    if ([imageName length] > 0) {
        UIBarButtonSystemItem systemItem = -1;
        if ([imageName isEqualToString:@"tabButton:More"])       systemItem = UITabBarSystemItemMore;
        if ([imageName isEqualToString:@"tabButton:Favorites"])  systemItem = UITabBarSystemItemFavorites;
        if ([imageName isEqualToString:@"tabButton:Featured"])   systemItem = UITabBarSystemItemFeatured;
        if ([imageName isEqualToString:@"tabButton:TopRated"])   systemItem = UITabBarSystemItemTopRated;
        if ([imageName isEqualToString:@"tabButton:Recents"])    systemItem = UITabBarSystemItemRecents;
        if ([imageName isEqualToString:@"tabButton:Contacts"])   systemItem = UITabBarSystemItemContacts;
        if ([imageName isEqualToString:@"tabButton:History"])    systemItem = UITabBarSystemItemHistory;
        if ([imageName isEqualToString:@"tabButton:Bookmarks"])  systemItem = UITabBarSystemItemBookmarks;
        if ([imageName isEqualToString:@"tabButton:Search"])     systemItem = UITabBarSystemItemSearch;
        if ([imageName isEqualToString:@"tabButton:Downloads"])  systemItem = UITabBarSystemItemDownloads;
        if ([imageName isEqualToString:@"tabButton:MostRecent"]) systemItem = UITabBarSystemItemMostRecent;
        if ([imageName isEqualToString:@"tabButton:MostViewed"]) systemItem = UITabBarSystemItemMostViewed;
        if (systemItem != -1)
            item = [[UITabBarItem alloc] initWithTabBarSystemItem:systemItem tag:tag];
    }
    
    if (item == nil) {
        NSLog(@"Creating with custom image and title");
        item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageName] tag:tag];
    }

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
- (void)updateTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];

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
 * @see createTabBarItem
 * @see createTabBar
 */
- (void)showTabBarItems:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];
    
    int i, count = [arguments count];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:count];
    for (i = 0; i < count; i++) {
        NSString *itemName = [arguments objectAtIndex:i];
        UITabBarItem *item = [tabBarItems objectForKey:itemName];
        if (item)
            [items addObject:item];
    }
    
    BOOL animateItems = YES;
    if ([options objectForKey:@"animate"])
        animateItems = [(NSString*)[options objectForKey:@"animate"] boolValue];
    [tabBar setItems:items animated:animateItems];
	[items release];
}

/**
 * Manually select an individual tab bar item, or nil for deselecting a currently selected tab bar item.
 * @brief manually select a tab bar item
 * @param arguments the name of the tab bar item to select
 * @see createTabBarItem
 * @see showTabBarItems
 */
- (void)selectTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];

    NSString *itemName = [arguments objectAtIndex:0];
    UITabBarItem *item = [tabBarItems objectForKey:itemName];
    if (item)
        tabBar.selectedItem = item;
    else
        tabBar.selectedItem = nil;
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.nativeControls.tabBarItemSelected(%d);", item.tag];    
    [webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

#pragma mark -
#pragma mark ToolBar


/*********************************************************************************/
- (void)createToolBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    CGFloat height   = 45.0f;
    BOOL atTop       = YES;
    UIBarStyle style = UIBarStyleBlackOpaque;

    NSDictionary* toolBarSettings = options;//[settings objectForKey:@"ToolBarSettings"];
    if (toolBarSettings) 
	{
        if ([toolBarSettings objectForKey:@"height"])
            height = [[toolBarSettings objectForKey:@"height"] floatValue];
		
        if ([toolBarSettings objectForKey:@"position"])
            atTop  = [[toolBarSettings objectForKey:@"position"] isEqualToString:@"top"];
        
#pragma unused(atTop)
		
        NSString *styleStr = [toolBarSettings objectForKey:@"style"];
        if ([styleStr isEqualToString:@"Default"])
            style = UIBarStyleDefault;
        else if ([styleStr isEqualToString:@"BlackOpaque"])
            style = UIBarStyleBlackOpaque;
        else if ([styleStr isEqualToString:@"BlackTranslucent"])
            style = UIBarStyleBlackTranslucent;
    }

    CGRect webViewBounds = webView.bounds;
    CGRect toolBarBounds = CGRectMake(
                              webViewBounds.origin.x,
                              webViewBounds.origin.y,
                              webViewBounds.size.width,
                              height
                              );
    webViewBounds = CGRectMake(
                               webViewBounds.origin.x,
                               webViewBounds.origin.y + height,
                               webViewBounds.size.width,
                               webViewBounds.size.height - height
                               );
    toolBar = [[UIToolbar alloc] initWithFrame:toolBarBounds];
    [toolBar sizeToFit];
    toolBar.hidden                 = NO;
    toolBar.multipleTouchEnabled   = NO;
    toolBar.autoresizesSubviews    = YES;
    toolBar.userInteractionEnabled = YES;
    toolBar.barStyle               = style;
	

    [toolBar setFrame:toolBarBounds];
    [webView setFrame:webViewBounds];

    [self.webView.superview addSubview:toolBar];
}




- (void)setToolBarTitle:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!toolBar)
        [self createToolBar:nil withDict:nil];

    NSString *title = [arguments objectAtIndex:0];
    if (!toolBarTitle) {
        toolBarTitle = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(toolBarTitleClicked)];
    } else {
        //toolBarTitle.title = title;
    }
		
	//UINavigationBar
	
	//initWithImage
	UIImage* logoImage = [UIImage imageNamed:@"www/ui/tabHeader.png"];
	
	
	
	/*UIImageView* logo = [[ UIImageView alloc ] initWithImage: logoImage ];
	logo.userInteractionEnabled = YES;*/
	
	
	UIButton* logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[ logoBtn setBackgroundImage:logoImage forState:UIControlStateNormal];
	[ logoBtn addTarget:self action:@selector(toolBarTitleClicked) forControlEvents:UIControlEventTouchUpInside];
	 
	UIBarButtonItem *modalBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoBtn];
	
	UIImageView* backImage = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"www/ui/but-back.png"]];
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(toolBarTitleClicked)];
	[ backButtonItem setCustomView:backImage];
	// backButtonItem.target = self;
	// backButtonItem.action = @selector(toolBarTitleClicked);
	
	/*[ backButtonItem addTarget:self action:@selector(toolBarTitleClicked) forControlEvents:UIControlEventTouchUpInside];*/
	 
	
	
	
	//UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:  style:UIBarButtonItemStylePlain target:self action:@selector(toolBarTitleClicked)];

    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:nil];
	//refresh.target = self;
	//refresh.action = @selector(toolBarTitleClicked);
	
	//refresh.customView = backImage;
	

    NSArray *items = [[NSArray alloc] initWithObjects:backButtonItem,space1,toolBarTitle,modalBarButtonItem,space2, refresh, nil];

	
	//UINavigationItem* navItem = [[UINavigationItem alloc] init];
	//navItem.titleView = logo;
	
    [toolBar setItems:items animated:YES];
	

	
	modalBarButtonItem.target = self;
	modalBarButtonItem.action = @selector(toolBarTitleClicked);
	[modalBarButtonItem release];
	
	

	[backButtonItem release];
	[space1 release];
	[space2 release];
	[ refresh release ];
	[ backImage release ];
	
	
	//[ toolBar pushNavigationItem:navItem animated:YES];
	
	[items release];
}

- (void)toolBarTitleClicked
{
    NSLog(@"Toolbar clicked");
}

#pragma mark -
#pragma mark ActionSheet

- (void)createActionSheet:(NSArray*)arguments withDict:(NSDictionary*)options
{
    
	NSString* title = [options objectForKey:@"title"];

	
	UIActionSheet* actionSheet = [ [UIActionSheet alloc ] 
						 initWithTitle:title 
						 delegate:self 
						 cancelButtonTitle:nil 
						 destructiveButtonTitle:nil
						 otherButtonTitles:nil
						 ];
	
	int count = [arguments count];
	for(int n = 0; n < count; n++)
	{
		[ actionSheet addButtonWithTitle:[arguments objectAtIndex:n]];
	}
	
	if([options objectForKey:@"cancelButtonIndex"])
	{
		actionSheet.cancelButtonIndex = [[options objectForKey:@"cancelButtonIndex"] intValue];
	}
	if([options objectForKey:@"destructiveButtonIndex"])
	{
		actionSheet.destructiveButtonIndex = [[options objectForKey:@"destructiveButtonIndex"] intValue];
	}
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;//UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:webView.superview];
    [actionSheet release];
	
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.nativeControls._onActionSheetDismissed(%d);", buttonIndex];    
    [webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}


@end
