//
//  SHKSharer+Phonegap.m
//  example
//
//  Created by Erick Camacho Chavarría on 13/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SHKSharer+Phonegap.h"

@implementation SHKSharer (SHKSharer_Phonegap)

+ (id)loginToService {
    
    SHKSharer *controller = [[self alloc] init];
    if( ![controller isAuthorized] ) {
        [controller promptAuthorization];
    }
    
    return [controller autorelease];
}

@end
