/*
 * Copyright (C) 2011-2012 Wolfgang Koller
 * 
 * This file is part of GOFG Sports Computer - http://www.gofg.at/.
 * 
 * GOFG Sports Computer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * GOFG Sports Computer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with GOFG Sports Computer.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * Cordova (iOS) plugin for accessing the power-management functions of the device
 */
#import "PowerManagement.h"

/**
 * Actual implementation of the interface
 */
@implementation PowerManagement
- (void) acquire:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    CDVPluginResult* result = nil;
    NSString* jsString = nil;
    NSString* callbackId = [arguments objectAtIndex:0];
    
    // Acquire a reference to the local UIApplication singleton
    UIApplication* app = [UIApplication sharedApplication];
    
    if( ![app isIdleTimerDisabled] ) {
        [app setIdleTimerDisabled:true];
        
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        jsString = [result toSuccessCallbackString:callbackId];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ILLEGAL_ACCESS_EXCEPTION messageAsString:@"IdleTimer already disabled"];
        jsString = [result toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:jsString];
}


- (void) release:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{    
    CDVPluginResult* result = nil;
    NSString* jsString = nil;
    NSString* callbackId = [arguments objectAtIndex:0];
    
    // Acquire a reference to the local UIApplication singleton
    UIApplication* app = [UIApplication sharedApplication];
    
    if( [app isIdleTimerDisabled] ) {
        [app setIdleTimerDisabled:false];
        
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        jsString = [result toSuccessCallbackString:callbackId];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ILLEGAL_ACCESS_EXCEPTION messageAsString:@"IdleTimer not disabled"];
        jsString = [result toErrorCallbackString:callbackId];
    }
    
    [self writeJavascript:jsString];
}
@end
