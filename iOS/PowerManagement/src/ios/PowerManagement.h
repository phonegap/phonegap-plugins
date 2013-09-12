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

#ifdef CORDOVA_FRAMEWORK
#import <CORDOVA/CDVPlugin.h>
#else
#import "CORDOVA/CDVPlugin.h"
#endif

/**
 * Interface which does the actual handling
 */
@interface PowerManagement :CDVPlugin {    
}
/**
 * Sets the idleTimerDisable property to true so that the idle timeout is disabled
 */
- (void) acquire:(CDVInvokedUrlCommand*)command;

/**
 * Sets the idleTimerDisable property to false so that the idle timeout is enabled
 */
- (void) release:(CDVInvokedUrlCommand*)command;

@end
