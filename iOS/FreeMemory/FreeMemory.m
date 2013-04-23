#import <mach/mach.h> 
#import <mach/mach_host.h>

#import "FreeMemory.h"
#import <Cordova/CDV.h>


@implementation FreeMemory
- (NSUInteger)amountOfFreeMemory {
    mach_port_t             host_port = mach_host_self();
    mach_msg_type_number_t  host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t    vm_stat;
    host_page_size(host_port, &pagesize);
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) NSLog(@"Failed to fetch vm statistics");
    //natural_t   mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    //natural_t   mem_total = mem_used + mem_free;
    natural_t   mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}




- (void) getFreeMemory:(CDVInvokedUrlCommand*)command{
    CDVPluginResult* pluginResult = nil;
    NSUInteger freemem = [self amountOfFreeMemory];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%d", freemem]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
