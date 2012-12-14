//
//  BonjourPlugin.m
//  BonjourPlugin -  PhoneGap/Cordova Plug-In
//
//  Created by Justin D'Arcangelo on 12/11/12.
//  Copyright (c) 2012 Entropi Software. All rights reserved.
//

#import "BonjourPlugin.h"

#include <arpa/inet.h>

@interface BonjourPlugin()

@property (nonatomic, strong) NSNetServiceBrowser *_netServiceBrowser;
@property (nonatomic, strong) NSNetService *_netService;
@property (nonatomic, strong) NSMutableArray *_resolvingServices;
@property (nonatomic, strong) NSString *_callbackId;

- (NSString *)urlStringForNetworkService:(NSNetService *)service;

@end

@implementation BonjourPlugin

@synthesize _netServiceBrowser;
@synthesize _netService;
@synthesize _resolvingServices;
@synthesize _callbackId;

- (CDVPlugin *)initWithWebView:(UIWebView *)theWebView {
  if ((self = (BonjourPlugin *)[super initWithWebView:theWebView])) {
    
    // Create a mutable array for storing the discovered services.
    self._resolvingServices = [[NSMutableArray alloc] init];
    
    // Allocate and initialize a network service browser.
    self._netServiceBrowser = [[NSNetServiceBrowser alloc] init];
    
    // Assign this plugin as the delegate for the network service browser.
    [self._netServiceBrowser setDelegate:self];
  }
  
  return self;
}

- (void)startServiceDiscovery:(CDVInvokedUrlCommand *)command {
  NSArray *arguments = [command arguments];
  
  NSString *serviceType  = (NSString *)[arguments objectAtIndex:0];
  NSString *searchDomain = (NSString *)[arguments objectAtIndex:1];
  
  self._callbackId = [command callbackId];
  
  [self._netServiceBrowser searchForServicesOfType:serviceType inDomain:searchDomain];
}

- (void)stopServiceDiscovery:(CDVInvokedUrlCommand *)command {
  if (!self._netServiceBrowser) return;
  
  [self._netServiceBrowser stop];
}

- (NSString *)urlStringForNetworkService:(NSNetService *)service {
  for (NSData *data in [service addresses]) {
    char addressBuffer[100];
    struct sockaddr_in *socketAddress = (struct sockaddr_in *)[data bytes];
    int sockFamily = socketAddress -> sin_family;
    
    if (sockFamily == AF_INET) {
      const char *addressStr = inet_ntop(sockFamily, &(socketAddress -> sin_addr), addressBuffer, sizeof(addressBuffer));
      int port = ntohs(socketAddress -> sin_port);
      
      return [NSString stringWithFormat:@"http://%s:%d", addressStr, port];
    }
  }
  
  return nil;
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
	[self._resolvingServices addObject:netService];
  
  // A service has been found; Start resolving its address.
  [netService setDelegate:self];
	[netService resolveWithTimeout:0.0];
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
  
  // Get the service that has been resolved.
  self._netService = sender;
  
  // Stop searching for network services.
  [self stopServiceDiscovery:nil];
  
  // Get the URL string for the discovered service.
  NSString *urlString = [self urlStringForNetworkService:self._netService];
  
  // Execute the callback in the JavaScript plugin with the result.
  CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:urlString];
  [self.commandDelegate sendPluginResult:result callbackId:self._callbackId];
}

@end
