//
//  main.m
//  example
//
//  Created by Gregamel on 4/3/11.
//  Copyright Boeing 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"exampleAppDelegate");
    [pool release];
    return retVal;
}
