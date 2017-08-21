//
//  TMAPIClientCallbackConverter.h
//  Pods
//
//  Created by Kenny Ackerson on 5/3/16.
//
//

#import <Foundation/Foundation.h>
#import "TMURLSession.h"
#import "TMAPIClient.h"

/**
 * Responsible for converting @c TMAPIClientCallback to a @c TMURLSessionRequestCompletionHandler.
 *
 * This wraps the call to the @c TMAPIClientCallback in a @c TMURLSessionRequestCompletionHandler and handles parsing via @c TMResponseParser.
 *
 * This is what is internally used by TMAPIClient.
 *
 * Why is this important and broken out of the APIClient:
 *
 * 1. Session s take a @c TMURLSessionRequestCompletionHandler but most clients want structured JSON back - so this does the parsing
 *    with @c TMResponseParser. 
 * 2. Some clients dont use the API client - this allows us to get the response parsing and error handling everywhere if 
 *    we choose by using this class (code reuse).
 *
 */
__attribute__((objc_subclassing_restricted))
@interface TMAPIClientCallbackConverter : NSObject

/**
 *  Initializes an instance of @c TMAPIClientCallbackConverter.
 *
 *  @param callback      The callback block to convert to a session completion handler.
 *
 *  @return A newly initialized instance of @c TMAPIClientCallbackConverter.
 */
- (nonnull instancetype)initWithCallback:(nonnull TMAPIClientCallback)callback;

/**
 *  This creates a completion handler that can be passed into the @c TMURLSession.
 *
 *  @return A completion handler that can be passed into the @c TMURLSession
 */
- (nonnull TMURLSessionRequestCompletionHandler)completionHandler;

@end
