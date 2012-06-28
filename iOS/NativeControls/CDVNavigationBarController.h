//
//  CDVNavigationBarController.h
//  HelloPhoneGap1
//
//  Created by Hiedi Utley on 8/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDVNavigationBarDelegate <NSObject>
-(void)leftNavButtonTapped;
-(void)rightNavButtonTapped;
@end 

@interface CDVNavigationBarController : UIViewController{

    IBOutlet UIBarButtonItem * leftButton;
    IBOutlet UIBarButtonItem * rightButton;
    IBOutlet UINavigationItem * navItem;    
    id<CDVNavigationBarDelegate>  delegate;
    
}

@property (nonatomic, retain) UINavigationItem * navItem;
@property (nonatomic, retain) UIBarButtonItem * leftButton;
@property (nonatomic, retain) UIBarButtonItem * rightButton;
@property (nonatomic, retain) id<CDVNavigationBarDelegate>  delegate;

-(IBAction)leftNavButtonTapped:(id)sender;
-(IBAction)rightNavButtonTapped:(id)sender;

@end
