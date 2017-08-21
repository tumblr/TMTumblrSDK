//
//  TMXAuthAuthenticator.h
//  TumblrAuthentication
//
//  Created by Kenny Ackerson on 4/1/16.
//  Copyright (c) 2016 Tumblr. All rights reserved.
//

@import Foundation;
#import "TMAuthenticationCallback.h"

@protocol TMSession;

/**
 Provides xAuth implementations for authenticating with the Tumblr API.
 */
__attribute__((objc_subclassing_restricted))
@interface TMXAuthAuthenticator : NSObject

/**
 *  Initializes an instance of @c TMXAuthAuthenticator.
 *
 *  @param session                  The session object to communicate with the API with.
 *
 *  @return A newly initialized instance of @c TMXAuthAuthenticator.
 */
- (nonnull instancetype)initWithSession:(nonnull id <TMSession>)session;

/**
 Authenticate via xAuth.

 Please note that xAuth access [must be specifically requested](http://www.tumblr.com/oauth/apps) for your application.
 */
- (nonnull NSURLSessionTask *)xAuth:(nonnull NSString *)emailAddress password:(nonnull NSString *)password callback:(nonnull TMAuthenticationCallback)callback;

/**
 *  Authenticates via xAuth.
 *
 *  Please note that xAuth access [must be specifically requested](http://www.tumblr.com/oauth/apps) for your application.
 *
 *  @param emailAddress The email address of the user.
 *  @param password     The password of the user.
 *  @param authToken    An optional authentication token for the user.
 *  @param callback     The callback block for the xAuth request.
 */
- (nonnull NSURLSessionTask *)xAuth:(nonnull NSString *)emailAddress
                           password:(nonnull NSString *)password
                          authToken:(nullable NSString *)authToken
                           callback:(nonnull TMAuthenticationCallback)callback;

@end
