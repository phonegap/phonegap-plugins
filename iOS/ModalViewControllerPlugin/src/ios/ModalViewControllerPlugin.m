//
//  ModalViewControllerPlugin.m
//  ModalViewControllerPlugin -  PhoneGap/Cordova Plug-In
//
//  Created by Justin D'Arcangelo on 12/11/12.
//  Copyright (c) 2012 Entropi Software. All rights reserved.
//

#import "ModalViewControllerPlugin.h"

@interface ModalViewControllerPlugin()

@end

@implementation ModalViewControllerPlugin

- (CDVPlugin *)initWithWebView:(UIWebView *)theWebView {
  if ((self = (ModalViewControllerPlugin *)[super initWithWebView:theWebView])) {
    
  }
  
  return self;
}

- (void)presentModalViewController:(CDVInvokedUrlCommand *)command {
  NSDictionary *options = [[command arguments] objectAtIndex:0];
  
  NSString *viewControllerName =       [options objectForKey:@"viewControllerName"];
  NSString *nibName            =       [options objectForKey:@"nibName"];
  BOOL useNavigationController = (BOOL)[options objectForKey:@"useNavigationController"];
  BOOL animated                = (BOOL)[options objectForKey:@"animated"];
  
  Class viewControllerClass = NSClassFromString(viewControllerName);
  UIViewController *viewController;
  
  if ([nibName isEqualToString:@""]) {
    viewController = [[viewControllerClass alloc] init];
  }
  
  else {
    viewController = [[viewControllerClass alloc] initWithNibName:nibName bundle:nil];
  }
  
  if (useNavigationController) {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.viewController presentModalViewController:navigationController animated:animated];
  }
  
  else {
    [self.viewController presentModalViewController:viewController animated:animated];
  }
  
  CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
}

- (void)dismissModalViewController:(CDVInvokedUrlCommand *)command {
  NSDictionary *options = [[command arguments] objectAtIndex:0];
  
  BOOL animated = (BOOL)[options objectForKey:@"animated"];
  
  [self.viewController dismissModalViewControllerAnimated:animated];
  
  CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
}

@end
