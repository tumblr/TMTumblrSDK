//
//  TMTumblrAuthenticator.h
//  TumblrAuthentication
//
//  Created by Bryan Irace on 11/19/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

typedef void (^TMAuthenticationCallback)(NSString *, NSString *, NSError *);

@interface TMTumblrAuthenticator : NSObject

@property (nonatomic, copy) NSString *OAuthConsumerKey;
@property (nonatomic, copy) NSString *OAuthConsumerSecret;

+ (TMTumblrAuthenticator *)sharedInstance;

- (void)authenticate:(NSString *)URLScheme callback:(TMAuthenticationCallback)callback;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)xAuth:(NSString *)emailAddress password:(NSString *)password callback:(TMAuthenticationCallback)callback;

@end
