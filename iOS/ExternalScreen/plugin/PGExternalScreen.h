//
//  PGExternalScreen.h
//  MultiScreenPlugin
//
//  Created by Andrew Trice on 1/9/12.
//
//
// THIS SOFTWARE IS PROVIDED BY THE ANDREW TRICE "AS IS" AND ANY EXPRESS OR
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
#import <Cordova/CDV.h>


@interface PGExternalScreen : CDVPlugin {
    
	UIWindow* externalWindow;
	UIScreen* externalScreen;
    UIWebView* webView;
    NSString *baseURLAddress;
    NSURL *baseURL;
}


//Public Instance Method (visible in phonegap API)
- (void) setupScreenConnectionNotificationHandlers:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options ;
- (void) loadHTMLResource:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) loadHTML:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) invokeJavaScript:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) checkExternalScreenAvailable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;


//Instance Method  
- (void) attemptSecondScreenView;
- (void) handleScreenConnectNotification:(NSNotification*)aNotification;
- (void) handleScreenDisconnectNotification:(NSNotification*)aNotification;
@end
