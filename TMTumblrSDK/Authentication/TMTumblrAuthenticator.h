//
//  TMTumblrAuthenticator.h
//  TumblrAuthentication
//
//  Created by Bryan Irace on 11/19/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

typedef void (^TMAuthenticationCallback)(NSString *, NSString *, NSError *);

/**
 Provides three-legged OAuth and xAuth implementations for authenticating with the Tumblr API.
 */
@interface TMTumblrAuthenticator : NSObject

/// OAuth consumer key. Must be set prior to authenticating or making any API requests.
@property (nonatomic, copy) NSString *OAuthConsumerKey;

/// OAuth consumer key. Must be set prior to authenticating or making any API requests.
@property (nonatomic, copy) NSString *OAuthConsumerSecret;

+ (TMTumblrAuthenticator *)sharedInstance;

/**
 Authenticate via xAuth.
 
 Please note that xAuth access [must be specifically requested](http://www.tumblr.com/oauth/apps) for your application.
 */
- (void)xAuth:(NSString *)emailAddress password:(NSString *)password callback:(TMAuthenticationCallback)callback;

@end
