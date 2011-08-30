/*
 * Author: Andreas Linde <mail@andreaslinde.de>
 *         Kent Sutherland
 *
 * Copyright (c) 2011 Andreas Linde & Kent Sutherland.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

#import <CrashReporter/CrashReporter.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <UIKit/UIKit.h>
#import "BWQuincyManager.h"

#include <sys/sysctl.h>
#include <inttypes.h> //needed for PRIx64 macro

NSBundle *quincyBundle(void) {
    static NSBundle* bundle = nil;
    if (!bundle) {
        NSString* path = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:kQuincyBundleName];
        bundle = [[NSBundle bundleWithPath:path] retain];
    }
    return bundle;
}

NSString *BWQuincyLocalize(NSString *stringToken) {
    if ([BWQuincyManager sharedQuincyManager].languageStyle == nil)
        return NSLocalizedStringFromTableInBundle(stringToken, @"Quincy", quincyBundle(), @"");
    else {
        NSString *alternate = [NSString stringWithFormat:@"Quincy%@", [BWQuincyManager sharedQuincyManager].languageStyle];
        return NSLocalizedStringFromTableInBundle(stringToken, alternate, quincyBundle(), @"");
    }
}


@interface BWQuincyManager ()

- (void)startManager;

- (void)showCrashStatusMessage;

- (void)handleCrashReport;
- (void)_cleanCrashReports;

- (void)_checkForFeedbackStatus;

- (void)_performSendingCrashReports;
- (void)_sendCrashReports;

- (NSString *)_crashLogStringForReport:(PLCrashReport *)report;
- (void)_postXML:(NSString*)xml toURL:(NSURL*)url;
- (NSString *)_getDevicePlatform;

- (BOOL)hasNonApprovedCrashReports;
- (BOOL)hasPendingCrashReport;

@end

@implementation BWQuincyManager

@synthesize delegate = _delegate;
@synthesize submissionURL = _submissionURL;
@synthesize showAlwaysButton = _showAlwaysButton;
@synthesize feedbackActivated = _feedbackActivated;
@synthesize autoSubmitCrashReport = _autoSubmitCrashReport;
@synthesize autoSubmitDeviceUDID = _autoSubmitDeviceUDID;
@synthesize languageStyle = _languageStyle;

@synthesize appIdentifier = _appIdentifier;

+ (BWQuincyManager *)sharedQuincyManager {
	static BWQuincyManager *quincyManager = nil;
	
	if (quincyManager == nil) {
		quincyManager = [[BWQuincyManager alloc] init];
	}
	
	return quincyManager;
}

- (id) init {
    if ((self = [super init])) {
		_serverResult = CrashReportStatusUnknown;
		_crashIdenticalCurrentVersion = YES;
		_crashData = nil;
        _urlConnection = nil;
		_submissionURL = nil;
        _responseData = nil;
        _appIdentifier = nil;
        _sendingInProgress = NO;
        _languageStyle = nil;
        
		self.delegate = nil;
        self.feedbackActivated = NO;
        self.showAlwaysButton = NO;
        self.autoSubmitCrashReport = NO;
        self.autoSubmitDeviceUDID = NO;
        
		NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kQuincyKitAnalyzerStarted];
		if (testValue) {
			_analyzerStarted = [[NSUserDefaults standardUserDefaults] integerForKey:kQuincyKitAnalyzerStarted];
		} else {
			_analyzerStarted = 0;		
		}
		
		testValue = nil;
		testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kQuincyKitActivated];
		if (testValue) {
			_crashReportActivated = [[NSUserDefaults standardUserDefaults] boolForKey:kQuincyKitActivated];
		} else {
			_crashReportActivated = YES;
			[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kQuincyKitActivated];
		}
		
        if ([[NSUserDefaults standardUserDefaults] stringForKey:kAutomaticallySendCrashReports]) {
            self.autoSubmitCrashReport = [[NSUserDefaults standardUserDefaults] boolForKey: kAutomaticallySendCrashReports];
        }
        
		if (_crashReportActivated) {
			_crashFiles = [[NSMutableArray alloc] init];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
			_crashesDir = [[NSString stringWithFormat:@"%@", [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/crashes/"]] retain];
			
			NSFileManager *fm = [NSFileManager defaultManager];
			
			if (![fm fileExistsAtPath:_crashesDir]) {
				NSDictionary *attributes = [NSDictionary dictionaryWithObject: [NSNumber numberWithUnsignedLong: 0755] forKey: NSFilePosixPermissions];
				NSError *theError = NULL;
				
				[fm createDirectoryAtPath:_crashesDir withIntermediateDirectories: YES attributes: attributes error: &theError];
			}

			PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
			NSError *error = NULL;
			
			// Check if we previously crashed
			if ([crashReporter hasPendingCrashReport]) {
				[self handleCrashReport];
            }
            
			// Enable the Crash Reporter
			if (![crashReporter enableCrashReporterAndReturnError: &error])
				NSLog(@"Warning: Could not enable crash reporter: %@", error);
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startManager) name:BWQuincyNetworkBecomeReachable object:nil];
		}
	}
	return self;
}


- (void) dealloc {
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BWQuincyNetworkBecomeReachable object:nil];
    
    [_languageStyle release];
    
    [_submissionURL release];
    _submissionURL = nil;
    
    [_appIdentifier release];
    _appIdentifier = nil;
    
    [_urlConnection cancel];
    [_urlConnection release]; 
    _urlConnection = nil;
    
    [_crashData release];
    
	[_crashesDir release];
	[_crashFiles release];
    
	[super dealloc];
}


#pragma mark -
#pragma mark setter
- (void)setSubmissionURL:(NSString *)anSubmissionURL {
    if (_submissionURL != anSubmissionURL) {
        [_submissionURL release];
        _submissionURL = [anSubmissionURL copy];
    }
    
    [self performSelector:@selector(startManager) withObject:nil afterDelay:1.0f];
}

- (void)setAppIdentifier:(NSString *)anAppIdentifier {    
    if (_appIdentifier != anAppIdentifier) {
        [_appIdentifier release];
        _appIdentifier = [anAppIdentifier copy];
    }
    
    [self setSubmissionURL:@"https://beta.hockeyapp.net/"];
}


#pragma mark -
#pragma mark private methods

// begin the startup process
- (void)startManager {
    if (!_sendingInProgress && [self hasPendingCrashReport]) {
        _sendingInProgress = YES;
        if (!self.autoSubmitCrashReport && [self hasNonApprovedCrashReports]) {
            NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:BWQuincyLocalize(@"CrashDataFoundTitle"), appName]
                                                                message:[NSString stringWithFormat:BWQuincyLocalize(@"CrashDataFoundDescription"), appName]
                                                               delegate:self
                                                      cancelButtonTitle:BWQuincyLocalize(@"CrashDontSendReport")
                                                      otherButtonTitles:BWQuincyLocalize(@"CrashSendReport"), nil];
            
            if ([self isShowingAlwaysButton]) {
                [alertView addButtonWithTitle:BWQuincyLocalize(@"CrashSendReportAlways")];
            }
            
            [alertView setTag: QuincyKitAlertTypeSend];
            [alertView show];
            [alertView release];
        } else {
            [self _sendCrashReports];
        }
    }
}

- (BOOL)hasNonApprovedCrashReports {
    NSDictionary *approvedCrashReports = [[NSUserDefaults standardUserDefaults] dictionaryForKey: kApprovedCrashReports];

    if (!approvedCrashReports || [approvedCrashReports count] == 0) return YES;
    
	for (NSUInteger i=0; i < [_crashFiles count]; i++) {
		NSString *filename = [_crashFiles objectAtIndex:i];
        
        if (![approvedCrashReports objectForKey:filename]) return YES;
    }
    
    return NO;
}

- (BOOL)hasPendingCrashReport {
	if (_crashReportActivated) {
		NSFileManager *fm = [NSFileManager defaultManager];
		
		if ([_crashFiles count] == 0 && [fm fileExistsAtPath:_crashesDir]) {
			NSString *file = nil;
            NSError *error = NULL;
            
			NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath: _crashesDir];
			
			while ((file = [dirEnum nextObject])) {
				NSDictionary *fileAttributes = [fm attributesOfItemAtPath:[_crashesDir stringByAppendingPathComponent:file] error:&error];
				if ([[fileAttributes objectForKey:NSFileSize] intValue] > 0) {
					[_crashFiles addObject:file];
				}
			}
		}
		
		if ([_crashFiles count] > 0) {
			return YES;
		} else
			return NO;
	} else
		return NO;
}


- (void) showCrashStatusMessage {
	UIAlertView *alertView;
	
	if (_serverResult >= CrashReportStatusAssigned && 
        _crashIdenticalCurrentVersion) {
		// show some feedback to the user about the crash status
		NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
		switch (_serverResult) {
			case CrashReportStatusAssigned:
				alertView = [[UIAlertView alloc] initWithTitle: [NSString stringWithFormat:BWQuincyLocalize(@"CrashResponseTitle"), appName ]
													   message: [NSString stringWithFormat:BWQuincyLocalize(@"CrashResponseNextRelease"), appName]
													  delegate: self
											 cancelButtonTitle: BWQuincyLocalize(@"CrashResponseTitleOK")
											 otherButtonTitles: nil];
				break;
			case CrashReportStatusSubmitted:
				alertView = [[UIAlertView alloc] initWithTitle: [NSString stringWithFormat:BWQuincyLocalize(@"CrashResponseTitle"), appName ]
													   message: [NSString stringWithFormat:BWQuincyLocalize(@"CrashResponseWaitingApple"), appName]
													  delegate: self
											 cancelButtonTitle: BWQuincyLocalize(@"CrashResponseTitleOK")
											 otherButtonTitles: nil];
				break;
			case CrashReportStatusAvailable:
				alertView = [[UIAlertView alloc] initWithTitle: [NSString stringWithFormat:BWQuincyLocalize(@"CrashResponseTitle"), appName ]
													   message: [NSString stringWithFormat:BWQuincyLocalize(@"CrashResponseAvailable"), appName]
													  delegate: self
											 cancelButtonTitle: BWQuincyLocalize(@"CrashResponseTitleOK")
											 otherButtonTitles: nil];
				break;
			default:
				alertView = nil;
				break;
		}
		
		if (alertView != nil) {
			[alertView setTag: QuincyKitAlertTypeFeedback];
			[alertView show];
			[alertView release];
		}
	}
}


#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([alertView tag] == QuincyKitAlertTypeSend) {
		switch (buttonIndex) {
			case 0:
                _sendingInProgress = NO;
				[self _cleanCrashReports];
				break;
			case 1:
				[self _sendCrashReports];
				break;
			case 2:
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAutomaticallySendCrashReports];
				
				[self _sendCrashReports];
				break;
		}
	}
}

#pragma mark -
#pragma mark NSXMLParser Delegate

#pragma mark NSXMLParser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if (qName) {
		elementName = qName;
	}
	
	if ([elementName isEqualToString:@"result"]) {
		_contentOfProperty = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (qName) {
		elementName = qName;
	}
	
    // open source implementation
	if ([elementName isEqualToString: @"result"]) {
		if ([_contentOfProperty intValue] > _serverResult) {
			_serverResult = (CrashReportStatus)[_contentOfProperty intValue];
		} else {
            CrashReportStatus errorcode = (CrashReportStatus)[_contentOfProperty intValue];
			NSLog(@"CrashReporter ended in error code: %i", errorcode);
		}
	}
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (_contentOfProperty) {
		// If the current element is one whose content we care about, append 'string'
		// to the property that holds the content of the current element.
		if (string != nil) {
			[_contentOfProperty appendString:string];
		}
	}
}

#pragma mark -
#pragma mark Private


- (NSString *)_getOSVersionBuild {
    size_t size = 0;    
    NSString *osBuildVersion = nil;
    
	sysctlbyname("kern.osversion", NULL, &size, NULL, 0);
	char *answer = (char*)malloc(size);
	int result = sysctlbyname("kern.osversion", answer, &size, NULL, 0);
    if (result >= 0) {
        osBuildVersion = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    }
    
    return osBuildVersion;   
}

- (NSString *)_getDevicePlatform {
	size_t size = 0;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *answer = (char*)malloc(size);
	sysctlbyname("hw.machine", answer, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	free(answer);
	return platform;
}


- (void)_performSendingCrashReports {
    NSMutableDictionary *approvedCrashReports = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey: kApprovedCrashReports]];

    NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error = NULL;
	
	NSString *userid = @"";
	NSString *contact = @"";
	NSString *description = @"";
	
    if (self.autoSubmitDeviceUDID) {
        userid = [[UIDevice currentDevice] uniqueIdentifier];
    } else if (self.delegate != nil && [self.delegate respondsToSelector:@selector(crashReportUserID)]) {
		userid = [self.delegate crashReportUserID];
	}
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(crashReportContact)]) {
		contact = [self.delegate crashReportContact];
	}
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(crashReportDescription)]) {
		description = [self.delegate crashReportDescription];
	}
	
    NSMutableString *crashes = nil;
    _crashIdenticalCurrentVersion = NO;
    
	for (NSUInteger i=0; i < [_crashFiles count]; i++) {
		NSString *filename = [_crashesDir stringByAppendingPathComponent:[_crashFiles objectAtIndex:i]];
		NSData *crashData = [NSData dataWithContentsOfFile:filename];
		
		if ([crashData length] > 0) {
			PLCrashReport *report = [[[PLCrashReport alloc] initWithData:crashData error:&error] autorelease];
			
            if (report == nil) {
                NSLog(@"Could not parse crash report");
                continue;
            }

			NSString *crashLogString = [self _crashLogStringForReport:report];
			
			if ([report.applicationInfo.applicationVersion compare:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]] == NSOrderedSame) {
				_crashIdenticalCurrentVersion = YES;
			}
			
            if (crashes == nil) {
                crashes = [NSMutableString string];
            }
            
			[crashes appendFormat:@"<crash><applicationname>%s</applicationname><bundleidentifier>%@</bundleidentifier><systemversion>%@</systemversion><platform>%@</platform><senderversion>%@</senderversion><version>%@</version><userid>%@</userid><contact>%@</contact><description><![CDATA[%@]]></description><log><![CDATA[%@]]></log></crash>",
             [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"] UTF8String],
             report.applicationInfo.applicationIdentifier,
             [[UIDevice currentDevice] systemVersion],
             [self _getDevicePlatform],
             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
             report.applicationInfo.applicationVersion,
             userid,
             contact,
             description,
             crashLogString];
            
            // store this crash report as user approved, so if it fails it will retry automatically
            [approvedCrashReports setObject:[NSNumber numberWithBool:YES] forKey:[_crashFiles objectAtIndex:i]];
		} else {
            // we cannot do anything with this report, so delete it
            [fm removeItemAtPath:filename error:&error];
        }
	}
	
    [[NSUserDefaults standardUserDefaults] setObject:approvedCrashReports forKey:kApprovedCrashReports];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (crashes != nil) {
        [self _postXML:[NSString stringWithFormat:@"<crashes>%@</crashes>", crashes]
                 toURL:[NSURL URLWithString:self.submissionURL]];
        
    }
}

- (void)_cleanCrashReports {
    NSError *error = NULL;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    for (NSUInteger i=0; i < [_crashFiles count]; i++) {		
        [fm removeItemAtPath:[_crashesDir stringByAppendingPathComponent:[_crashFiles objectAtIndex:i]] error:&error];
    }
    [_crashFiles removeAllObjects];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kApprovedCrashReports];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (void)_sendCrashReports {
    // send it to the next runloop
    [self performSelector:@selector(_performSendingCrashReports) withObject:nil afterDelay:0.0f];
}

- (NSString *)_crashLogStringForReport:(PLCrashReport *)report {
	NSMutableString *xmlString = [NSMutableString string];
	
	/* Header */
    boolean_t lp64;
	
	/* Map to apple style OS nane */
	const char *osName;
	switch (report.systemInfo.operatingSystem) {
		case PLCrashReportOperatingSystemiPhoneOS:
			osName = "iPhone OS";
			break;
		case PLCrashReportOperatingSystemiPhoneSimulator:
			osName = "Mac OS X";
			break;
		default:
			osName = "iPhone OS";
			break;
	}
	
	/* Map to Apple-style code type */
	NSString *codeType;
	switch (report.systemInfo.architecture) {
		case PLCrashReportArchitectureARM:
			codeType = @"ARM (Native)";
            lp64 = false;
			break;
        case PLCrashReportArchitectureX86_32:
            codeType = @"X86";
            lp64 = false;
            break;
        case PLCrashReportArchitectureX86_64:
            codeType = @"X86-64";
            lp64 = true;
            break;
        case PLCrashReportArchitecturePPC:
            codeType = @"PPC";
            lp64 = false;
            break;
		default:
			codeType = @"ARM (Native)";
            lp64 = false;
			break;
	}
	
	[xmlString appendString:@"Incident Identifier: [TODO]\n"];
	[xmlString appendString:@"CrashReporter Key:   [TODO]\n"];
    
    /* Application and process info */
    {
        NSString *unknownString = @"???";
        
        NSString *processName = unknownString;
        NSString *processId = unknownString;
        NSString *processPath = unknownString;
        NSString *parentProcessName = unknownString;
        NSString *parentProcessId = unknownString;
        
        /* Process information was not available in earlier crash report versions */
        if (report.hasProcessInfo) {
            /* Process Name */
            if (report.processInfo.processName != nil)
                processName = report.processInfo.processName;
            
            /* PID */
            processId = [[NSNumber numberWithUnsignedInteger: report.processInfo.processID] stringValue];
            
            /* Process Path */
            if (report.processInfo.processPath != nil)
                processPath = report.processInfo.processPath;
            
            /* Parent Process Name */
            if (report.processInfo.parentProcessName != nil)
                parentProcessName = report.processInfo.parentProcessName;
            
            /* Parent Process ID */
            parentProcessId = [[NSNumber numberWithUnsignedInteger: report.processInfo.parentProcessID] stringValue];
        }
        
        [xmlString appendFormat: @"Process:         %@ [%@]\n", processName, processId];
        [xmlString appendFormat: @"Path:            %@\n", processPath];
        [xmlString appendFormat: @"Identifier:      %@\n", report.applicationInfo.applicationIdentifier];
        [xmlString appendFormat: @"Version:         %@\n", report.applicationInfo.applicationVersion];
        [xmlString appendFormat: @"Code Type:       %@\n", codeType];
        [xmlString appendFormat: @"Parent Process:  %@ [%@]\n", parentProcessName, parentProcessId];
    }
    
	[xmlString appendString:@"\n"];
	
	/* System info */
	[xmlString appendFormat:@"Date/Time:       %s\n", [[report.systemInfo.timestamp description] UTF8String]];
    NSString *buildNumber = [self _getOSVersionBuild];
    if (buildNumber) {
        [xmlString appendFormat:@"OS Version:      %s %s (%s)\n", osName, [report.systemInfo.operatingSystemVersion UTF8String], [buildNumber UTF8String]];
    } else {
        [xmlString appendFormat:@"OS Version:      %s %s\n", osName, [report.systemInfo.operatingSystemVersion UTF8String]];
    }
	[xmlString appendString:@"Report Version:  104\n"];
	
	[xmlString appendString:@"\n"];
	
	/* Exception code */
	[xmlString appendFormat:@"Exception Type:  %s\n", [report.signalInfo.name UTF8String]];
    [xmlString appendFormat:@"Exception Codes: %@ at 0x%" PRIx64 "\n", report.signalInfo.code, report.signalInfo.address];
	
    for (PLCrashReportThreadInfo *thread in report.threads) {
        if (thread.crashed) {
            [xmlString appendFormat: @"Crashed Thread:  %ld\n", (long) thread.threadNumber];
            break;
        }
    }
	
	[xmlString appendString:@"\n"];
	
    if (report.hasExceptionInfo) {
        [xmlString appendString:@"Application Specific Information:\n"];
        [xmlString appendFormat: @"*** Terminating app due to uncaught exception '%@', reason: '%@'\n",
         report.exceptionInfo.exceptionName, report.exceptionInfo.exceptionReason];
        [xmlString appendString:@"\n"];
    }
    
	/* Threads */
    PLCrashReportThreadInfo *crashed_thread = nil;
    for (PLCrashReportThreadInfo *thread in report.threads) {
        if (thread.crashed) {
            [xmlString appendFormat: @"Thread %ld Crashed:\n", (long) thread.threadNumber];
            crashed_thread = thread;
        } else {
            [xmlString appendFormat: @"Thread %ld:\n", (long) thread.threadNumber];
        }
        for (NSUInteger frame_idx = 0; frame_idx < [thread.stackFrames count]; frame_idx++) {
            PLCrashReportStackFrameInfo *frameInfo = [thread.stackFrames objectAtIndex: frame_idx];
            PLCrashReportBinaryImageInfo *imageInfo;
            
            /* Base image address containing instrumention pointer, offset of the IP from that base
             * address, and the associated image name */
            uint64_t baseAddress = 0x0;
            uint64_t pcOffset = 0x0;
            NSString *imageName = @"\?\?\?";
            
            imageInfo = [report imageForAddress: frameInfo.instructionPointer];
            if (imageInfo != nil) {
                imageName = [imageInfo.imageName lastPathComponent];
                baseAddress = imageInfo.imageBaseAddress;
                pcOffset = frameInfo.instructionPointer - imageInfo.imageBaseAddress;
            }
            
            [xmlString appendFormat: @"%-4ld%-36s0x%08" PRIx64 " 0x%" PRIx64 " + %" PRId64 "\n", 
             (long) frame_idx, [imageName UTF8String], frameInfo.instructionPointer, baseAddress, pcOffset];
        }
        [xmlString appendString: @"\n"];
    }
    
    /* Registers */
    if (crashed_thread != nil) {
        [xmlString appendFormat: @"Thread %ld crashed with %@ Thread State:\n", (long) crashed_thread.threadNumber, codeType];
        
        int regColumn = 1;
        for (PLCrashReportRegisterInfo *reg in crashed_thread.registers) {
            NSString *reg_fmt;
            
            /* Use 32-bit or 64-bit fixed width format for the register values */
            if (lp64)
                reg_fmt = @"%6s:\t0x%016" PRIx64 " ";
            else
                reg_fmt = @"%6s:\t0x%08" PRIx64 " ";
            
            [xmlString appendFormat: reg_fmt, [reg.registerName UTF8String], reg.registerValue];
            
            if (regColumn % 4 == 0)
                [xmlString appendString: @"\n"];
            regColumn++;
        }
        
        if (regColumn % 3 != 0)
            [xmlString appendString: @"\n"];
        
        [xmlString appendString: @"\n"];
    }
	
	/* Images */
	[xmlString appendFormat:@"Binary Images:\n"];
	
    for (PLCrashReportBinaryImageInfo *imageInfo in report.images) {
		NSString *uuid;
		/* Fetch the UUID if it exists */
		if (imageInfo.hasImageUUID)
			uuid = imageInfo.imageUUID;
		else
			uuid = @"???";
		
        NSString *device = @"\?\?\? (\?\?\?)";
        
#ifdef _ARM_ARCH_7 
        device = @"armv7";
#else
        device = @"armv6";
#endif
        
		/* base_address - terminating_address file_name identifier (<version>) <uuid> file_path */
		[xmlString appendFormat:@"0x%" PRIx64 " - 0x%" PRIx64 "  %@ %@ <%@> %@\n",
		 imageInfo.imageBaseAddress,
		 imageInfo.imageBaseAddress + imageInfo.imageSize,
		 [imageInfo.imageName lastPathComponent],
		 device,
		 uuid,
		 imageInfo.imageName];
	}
	
	return xmlString;
}

- (void)_checkForFeedbackStatus {
   	NSMutableURLRequest *request = nil;
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api/2/apps/%@/crashes/%@",
                                                                        self.submissionURL,
                                                                        [self.appIdentifier stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                                        _feedbackRequestID
                                                                        ]
                                                   ]];
    
	[request setCachePolicy: NSURLRequestReloadIgnoringLocalCacheData];
	[request setValue:@"Quincy/iOS" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
	[request setTimeoutInterval: 15];
	[request setHTTPMethod:@"GET"];
    
	_serverResult = CrashReportStatusUnknown;
	_statusCode = 200;
	
	// Release when done in the delegate method
	_responseData = [[NSMutableData alloc] init];
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(connectionOpened)]) {
		[self.delegate connectionOpened];
	}
	
	_urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];    
}

- (void)_postXML:(NSString*)xml toURL:(NSURL*)url {
	NSMutableURLRequest *request = nil;
    NSString *boundary = @"----FOO";

    if (self.appIdentifier) {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api/2/apps/%@/crashes",
                                                                            self.submissionURL,
                                                                            [self.appIdentifier stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                                            ]
                                                       ]];
    } else {
        request = [NSMutableURLRequest requestWithURL:url];
    }
		
	[request setCachePolicy: NSURLRequestReloadIgnoringLocalCacheData];
	[request setValue:@"Quincy/iOS" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
	[request setTimeoutInterval: 15];
	[request setHTTPMethod:@"POST"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request setValue:contentType forHTTPHeaderField:@"Content-type"];
	
	NSMutableData *postBody =  [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    if (self.appIdentifier) {
        [postBody appendData:[@"Content-Disposition: form-data; name=\"xml\"; filename=\"crash.xml\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Type: text/xml\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [postBody appendData:[@"Content-Disposition: form-data; name=\"xmlstring\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	}
    [postBody appendData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postBody];
	
	_serverResult = CrashReportStatusUnknown;
	_statusCode = 200;
	
	//Release when done in the delegate method
	_responseData = [[NSMutableData alloc] init];
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(connectionOpened)]) {
		[self.delegate connectionOpened];
	}
	
	_urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!_urlConnection) {
        _sendingInProgress = NO;
    }
}

#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
		_statusCode = [(NSHTTPURLResponse *)response statusCode];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[_responseData release];
	_responseData = nil;
	[connection autorelease];
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(connectionClosed)]) {
		[self.delegate connectionClosed];
	}
    
    _sendingInProgress = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if (_statusCode >= 200 && _statusCode < 400) {
        [self _cleanCrashReports];
        
        if (self.appIdentifier) {
            // HockeyApp uses PList XML format
            NSMutableDictionary *response = [NSPropertyListSerialization propertyListFromData:_responseData
                                                                             mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                                       format:nil
                                                                             errorDescription:NULL];
            _serverResult = (CrashReportStatus)[[response objectForKey:@"status"] intValue];
            _feedbackRequestID = [[NSString alloc] initWithString:[response objectForKey:@"id"]];
            _feedbackDelayInterval = [[response objectForKey:@"delay"] floatValue];
            if (_feedbackDelayInterval > 0)
                _feedbackDelayInterval *= 0.01;            
        } else {
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:_responseData];
            // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
            [parser setDelegate:self];
            // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
            [parser setShouldProcessNamespaces:NO];
            [parser setShouldReportNamespacePrefixes:NO];
            [parser setShouldResolveExternalEntities:NO];
        
            [parser parse];
            
            [parser release];
        }
        
        if ([self isFeedbackActivated]) {
            if (self.appIdentifier) {
                // only proceed if the server did not report any problem
                if (_serverResult == CrashReportStatusQueued) {
                    // the report is still in the queue
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_checkForFeedbackStatus) object:nil];
                    [self performSelector:@selector(_checkForFeedbackStatus) withObject:nil afterDelay:_feedbackDelayInterval];
                } else {
                    // we do have a status, show it if needed
                    [self showCrashStatusMessage];
                }
            } else {
                [self showCrashStatusMessage];
            }
        }
	}
	
	[_responseData release];
	_responseData = nil;
	[connection autorelease];
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(connectionClosed)]) {
		[self.delegate connectionClosed];
	}
    
    _sendingInProgress = NO;
}

#pragma mark PLCrashReporter

//
// Called to handle a pending crash report.
//
- (void) handleCrashReport {
	PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
	NSError *error = NULL;
	
    // check if the next call ran successfully the last time
	if (_analyzerStarted == 0) {
		// mark the start of the routine
		_analyzerStarted = 1;
		[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:_analyzerStarted] forKey:kQuincyKitAnalyzerStarted];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
        // Try loading the crash report
        _crashData = [[NSData alloc] initWithData:[crashReporter loadPendingCrashReportDataAndReturnError: &error]];
	
        NSString *cacheFilename = [NSString stringWithFormat: @"%.0f", [NSDate timeIntervalSinceReferenceDate]];
	
        if (_crashData == nil) {
            NSLog(@"Could not load crash report: %@", error);
        } else {
            [_crashData writeToFile:[_crashesDir stringByAppendingPathComponent: cacheFilename] atomically:YES];
		}
	}
	
	// Purge the report
	// mark the end of the routine
	_analyzerStarted = 0;
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:_analyzerStarted] forKey:kQuincyKitAnalyzerStarted];
    [[NSUserDefaults standardUserDefaults] synchronize];

	[crashReporter purgePendingCrashReport];
	return;
}


@end
