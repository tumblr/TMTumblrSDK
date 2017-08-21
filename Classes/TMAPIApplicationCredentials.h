//
//  TMTumblrAppCredentials.h
//  TMTumblrSDK
//
//  Created by Bryan Irace on 9/22/14.
//  Copyright (c) 2014 Tumblr. All rights reserved.
//

/**
 *  Model object reprenting a Tumblr API application’s credentials (OAuth consumer key and secret).
 */
__attribute__((objc_subclassing_restricted))
@interface TMAPIApplicationCredentials : NSObject

/**
 *  OAuth consumer key required to communicate with the Tumblr API.
 */
@property (nonatomic, copy, nonnull, readonly) NSString *consumerKey;

/**
 *  OAuth consumer secret required to communicate with the Tumblr API.
 */
@property (nonatomic, copy, nonnull, readonly) NSString *consumerSecret;

/**
 *  Calculates if these credentials are valid.
 *
 *  @return Whether or not these credentials are valid.
 */
- (BOOL)validCredentials;

/**
 *  Unavailable.
 *
 *  @return Undetermined.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 *  Initialize an API application credentials instance.
 *
 *  @param consumerKey    (Required) Tumblr API OAuth consumer key.
 *  @param consumerSecret (Required) Tumblr API OAuth consumer secret.
 *
 *  @return The new credentials instance.
 */
- (nonnull instancetype)initWithConsumerKey:(nonnull NSString *)consumerKey
                             consumerSecret:(nonnull NSString *)consumerSecret NS_DESIGNATED_INITIALIZER;

@end
