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

// Get the shared instance of the Authenticator
+ (TMTumblrAuthenticator *)sharedInstance;

// Authenticate using the given URLScheme for this app
- (void)authenticate:(NSString *)URLScheme callback:(TMAuthenticationCallback)callback;

// Handle open for OAuth url
- (BOOL)handleOpenURL:(NSURL *)url;

// Perform xAuth with a |username| and |password| and hit a
// TMAuthenticationCallback with the result
- (void)xAuth:(NSString *)emailAddress password:(NSString *)password callback:(TMAuthenticationCallback)callback;

@end
