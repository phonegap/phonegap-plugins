//
//  Macaddress.m
//  Get the Wifi Mac Address
//
//  Created by Joey W.(Huang Jun Yan) on 17/3/13.
//  Copyright (c) 2013 Appswood. All rights reserved.
//

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "Macaddress.h"

@implementation Macaddress

- (void)getMacAddress:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callBackId=[arguments objectAtIndex:0];
    
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
   
    if (errorFlag != NULL)
    {
        errorFlag = @"No MAC address found";
        
    }
   
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
   
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
   
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
   
    free(msgBuffer);
    
    if([macAddressString length] > 0)
    {
       //NSLog(@"Mac Address: %@", macAddressString);
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:macAddressString];
        [super writeJavascript:[result toSuccessCallbackString:self.callBackId]];
    }else {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorFlag];
        [super writeJavascript:[result toErrorCallbackString:self.callBackId]];
    }

}

@end
