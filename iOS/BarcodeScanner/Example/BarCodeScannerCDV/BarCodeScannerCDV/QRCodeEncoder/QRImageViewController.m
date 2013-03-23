//
//  QRImageViewController.m
//  basePackage
//
//  Created by Liu Ley on 12-7-31.
//  Copyright (c) 2012年 SINA SAE. All rights reserved.
//

#import "QRImageViewController.h"

@interface QRImageViewController ()
{
}
@end

@implementation QRImageViewController


-(void)showQRImage:(UIImage*)image
{
    imageView.image=image;
}

- (IBAction)closeView:(id)sender
{
    if ([self respondsToSelector:@selector(presentingViewController)]) { 
        //Reference UIViewController.h Line:179 for update to iOS 5 difference - @RandyMcMillan
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
