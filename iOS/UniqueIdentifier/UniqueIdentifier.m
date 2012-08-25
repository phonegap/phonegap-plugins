//
//  UniqueIdentifier.m
//  UniqueIdentifierPlugin
//
//  Created by Andrew Thorp on 4/13/12
//
//
// THIS SOFTWARE IS PROVIDED BY THE ANDREW THORP "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
// EVENT SHALL ANDREW TRICE OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "UniqueIdentifier.h"
#define UUID_USER_DEFAULTS_KEY @"UUID"

@implementation UniqueIdentifier

@synthesize callbackID;

NSString* UNIQUE_IDENTIFIER_OK = @"OK";
NSString* UNIQUE_IDENTIFIER_ERROR = @"ERROR";

- (void) generateUUID:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callbackID = [arguments pop];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults stringForKey:UUID_USER_DEFAULTS_KEY] == nil) {
      uuid = CFUUIDCreate(NULL);
      if (uuid) {
        uuidString = (NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
      }

      [defaults setObject:uuidString forKey:UUID_USER_DEFAULTS_KEY];
      [defaults synchronize];
    }

    NSString *uniqueIdentifier = [defaults stringForKey:UUID_USER_DEFAULTS_KEY];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: uniqueIdentifier];
    [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
}

- (void) getUUID:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callbackID = [arguments pop];
    CDVPluginResult* pluginResult;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults stringForKey:UUID_USER_DEFAULTS_KEY] == nil){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: UNIQUE_IDENTIFIER_ERROR];
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
    } else {
        NSString *uniqueIdentifier = [defaults stringForKey:UUID_USER_DEFAULTS_KEY];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: uniqueIdentifier];
        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    }
}

@end
