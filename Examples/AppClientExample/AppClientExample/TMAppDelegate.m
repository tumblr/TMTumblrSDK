//
//  TMAppDelegate.m
//  AppClientExample
//
//  Created by Bryan Irace on 3/19/13.
//  Copyright (c) 2013 Bryan Irace. All rights reserved.
//

#import "TMAppDelegate.h"

#import "TMAppClientExampleController.h"

@implementation TMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:
                                      [[TMAppClientExampleController alloc] init]];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *host = url.host;
    
    BOOL success = [host isEqualToString:@"success"];
    BOOL cancelled = [host isEqualToString:@"cancelled"];
    
    if (success || cancelled) {
        [[[UIAlertView alloc] initWithTitle:success ? @"Posted to Tumblr" : @"Tumblr post cancelled"
                                    message:success ? @"Your post was successful" : @"Your post was cancelled"
                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
        return YES;
    }
    
    return NO;
}

@end
