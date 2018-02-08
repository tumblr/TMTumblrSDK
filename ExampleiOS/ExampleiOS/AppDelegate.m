//
//  AppDelegate.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 1/6/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import "AppDelegate.h"
#import <TMTumblrSDK/TMOAuthAuthenticator.h>
#import <TMTumblrSDK/TMURLSession.h>
#import "ViewController.h"
#import "TMOAuthAuthenticatorDelegate.h"

@interface AppDelegate () <TMOAuthAuthenticatorDelegate>

@property TMOAuthAuthenticator *authenticator;
@property TMURLSession *session;
@property TMAPIApplicationCredentials *applicationCredentials;

@end

/*
 If you don't already have a consumer key/secret you can
 register at http://www.tumblr.com/oauth/apps
 */
NSString * const OAuthTokenConsumerKey = @"";
NSString * const ConsumerSecret = @"";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.applicationCredentials = [[TMAPIApplicationCredentials alloc] initWithConsumerKey:OAuthTokenConsumerKey consumerSecret:ConsumerSecret];

    self.session = [[TMURLSession alloc] initWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                        applicationCredentials:self.applicationCredentials
                                               userCredentials:[TMAPIUserCredentials new]
                                        networkActivityManager:nil
                                     sessionTaskUpdateDelegate:nil
                                        sessionMetricsDelegate:nil
                                            requestTransformer:nil
                                             additionalHeaders:nil];

    self.authenticator = [[TMOAuthAuthenticator alloc] initWithSession:self.session
                                                applicationCredentials:self.applicationCredentials
                                                              delegate:self];

    ViewController *vc = [[ViewController alloc] initWithSession:self.session authenticator:self.authenticator];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [self.authenticator handleOpenURL:url];
    return YES;
}

#pragma mark - TMOAuthAuthenticatorDelegate

- (void)openURLInBrowser:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end
