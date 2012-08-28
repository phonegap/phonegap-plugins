//
//  QRImageViewController.h
//  basePackage
//
//  Created by Liu Ley on 12-7-31.
//  Copyright (c) 2012年 SINA SAE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRImageViewController : UIViewController
{
    IBOutlet UIBarButtonItem *closeItem;
    IBOutlet UIImageView *imageView;
}
-(void)showQRImage:(UIImage*)image;
- (IBAction)closeView:(id)sender;
@end
