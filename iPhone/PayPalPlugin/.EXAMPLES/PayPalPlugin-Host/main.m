//
//  main.m
//  paypal-plugin-host
//
//  Created by shazron on 10-10-08.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"paypal_plugin_hostAppDelegate");
    [pool release];
    return retVal;
}
