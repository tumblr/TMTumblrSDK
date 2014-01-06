//
//  TMTumblrAppClient.m
//  TumblrAppClient
//
//  Created by Bryan Irace on 11/24/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

#import "TMTumblrAppClient.h"

#import <UIKit/UIKit.h>
#import "TMSDKFunctions.h"

@implementation TMTumblrAppClient

+ (BOOL)isTumblrInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tumblr://"]];
}

+ (void)viewInAppStore {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/tumblr/id305343404"]];
}

+ (void)viewDashboard {
    [self performAction:@"dashboard" parameters:nil];
}

+ (void)viewTag:(NSString *)tag {
    if (tag) {
        [self performAction:@"tag" parameters:@{ @"tag" : tag }];
    }
}

+ (void)viewBlog:(NSString *)blogName {
    if (blogName) {
        [self performAction:@"blog" parameters:@{ @"blogName" : blogName }];
    }
}

+ (void)viewPost:(NSString *)postID blogName:(NSString *)blogName {
    if (blogName) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"blogName" : blogName }];
        [params setValue:postID forKey:@"postID"];
        
        [self performAction:@"blog" parameters:params];
    }
}

+ (void)createTextPost:(NSString *)title body:(NSString *)body tags:(NSArray *)tags {
    [self createTextPost:title body:body tags:tags success:nil cancel:nil];
}

+ (void)createTextPost:(NSString *)title body:(NSString *)body tags:(NSArray *)tags success:(NSURL *)successURL
                cancel:(NSURL *)cancelURL {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:title forKey:@"title"];
    [params setValue:body forKey:@"body"];
    [params setValue:tags forKey:@"tags"];
    
    [self performAction:@"text" parameters:params success:successURL cancel:cancelURL];
}

+ (void)createQuotePost:(NSString *)quote source:(NSString *)source tags:(NSArray *)tags {
    [self createQuotePost:quote source:source tags:tags success:nil cancel:nil];
}

+ (void)createQuotePost:(NSString *)quote source:(NSString *)source tags:(NSArray *)tags success:(NSURL *)successURL
                 cancel:(NSURL *)cancelURL {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:quote forKey:@"quote"];
    [params setValue:source forKey:@"source"];
    [params setValue:tags forKey:@"tags"];

    [self performAction:@"quote" parameters:params success:successURL cancel:cancelURL];
}

+ (void)createLinkPost:(NSString *)title URLString:(NSString *)URLString description:(NSString *)description
                  tags:(NSArray *)tags {
    [self createLinkPost:title URLString:URLString description:description tags:tags success:nil cancel:nil];
}

+ (void)createLinkPost:(NSString *)title URLString:(NSString *)URLString description:(NSString *)description
                  tags:(NSArray *)tags success:(NSURL *)successURL cancel:(NSURL *)cancelURL {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:title forKey:@"title"];
    [params setValue:URLString forKey:@"url"];
    [params setValue:description forKey:@"description"];
    [params setValue:tags forKey:@"tags"];
    
    [self performAction:@"link" parameters:params success:successURL cancel:cancelURL];
}

+ (void)createChatPost:(NSString *)title body:(NSString *)body tags:(NSArray *)tags {
    [self createChatPost:title body:body tags:tags success:nil cancel:nil];
}

+ (void)createChatPost:(NSString *)title body:(NSString *)body tags:(NSArray *)tags  success:(NSURL *)successURL
                cancel:(NSURL *)cancelURL {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:title forKey:@"title"];
    [params setValue:body forKey:@"body"];
    [params setValue:tags forKey:@"tags"];
    
    [self performAction:@"chat" parameters:params success:successURL cancel:cancelURL];
}

#pragma mark - Private

+ (void)performAction:(NSString *)action parameters:(NSDictionary *)parameters {
    [self performAction:action parameters:parameters success:nil cancel:nil];
}

+ (void)performAction:(NSString *)action parameters:(NSDictionary *)parameters success:(NSURL *)successURL cancel:(NSURL *)cancelURL {
    if ([self isTumblrInstalled]) {
        NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
        [mutableParameters setValue:@"TMTumblrSDK" forKey:@"referrer"];
        [mutableParameters setValue:[successURL absoluteString] forKey:@"x-success"];
        [mutableParameters setValue:[cancelURL absoluteString] forKey:@"x-cancel"];
        
        NSString *URLString = [NSString stringWithFormat:@"tumblr://x-callback-url/%@?%@", action,
                               TMDictionaryToQueryString(mutableParameters)];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }
}

@end
