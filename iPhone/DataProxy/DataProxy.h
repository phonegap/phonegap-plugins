//
//  DataProxy.h
//  DataProxy plugin for PhoneGap
//
//  Created by Brian Antonelli on 7/7/11
//

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PhoneGapCommand.h>
#else
#import "PhoneGapCommand.h"
#endif

@interface DataProxy : PhoneGapCommand {
    NSMutableDictionary *dataStreams;
    NSMutableDictionary *callbacks;
}

-(void) getData: (NSMutableArray*) arguments withDict: (NSMutableDictionary*) options;

-(NSString*) createUUID;

-(void) removeDataStream: (NSString*) uuid;

@property(nonatomic, retain) NSMutableDictionary *dataStreams;
@property(nonatomic, retain) NSMutableDictionary *callbacks;

@end