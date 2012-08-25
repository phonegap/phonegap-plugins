//
//  PGAudio.m
//  PGAudio
//
//  Created by Andrew Trice on 1/19/12.
//
// THIS SOFTWARE IS PROVIDED BY ANDREW TRICE "AS IS" AND ANY EXPRESS OR
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

#import "LowLatencyAudio.h"

@implementation LowLatencyAudio

NSString* ERROR_NOT_FOUND = @"file not found";
NSString* WARN_EXISTING_REFERENCE = @"a reference to the audio ID already exists";
NSString* ERROR_MISSING_REFERENCE = @"a reference to the audio ID does not exist";
NSString* CONTENT_LOAD_REQUESTED = @"content has been requested";
NSString* PLAY_REQUESTED = @"PLAY REQUESTED";
NSString* STOP_REQUESTED = @"STOP REQUESTED";
NSString* UNLOAD_REQUESTED = @"UNLOAD REQUESTED";
NSString* RESTRICTED = @"ACTION RESTRICTED FOR FX AUDIO";


- (void) preloadFX:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{   
    CDVPluginResult* pluginResult;
    NSString* callbackID = [arguments pop];
    [callbackID retain];
    
    NSString *audioID = [arguments objectAtIndex:0]; 
    [audioID retain];
    
    NSString *assetPath = [arguments objectAtIndex:1]; 
    [assetPath retain]; 
    
    if(audioMapping == nil)
    {
        audioMapping = [NSMutableDictionary dictionary];
        [audioMapping retain];    
    }
    
    NSNumber* existingReference = [audioMapping objectForKey: audioID];
    if (existingReference == nil)
    {
        NSString* basePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www"];
        [basePath retain];
        
        NSString* path = [NSString stringWithFormat:@"%@/%@", basePath, assetPath];
        [path retain];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath : path])
        {
            NSURL *pathURL = [NSURL fileURLWithPath : path];
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID((CFURLRef) pathURL, & soundID);
            [audioMapping setObject:[NSNumber numberWithInt:soundID]  forKey: audioID];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: CONTENT_LOAD_REQUESTED];
            [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
        }
        else
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_NOT_FOUND];        
            [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
        }
        
        [basePath release];
        [path release];
    }
    else 
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: WARN_EXISTING_REFERENCE];        
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
    }
    
    [callbackID release];
    [audioID release];
    [assetPath release];
}

- (void) preloadAudio:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{   
    CDVPluginResult* pluginResult;
    NSString* callbackID = [arguments pop];
    [callbackID retain];
    
    NSString *audioID = [arguments objectAtIndex:0]; 
    [audioID retain];
    
    NSString *assetPath = [arguments objectAtIndex:1]; 
    [assetPath retain]; 
    
    NSNumber *voices;
    if ( [arguments count] > 2 )
    {
        voices = [arguments objectAtIndex:2];
    }
    else
    {
        voices = [NSNumber numberWithInt:1];
    }
    [voices retain];
    
    if(audioMapping == nil)
    {
        audioMapping = [NSMutableDictionary dictionary];
        [audioMapping retain];    
    }
    
    NSNumber* existingReference = [audioMapping objectForKey: audioID];
    if (existingReference == nil)
    {
        NSString* basePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www"];
        [basePath retain];
        
        NSString* path = [NSString stringWithFormat:@"%@/%@", basePath, assetPath];
        [path retain];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath : path])
        {
            LowLatencyAudioAsset* asset = [[LowLatencyAudioAsset alloc] initWithPath:path withVoices:voices];
            [asset retain];
            [audioMapping setObject:asset  forKey: audioID];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: CONTENT_LOAD_REQUESTED];
            [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
        }
        else
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_NOT_FOUND];        
            [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
        }
        
        [basePath release];
        [path release];
    }
    else 
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: WARN_EXISTING_REFERENCE];        
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
    }
    
    [callbackID release];
    [audioID release];
    [assetPath release];
    [voices release];
}

- (void) play:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    CDVPluginResult* pluginResult;
    NSString* callbackID = [arguments pop];
    [callbackID retain];
    
    NSString *audioID = [arguments objectAtIndex:0]; 
    [audioID retain];
    
    if ( audioMapping )
    {
        NSObject* asset = [audioMapping objectForKey: audioID];
        if ([asset isKindOfClass:[LowLatencyAudioAsset class]])
        { 
            LowLatencyAudioAsset *_asset = (LowLatencyAudioAsset*) asset;
            [_asset play];
        }
        else if ( [asset isKindOfClass:[NSNumber class]] )
        {
            NSNumber *_asset = (NSNumber*) asset;
            AudioServicesPlaySystemSound([_asset intValue]);
        }
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: PLAY_REQUESTED];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
    }
    else 
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_MISSING_REFERENCE];        
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
    }
    
    [callbackID release];
    [audioID release];
}

- (void) stop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    CDVPluginResult* pluginResult;
    NSString* callbackID = [arguments pop];
    [callbackID retain];
    
    NSString *audioID = [arguments objectAtIndex:0]; 
    [audioID retain];
    
    if ( audioMapping )
    {
        NSObject* asset = [audioMapping objectForKey: audioID];
        if ([asset isKindOfClass:[LowLatencyAudioAsset class]])
        { 
            LowLatencyAudioAsset *_asset = (LowLatencyAudioAsset*) asset;
            [_asset stop];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: STOP_REQUESTED];
            [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];    
        }
        else if ( [asset isKindOfClass:[NSNumber class]] )
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESTRICTED];        
            [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
        }
        
    }
    else 
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_MISSING_REFERENCE];        
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
    }
    
    [callbackID release];
    [audioID release];
}

- (void) loop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    CDVPluginResult* pluginResult;
    NSString* callbackID = [arguments pop];
    [callbackID retain];
    
    NSString *audioID = [arguments objectAtIndex:0]; 
    [audioID retain];
    
    if ( audioMapping )
    {
        NSObject* asset = [audioMapping objectForKey: audioID];
        if ([asset isKindOfClass:[LowLatencyAudioAsset class]])
        { 
            LowLatencyAudioAsset *_asset = (LowLatencyAudioAsset*) asset;
            [_asset loop];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: STOP_REQUESTED];
            [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];    
        }
        else if ( [asset isKindOfClass:[NSNumber class]] )
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESTRICTED];        
            [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
        }
    }
    else 
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_MISSING_REFERENCE];        
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
    }
    
    [callbackID release];
    [audioID release];
}

- (void) unload:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    CDVPluginResult* pluginResult;
    NSString* callbackID = [arguments pop];
    [callbackID retain];
    
    NSString *audioID = [arguments objectAtIndex:0]; 
    [audioID retain];
    
    if ( audioMapping )
    {
        NSObject* asset = [audioMapping objectForKey: audioID];
        if ([asset isKindOfClass:[LowLatencyAudioAsset class]])
        { 
            LowLatencyAudioAsset *_asset = (LowLatencyAudioAsset*) asset;
            [_asset unload];
        }
        else if ( [asset isKindOfClass:[NSNumber class]] )
        {
            NSNumber *_asset = (NSNumber*) asset;
            AudioServicesDisposeSystemSoundID([_asset intValue]);
        }
        
        [audioMapping removeObjectForKey: audioID];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: UNLOAD_REQUESTED];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
    }
    else 
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: ERROR_MISSING_REFERENCE];        
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
    }
    
    [callbackID release];
    [audioID release];
}

@end
