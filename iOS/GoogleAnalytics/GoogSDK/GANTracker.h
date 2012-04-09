//
//  GANTracker.h
//  Google Analytics iOS SDK
//  Version: 1.4
//
//  Copyright 2009 Google Inc. All rights reserved.
//

// Error constants
extern NSString* const kGANTrackerErrorDomain;

typedef enum {
  // This error code is returned when input to a method is incorrect.
  kGANTrackerInvalidInputError = 0xbade7a9,

  // This error code is returned when the number of hits generated in a session
  // exceeds the limit (currently 500).
  kGANTrackerEventsPerSessionLimitError = 0xbad5704e,

  // This error code is returned if the method called requires that the tracker
  // be started.
  kGANTrackerNotStartedError = 0xbada55,

  // This error code is returned if the method call resulted in some sort of
  // database error.
  kGANTrackerDatabaseError = 0xbadbaddb
} GANErrorCode;

// Custom Variable constants
#define kGANMaxCustomVariables 5
#define kGANMaxCustomVariableLength 64

typedef enum {
  kGANVisitorScope = 1U,
  kGANSessionScope = 2U,
  kGANPageScope = 3U
} GANCVScope;

@protocol GANTrackerDelegate;
typedef struct __GANTrackerPrivate GANTrackerPrivate;

// Google Analytics tracker interface. Tracked pageviews and events are stored
// in a persistent store and dispatched in the background to the server.
@interface GANTracker : NSObject {
 @private
  GANTrackerPrivate *private_;
  BOOL debug_;
  BOOL dryRun_;
  BOOL anonymizeIp_;
  NSUInteger sampleRate_;
}

// If the debug flag is set, debug messages will be written to the log.
// It is useful for debugging calls to the Google Analytics SDK.
// By default, the debug flag is disabled.
@property(readwrite) BOOL debug;

// If the dryRun flag is set, hits will not be sent to Google Analytics.
// It is useful for testing and debugging calls to the Google Analytics SDK.
// By default, the dryRun flag is disabled.
@property(readwrite) BOOL dryRun;

// If the anonymizeIp flag is set, the SDK will anonymize information sent to
// Google Analytics by setting the last octet of the IP address to zero prior
// to its storage and/or submission.
// By default, the anonymizeIp flag is disabled.
@property(readwrite) BOOL anonymizeIp;

// The sampleRate parameter controls the probability that the visitor will be
// sampled. When a visitor is not sampled, no data is submitted to Google
// Analytics about that visitor's activity. If your application is subject to
// heavy traffic spikes, you may wish to adjust the sample rate to ensure
// uninterrupted report tracking. Sampling in Google Analytics occurs
// consistently across unique visitors, ensuring integrity in trending and
// reporting even when sampling is enabled, because unique visitors remain
// included or excluded from the sample, as set from the initiation of
// sampling.
//
// By default, sampleRate is 100, which signifies no sampling. sampleRate may
// be set to any integer value between 0 and 100, inclusive. A value of 90
// requests 90% of visitors to be sampled (10% of visitors to be sampled out).
@property(readwrite) NSUInteger sampleRate;

// Singleton instance of this class for convenience.
+ (GANTracker *)sharedTracker;

// Start the tracker with the specified Google Analytics account ID (the string
// that begins with "UA-") and desired automatic dispatch period (in seconds).
// The dispatcher will dispatch events, if any, every |dispatchPeriod| seconds.
// If a non-positive (e.g. 0 or -1) dispatch period is given, automatic
// dispatch will not be enabled, and the application will need to dispatch
// events manually. An optional delegate may be supplied.
- (void)startTrackerWithAccountID:(NSString *)accountID
                   dispatchPeriod:(NSInteger)dispatchPeriod
                         delegate:(id<GANTrackerDelegate>)delegate;

// Stop the tracker.
- (void)stopTracker;

// Track a page view. Returns YES on success or NO on error (with |error|
// set to the specific error, or nil). You may pass NULL for |error| if you
// don't care about the error.  Note that trackPageview will prepend a '/'
// character if pageURL doesn't start with one.
- (BOOL)trackPageview:(NSString *)pageURL
            withError:(NSError **)error;

// Track an event. The category and action are required. The label and
// value are optional (specify nil for no label and -1 or any negative integer
// for no value). Returns YES on success or NO on error (with |error|
// set to the specific error, or nil). You may pass NULL for |error| if you
// don't care about the error.
- (BOOL)trackEvent:(NSString *)category
            action:(NSString *)action
             label:(NSString *)label
             value:(NSInteger)value
         withError:(NSError **)error;

// Set a custom variable. visitor and session scoped custom variables are stored
// for later use.  Session and page scoped custom variables are attached to each
// event.  Visitor scoped custom variables are sent only on the first event for
// a session. Returns YES on success or NO on error (with |error|
// set to the specific error, or nil). You may pass NULL for |error| if you
// don't care about the error.
- (BOOL)setCustomVariableAtIndex:(NSUInteger)index
                            name:(NSString *)name
                           value:(NSString *)value
                           scope:(GANCVScope)scope
                       withError:(NSError **)error;

// Set a page scoped custom variable.  The variable set is returned with the
// next event only.  It will overwrite any existing visitor or session scoped
// custom variables. Returns YES on success or NO on error (with |error|
// set to the specific error, or nil). You may pass NULL for |error| if you
// don't care about the error.
- (BOOL)setCustomVariableAtIndex:(NSUInteger)index
                            name:(NSString *)name
                           value:(NSString *)value
                       withError:(NSError **)error;

// Returns the value of the custom variable at the index requested.  Returns
// nil if no variable is found or index is out of range.
- (NSString *)getVisitorCustomVarAtIndex:(NSUInteger)index;

// Add a transaction to the Ecommerce buffer.  If a transaction with an orderId
// of orderID is already present, it will be replaced by a new one. All
// transactions and all the items in the buffer will be queued for dispatch once
// trackTransactions is called.  Returns YES on success or NO on error
// (with |error| set to the specific error, or nil). You may pass NULL for
// |error| if you don't care about the error.
- (BOOL)addTransaction:(NSString *)orderID
            totalPrice:(double)totalPrice
             storeName:(NSString *)storeName
              totalTax:(double)totalTax
          shippingCost:(double)shippingCost
             withError:(NSError **)error;

// Add an item to the Ecommerce buffer for the transaction whose orderId matches
// the input parameter orderID.  If no transaction exists, one will be created.
// If an item with the same itemSKU exists, it will be replaced with a new item.
// All the transactions and items in the Ecommerce buffer will be queued for
// dispatch once trackTransactions is called.  Returns YES on success or NO on
// error (with |error| set to the specific error, or nil). You may pass NULL
// for |error| if you don'tcare about the error.
- (BOOL)addItem:(NSString *)orderID
        itemSKU:(NSString *)itemSKU
      itemPrice:(double)itemPrice
      itemCount:(double)itemCount
       itemName:(NSString *)itemName
   itemCategory:(NSString *)itemCategory
      withError:(NSError **)error;

// Tracks all the Ecommerce hits pending in the Ecommerce buffer.
// Returns YES on success or NO on error (with |error|
// set to the specific error, or nil). You may pass NULL for |error| if you
// don't care about the error.
- (BOOL)trackTransactions:(NSError **)error;

// Clears out the buffer of pending Ecommerce hits without sending them.
// Returns YES on success or NO on error (with |error|
// set to the specific error, or nil). You may pass NULL for |error| if you
// don't care about the error.
- (BOOL)clearTransactions:(NSError **)error;

// Sets the campaign to the input parameter referrer. All hits going forward
// will have this campaign attached.  Note that calling setReferrer will trigger
// a new session.
- (BOOL)setReferrer:(NSString *)referrer withError:(NSError **)error;

// Manually dispatch pageviews/events to the server. Returns YES if
// a new dispatch starts.
- (BOOL)dispatch;

// Manually dispatch pageviews/events to the server synchronously until timeout
// time has elapsed.  Returns YES upon completion if there were hits to send and
// all hits were sent successfully. Call this method with care as it will block
// all GANTracker activity until it is done.
- (BOOL)dispatchSynchronous:(NSTimeInterval)timeout;

@end

@protocol GANTrackerDelegate <NSObject>

// Invoked when a hit has been dispatched.
- (void)hitDispatched:(NSString *)hitString;

// Invoked when a dispatch completes. Reports the number of hits
// dispatched and the number of hits that failed to dispatch. Failed
// hits will be retried on next dispatch.
- (void)trackerDispatchDidComplete:(GANTracker *)tracker
                  eventsDispatched:(NSUInteger)hitsDispatched
              eventsFailedDispatch:(NSUInteger)hitsFailedDispatch;

@end
