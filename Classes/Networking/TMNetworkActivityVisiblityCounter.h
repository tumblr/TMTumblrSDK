//
//  TMNetworkActivityVisiblityCounter.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/7/16.
//
//

#import <Foundation/Foundation.h>
#import "TMNetworkActivityIndicatorManager.h"
#import "TMURLSessionTaskState.h"

/**
 * An object that can calculate whether or not the network activity indicator should be shown.
 */
__attribute__((objc_subclassing_restricted))
@interface TMNetworkActivityVisiblityCounter : NSObject

/**
 *  Initializes an instance of `TMNetworkActivityVisiblityCounter`.
 *
 *  @param networkActivityIndicatorManager An object that can handle.
 *
 *  @return A newly initialized instance of `TMNetworkActivityVisiblityCounter`.
 */
- (nonnull instancetype)initWithNetworkActivityIndicatorManager:(nonnull id <TMNetworkActivityIndicatorManager>)networkActivityIndicatorManager;

/**
 *  Updates the counter with a state.
 *
 *  @param state The state to update this counter with.
 */
- (void)update:(TMURLSessionTaskState)state;

/**
 *  The count of active tasks.
 */
@property (nonatomic, readonly) NSInteger activeCount;

@end
