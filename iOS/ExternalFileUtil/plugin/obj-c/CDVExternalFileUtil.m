//
//  CDVOpenWith.m
//  OpenWith
//
//  Cordova 3.0 Compatibility added on 9/26/13 by njtman
//  Created by Andrew Trice on 8/15/12.
//  
//  THIS SOFTWARE IS PROVIDED BY ANDREW TRICE "AS IS" AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
//  EVENT SHALL ANDREW TRICE OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
//  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "CDVExternalFileUtil.h"

@implementation CDVExternalFileUtil

- (void) openWith:(CDVInvokedUrlCommand*)command;
{
        CDVPluginResult* pluginResult;

        NSString *path = [command.arguments objectAtIndex:0];
        NSString *uti = [command.arguments objectAtIndex:1];
        
        //NSLog(@"path %@, uti:%@", path, uti);
        
        NSArray *parts = [path componentsSeparatedByString:@"/"];
        NSString *previewDocumentFileName = [parts lastObject];
        //NSLog(@"The file name is %@", previewDocumentFileName);
        
        // TODO: Create native activity indicator
        NSData *fileRemote = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
        
        // Write file to the Documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        if (!documentsDirectory) {NSLog(@"Documents directory not found!");}
        localFile = [documentsDirectory stringByAppendingPathComponent:previewDocumentFileName];
        [fileRemote writeToFile:localFile atomically:YES];
        //NSLog(@"Resource file '%@' has been written to the Documents directory from online", previewDocumentFileName);
    
        // Get file again from Documents directory
        NSURL *fileURL = [NSURL fileURLWithPath:localFile];

        _controller = [UIDocumentInteractionController  interactionControllerWithURL:fileURL];
        _controller.delegate = self;
        _controller.UTI = uti;
    
        CDVViewController* cont = (CDVViewController*)[ super viewController ];
        //CGRect rect = CGRectMake(0, 0, 1500.0f, 50.0f);
        [_controller presentOpenInMenuFromRect:CGRectZero inView:cont.view animated:YES];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @""];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    //NSLog(@"documentInteractionControllerDidDismissOpenInMenu");
    [self cleanupTempFile:controller];
}

- (void) documentInteractionController: (UIDocumentInteractionController *) controller didEndSendingToApplication: (NSString *) application {
    //NSLog(@"didEndSendingToApplication: %@", application);
    [self cleanupTempFile:controller];
}

- (void) cleanupTempFile: (UIDocumentInteractionController *) controller
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;

    BOOL fileExists = [fileManager fileExistsAtPath:localFile];
    
    //NSLog(@"Path to file: %@", localFile);   
    //NSLog(@"File exists: %d", fileExists);
    //NSLog(@"Is deletable file at path: %d", [fileManager isDeletableFileAtPath:localFile]);
    
    if (fileExists)
    {
        BOOL success = [fileManager removeItemAtPath:localFile error:&error];
        if (!success) NSLog(@"Error: %@", [error localizedDescription]);
    }
}

@end
