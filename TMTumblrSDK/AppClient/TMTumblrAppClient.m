//
//  TMTumblrAppClient.m
//  TumblrAppClient
//
//  Created by Bryan Irace on 11/24/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMTumblrAppClient.h"

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

- (void)createTextPost:(NSString *)title body:(NSString *)body {
    [self performAction:@"text" parameters:@{ @"title" : title, @"body" : body }];
}

- (void)createQuotePost:(NSString *)quote source:(NSString *)source {
    [self performAction:@"quote" parameters:@{ @"quote" : quote, @"source" : source }];
}

- (void)createLinkPost:(NSString *)title URL:(NSString *)URL description:(NSString *)description {
    [self performAction:@"link" parameters:@{ @"title" : title, @"url" : URL, @"description" : description }];
}

- (void)createChatPost:(NSString *)title body:(NSString *)body {
    [self performAction:@"chat" parameters:@{ @"title" : title, @"body" : body }];
}

@end
