//
//  TMOAuthAuthenticator.h
//  Pods
//
//  Created by Tyler Tape on 4/12/17.
//
//

@import Foundation;
#import "TMAPIApplicationCredentials.h"
#import "TMAuthenticationCallback.h"
#import "TMOAuthAuthenticatorDelegate.h"
@protocol TMSession;

/**
 Provides three-legged OAuth implementations for authenticating with the Tumblr API.
 */
__attribute__((objc_subclassing_restricted))
@interface TMOAuthAuthenticator : NSObject

/**
 *  Designated initializer.
 *
 *  @param session                  The session object to communicate with the API with.
 *  @param applicationCredentials   Credentials needed to request oauth tokens.
 *  @param delegate                 An object capable of launching a web browser to a specified URL
 *
 *  @return A newly initialized instance of @c TMOAuthAuthenticator.
 */
- (nonnull instancetype)initWithSession:(nonnull id <TMSession>)session
                 applicationCredentials:(nonnull TMAPIApplicationCredentials *)applicationCredentials
                               delegate:(nonnull id <TMOAuthAuthenticatorDelegate>)delegate;

/**
 Authenticate via three-legged OAuth.

 Your `TMOAuthAuthenticator` instance's `handleOpenURL:` method must also be called from your `UIApplicationDelegate`'s
 `application:openURL:sourceApplication:annotation:` method in order to receive the tokens.

 @param URLScheme a URL scheme that your application can handle requests to.
 */
- (void)authenticate:(nonnull NSString *)URLScheme callback:(nullable TMAuthenticationCallback)callback;

/**
 Authenticate via three-legged OAuth. This should be called from your `UIApplicationDelegate`'s
 `application:openURL:sourceApplication:annotation:` method in order to receive the tokens.

 This method is the last part of the authentication flow started by calling `authenticate:callback:`
 */
- (BOOL)handleOpenURL:(nonnull NSURL *)url;

@end
