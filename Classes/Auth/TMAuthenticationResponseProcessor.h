//
//  TMAuthenticationResponseProcessor.h
//  Pods
//
//  Created by Kenny Ackerson on 6/14/16.
//
//

#import <Foundation/Foundation.h>
#import "TMXAuthAuthenticator.h"
#import "TMURLSessionCallbacks.h"

/**
 * Processes a response for the Tumblr API authentication route.
 *
 * Basically just encapsulates the logic that goes around error checking and response parsing for the route.
 */
__attribute__((objc_subclassing_restricted))
@interface TMAuthenticationResponseProcessor : NSObject

/**
 *  Initializes a new instance of `TMAuthenticationResponseProcessor`.
 *
 *  @param callback A callback to call in the block `sessionCompletionBlock`.
 *
 *  @return An initialized instance of `TMAuthenticationResponseProcessor`.
 */
- (nonnull instancetype)initWithCallback:(nonnull TMAuthenticationCallback)callback;

/**
 *  Makes a `TMURLSessionRequestCompletionHandler` that calls the callback block.
 *
 *  @return A block that calls the callback block that was passed into this object.
 */
- (nonnull TMURLSessionRequestCompletionHandler)sessionCompletionBlock;

@end
