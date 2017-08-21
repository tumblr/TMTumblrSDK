//
//  TMAuthTokenRequestGenerator.h
//  Pods
//
//  Created by Tyler Tape on 5/4/17.
//
//

#import <Foundation/Foundation.h>
#import <TMTumblrSDK/TMHTTPRequest.h>

/**
 Generates a request for the auth token required by the OAuth flow
 */
__attribute__((objc_subclassing_restricted))
@interface TMAuthTokenRequestGenerator : NSObject

/**
 Designated initializer

 @param urlScheme The URL scheme that your app will use to handle auth callbacks
 @return An instance of TMAuthTokenRequestGenerator
 */
- (instancetype)initWithURLScheme:(NSString *)urlScheme;

/**
 Returns a correctly formatted request for the auth token required by the OAuth flow

 @return A request for an auth token
 */
- (TMHTTPRequest *)authTokenRequest;

@end
