//
//  TMAppDelegate.m
//  PhotoPostExample
//
//  Created by Bryan Irace on 5/19/13.
//  Copyright (c) 2013 Bryan Irace. All rights reserved.
//

#import "TMAppDelegate.h"

#import "TMPhotoPostController.h"
#import "TMAPIClient.h"

@implementation TMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[TMPhotoPostController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - URL Scheme

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[TMAPIClient sharedInstance] handleOpenURL:url];
}

@end
