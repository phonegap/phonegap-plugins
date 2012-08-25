//
//  PGAudio.h
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

#import <Foundation/Foundation.h>
#import <CORDOVA/CDVPlugin.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "LowLatencyAudioAsset.h"
#import <AudioToolbox/AudioToolbox.h>

@interface LowLatencyAudio : CDVPlugin {
    NSMutableDictionary* audioMapping; 
}

//Public Instance Methods (visible in phonegap API)
- (void) preloadFX:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) preloadAudio:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) play:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) stop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) loop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) unload:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;


//Instance Methods  


@end
