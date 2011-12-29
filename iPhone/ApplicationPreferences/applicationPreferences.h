//
//  applicationPreferences.h
//  
//
//  Created by Tue Topholm on 31/01/11.
//  Copyright 2011 Sugee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <PhoneGap/PGPlugin.h>

@interface applicationPreferences : PGPlugin 
{

}

-	(void) getSetting:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
-	(void) setSetting:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
-	(NSString*) getSettingFromBundle:(NSString*)settingName;


@end
