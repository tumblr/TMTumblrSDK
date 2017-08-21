//
//  TMAPIUserCredentials.h
//  TMTumblrSDK
//
//  Created by Bryan Irace on 4/1/15.
//  Copyright (c) 2015 Tumblr. All rights reserved.
//

/**
 *  Model object representing a Tumblr API application user’s credentials (OAuth token and token secret).
 */
__attribute__((objc_subclassing_restricted))
@interface TMAPIUserCredentials : NSObject

/**
 *  OAuth token required to communicate with the Tumblr API.
 */
@property (nonatomic, copy, nullable, readonly) NSString *token;

/**
 *  OAuth token secret to communicate with the Tumblr API.
 */
@property (nonatomic, copy, nullable, readonly) NSString *tokenSecret;

/**
 *  Determines if this object has valid credentials.
 *
 *  @return Whether or not the credentials contained in this object are valid.
 */
- (BOOL)validCredentials;

/**
 *  Initialize an API user credentials instance.
 *
 *  @param token       Tumblr API OAuth token.
 *  @param tokenSecret Tumblr API OAuth token secret.
 *
 *  @return The new credentials instance.
 */
- (nonnull instancetype)initWithToken:(nullable NSString *)token tokenSecret:(nullable NSString *)tokenSecret NS_DESIGNATED_INITIALIZER;

@end
