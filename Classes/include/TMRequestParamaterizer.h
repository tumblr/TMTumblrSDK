//
//  TMRequestParamaterizer.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 3/30/16.
//
//

#import <Foundation/Foundation.h>

@class TMAPIApplicationCredentials;
@class TMAPIUserCredentials;

@protocol TMRequest;

// This is a class that is responsible for signing requests and parameterizing them (setting up query params, and http bodies).
__attribute__((objc_subclassing_restricted))
@interface TMRequestParamaterizer : NSObject

/**
 *  Initializes an instance of @c TMRequestParamaterizer.
 *
 *  @param applicationCredentials The application credentials to use when parameterizing a request.
 *  @param userCredentials        The user credentials to use when signing a request.
 *  @param request                The request to paramaterize and sign.
 *
 *  @return A newly initialized instance of @c TMRequestParamaterizer.
 */
- (nonnull instancetype)initWithApplicationCredentials:(nullable TMAPIApplicationCredentials *)applicationCredentials
                                       userCredentials:(nullable TMAPIUserCredentials *)userCredentials
                                               request:(nonnull id <TMRequest>)request
                                     additionalHeaders:(nullable NSDictionary<NSString *, NSString *> *)additionalHeaders;

/**
 *  Parameterizes and signs a request.
 *
 *  @param request The request to parameterize and sign.
 *
 *  @return A new URL request that is fully parameterized and signed.
 */
- (nonnull NSURLRequest *)URLRequestWithRequest:(nonnull id <TMRequest>)request;

@end
