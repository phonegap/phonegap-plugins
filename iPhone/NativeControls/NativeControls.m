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

-(PGPlugin*) initWithWebView:(UIWebView*)theWebView
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
	
	if (toolBar)
	{
		[toolBarTitle release];
		[toolBarItems release];
		[toolBar release];
	}
	
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
	
	self.webView.superview.autoresizesSubviews = YES;
	
	[ self.webView.superview addSubview:tabBar];    
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
	
    //	CGRect offsetRect = [ [UIApplication sharedApplication] statusBarFrame];
    
    if (options) 
	{
        height   = [[options objectForKey:@"height"] floatValue];
        atBottom = [[options objectForKey:@"position"] isEqualToString:@"bottom"];
    }
	if(height == 0)
	{
		height = 49.0f;
		atBottom = YES;
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
                                  webViewBounds.origin.y + webViewBounds.size.height - height,
                                  webViewBounds.size.width,
                                  height
                                  );
        webViewBounds = CGRectMake(
                                   webViewBounds.origin.x,
                                   webViewBounds.origin.y,
                                   webViewBounds.size.width,
                                   webViewBounds.size.height - height
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
	
	
    [self.webView setFrame:webViewBounds];
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
	
	
	[self.webView setFrame:originalWebViewBounds];
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
        item.badgeValue = [options objectForKey:@"bad   ge"];
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
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
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
    
    CGRect webViewBounds = self.webView.bounds;
    CGRect toolBarBounds = CGRectMake(
                                      webViewBounds.origin.x,
                                      webViewBounds.origin.y - 1.0f,
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
    [self.webView setFrame:webViewBounds];
    
    [self.webView.superview addSubview:toolBar];
}

- (void)resetToolBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
	NSLog(@"about to reset toolBarItems");
	toolBarItems = nil;
	/*
     if (toolBarItems)
     {
     [toolBarItems release];
     }
	 */
}

/**
 * Hide the tool bar
 * @brief hide the tool bar
 * @param arguments unused
 * @param options unused
 */
- (void)hideToolBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!toolBar)
        [self createToolBar:nil withDict:nil];
    toolBar.hidden = YES;
	
	NSNotification* notif = [NSNotification notificationWithName:@"PGLayoutSubviewRemoved" object:toolBar];
	[[NSNotificationQueue defaultQueue] enqueueNotification:notif postingStyle: NSPostASAP];
	
	
	[self.webView setFrame:originalWebViewBounds];
}


- (void)setToolBarTitle:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!toolBar)
        [self createToolBar:nil withDict:nil];
    
    NSString *title = [arguments objectAtIndex:0];
    
       
    if (!toolBarTitle) {
         NSLog(@"not : %@", title);
        toolBarTitle = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(toolBarTitleClicked)];
    } else {
         NSLog(@"is: %@", title);
        toolBarTitle.title = title;
    }
}

/**
 * Create a new tool bar button item for use on a previously created tool bar.  Use ::showToolBar to show the new item on the tool bar.
 *
 * If the supplied image name is one of the labels listed below, then this method will construct a button
 * using the standard system buttons.  Note that if you use one of the system images, that the title you supply will be ignored.
 *
 * <b>Tool Bar Buttons</b>
 * UIBarButtonSystemItemDone
 * UIBarButtonSystemItemCancel
 * UIBarButtonSystemItemEdit
 * UIBarButtonSystemItemSave
 * UIBarButtonSystemItemAdd
 * UIBarButtonSystemItemFlexibleSpace
 * UIBarButtonSystemItemFixedSpace
 * UIBarButtonSystemItemCompose
 * UIBarButtonSystemItemReply
 * UIBarButtonSystemItemAction
 * UIBarButtonSystemItemOrganize
 * UIBarButtonSystemItemBookmarks
 * UIBarButtonSystemItemSearch
 * UIBarButtonSystemItemRefresh
 * UIBarButtonSystemItemStop
 * UIBarButtonSystemItemCamera
 * UIBarButtonSystemItemTrash
 * UIBarButtonSystemItemPlay
 * UIBarButtonSystemItemPause
 * UIBarButtonSystemItemRewind
 * UIBarButtonSystemItemFastForward
 * UIBarButtonSystemItemUndo,        // iOS 3.0 and later
 * UIBarButtonSystemItemRedo,        // iOS 3.0 and later
 * UIBarButtonSystemItemPageCurl,    // iOS 4.0 and later 
 * @param {String} name internal name to refer to this tab by
 * @param {String} [title] title text to show on the button, or null if no text should be shown
 * @param {String} [image] image filename or internal identifier to show, or null if now image should be shown
 * @param {Object} [options] Options for customizing the individual tab item [no option available at this time - this is for future proofing]
 *  
 */
- (void)createToolBarItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!toolBar)
	{
        [self createToolBar:nil withDict:nil];
	}
	
	if (!toolBarItems)
	{
		toolBarItems = [[NSMutableArray alloc] initWithCapacity:1];
	}
    
    NSString  *tagId      = [arguments objectAtIndex:0];
    NSString  *title     = [arguments objectAtIndex:1];
	NSString  *imageName;
	if (arguments.count >= 2)
	{
		imageName = [arguments objectAtIndex:2];
	}
	
	NSString  *style;
	
	if (arguments.count >= 4)
	{
		style	 = [arguments objectAtIndex:3];
	}
	else 
	{
		style = @"UIBarButtonItemStylePlain";
	}
    
	
	UIBarButtonItemStyle useStyle;
	
	if ([style isEqualToString:@"UIBarButtonItemStyleBordered"])
	{
		useStyle = UIBarButtonItemStyleBordered;
	}
	else if ([style isEqualToString:@"UIBarButtonItemStyleDone"])
	{
		useStyle = UIBarButtonItemStyleDone;
	}
	else 
	{
		useStyle = UIBarButtonItemStylePlain;
	}
    
    UIBarButtonItem *item = nil;    
    if ([imageName length] > 0) 
	{
        UIBarButtonSystemItem systemItem;
        if ([imageName isEqualToString:@"UIBarButtonSystemItemDone"])
		{
			systemItem = UIBarButtonSystemItemDone;
		}
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemCancel"])
		{
			systemItem = UIBarButtonSystemItemCancel;
		}
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemEdit"])
		{
			systemItem = UIBarButtonSystemItemEdit;
		}
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemSave"])
		{
			systemItem = UIBarButtonSystemItemSave;
		}
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemAdd"])
		{
			systemItem = UIBarButtonSystemItemAdd;
		}
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemFlexibleSpace"])
		{
			systemItem = UIBarButtonSystemItemFlexibleSpace;
		}
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemFixedSpace"])
		{
			systemItem = UIBarButtonSystemItemFixedSpace;
		}
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemCompose"])
		{
			systemItem = UIBarButtonSystemItemCompose;
		}
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemReply"])
		{
			systemItem = UIBarButtonSystemItemReply;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemAction"])
		{
			systemItem = UIBarButtonSystemItemAction;
		}
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemOrganize"])
		{
			systemItem = UIBarButtonSystemItemOrganize;
		}
        else if ([imageName isEqualToString:@"UIBarButtonSystemItemBookmarks"])
		{
			systemItem = UIBarButtonSystemItemBookmarks;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemSearch"])
		{
			systemItem = UIBarButtonSystemItemSearch;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemRefresh"])
		{
			systemItem = UIBarButtonSystemItemRefresh;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemStop"])
		{
			systemItem = UIBarButtonSystemItemStop;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemCamera"])
		{
			systemItem = UIBarButtonSystemItemCamera;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemTrash"])
		{
			systemItem = UIBarButtonSystemItemTrash;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemPlay"])
		{
			systemItem = UIBarButtonSystemItemPlay;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemPause"])
		{
			systemItem = UIBarButtonSystemItemPause;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemRewind"])
		{
			systemItem = UIBarButtonSystemItemRewind;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemFastForward"])
		{
			systemItem = UIBarButtonSystemItemFastForward;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemUndo"])
		{
			systemItem = UIBarButtonSystemItemUndo;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemRedo"])
		{
			systemItem = UIBarButtonSystemItemRedo;
		}
		else if ([imageName isEqualToString:@"UIBarButtonSystemItemPageCurl"])
		{
			systemItem = UIBarButtonSystemItemPageCurl;
		}
        
		if (systemItem)
		{
			item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(toolBarButtonTapped:)];
			if ([imageName isEqualToString:@"UIBarButtonSystemItemFixedSpace"])
			{
				item.width = 14;
			}
		}
		else
		{
			item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:useStyle target:self action:@selector(toolBarButtonTapped:)];
		}
    }
	else 
	{
		item = [[UIBarButtonItem alloc] initWithTitle:title style:useStyle target:self action:@selector(toolBarButtonTapped:)];
	}
    
	
    [toolBarItems insertObject:item atIndex:[tagId intValue]];
	[item release];
}

- (void)showToolBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!toolBar)
	{
        [self createToolBar:nil withDict:nil];
	}	
	
	[toolBar setItems:toolBarItems animated:NO];
}

- (void) toolBarButtonTapped:(UIBarButtonItem *)button
{
	int count = 0;
    
	for (UIBarButtonItem* currentButton in toolBarItems)
	{
		if (currentButton == button) {
			NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.nativeControls.toolBarButtonTapped(%d);", count];    
			[self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
			return;
		}
		
		count++;
	}
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
    [actionSheet showInView:self.webView.superview];
    [actionSheet release];
	
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.nativeControls._onActionSheetDismissed(%d);", buttonIndex];    
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}



@end