//
//  TMOAuthAuthenticatorDelegate.h
//  Pods
//
//  Created by Tyler Tape on 4/12/17.
//
//

#import <Foundation/Foundation.h>

/**
 Delegate protocol providing hooks for displaying necessary UI to complete the OAuth flow
 */
@protocol TMOAuthAuthenticatorDelegate <NSObject>

/**
 Called by the authenticator with a URL directing the user to a webpage where they can complete the OAuth flow

 @param url the URL of a webpage where the user can grant permissions to this app and finish authenticating
 */
- (void)openURLInBrowser:(NSURL *)url;

@end
