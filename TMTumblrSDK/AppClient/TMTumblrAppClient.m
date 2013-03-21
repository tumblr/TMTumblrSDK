//
//  TMTumblrAppClient.m
//  TumblrAppClient
//
//  Created by Bryan Irace on 11/24/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

#import "TMTumblrAppClient.h"

#import <UIKit/UIKit.h>

@implementation TMTumblrAppClient

- (instancetype)init {
    return [self initWithURLScheme:@"tumblr"];
}

- (void)viewInAppStore {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/tumblr/id305343404?mt=8"]];
}

- (void)viewDashboard {
    [self performAction:@"dashboard"];
}

- (void)viewTag:(NSString *)tag {
    [self performAction:@"tag" parameters:@{ @"tag" : tag }];
}

- (void)viewBlog:(NSString *)blogName {
    [self performAction:@"blog" parameters:@{ @"blogName" : blogName }];
}

- (void)viewPost:(NSString *)postID blogName:(NSString *)blogName {
    [self performAction:@"blog" parameters:@{ @"blogName" : blogName, @"postID" : postID }];
}

@end
