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
    [self performAction:@"tag" parameters:@{ @"tag" : tag }];
}

+ (void)viewBlog:(NSString *)blogName {
    [self performAction:@"blog" parameters:@{ @"blogName" : blogName }];
}

+ (void)viewPost:(NSString *)postID blogName:(NSString *)blogName {
    [self performAction:@"blog" parameters:@{ @"blogName" : blogName, @"postID" : postID }];
}

+ (void)createTextPost:(NSString *)title body:(NSString *)body {
    [self createTextPost:title body:body success:nil cancel:nil];
}

+ (void)createTextPost:(NSString *)title body:(NSString *)body success:(NSURL *)successURL cancel:(NSURL *)cancelURL {
    [self performAction:@"text" parameters:@{ @"title" : title, @"body" : body } success:successURL cancel:cancelURL];
}

+ (void)createQuotePost:(NSString *)quote source:(NSString *)source {
    [self createQuotePost:quote source:source success:nil cancel:nil];
}

+ (void)createQuotePost:(NSString *)quote source:(NSString *)source success:(NSURL *)successURL
                 cancel:(NSURL *)cancelURL {
    [self performAction:@"quote" parameters:@{ @"quote" : quote, @"source" : source } success:successURL
                 cancel:cancelURL];
}

+ (void)createLinkPost:(NSString *)title URLString:(NSString *)URLString description:(NSString *)description {
    [self createLinkPost:title URLString:URLString description:description success:nil cancel:nil];
}

+ (void)createLinkPost:(NSString *)title URLString:(NSString *)URLString description:(NSString *)description
               success:(NSURL *)successURL cancel:(NSURL *)cancelURL {
    [self performAction:@"link" parameters:@{ @"title" : title, @"url" : URLString, @"description" : description }
                success:successURL cancel:cancelURL];
}

+ (void)createChatPost:(NSString *)title body:(NSString *)body {
    [self createChatPost:title body:body success:nil cancel:nil];
}

+ (void)createChatPost:(NSString *)title body:(NSString *)body success:(NSURL *)successURL cancel:(NSURL *)cancelURL {
    [self performAction:@"chat" parameters:@{ @"title" : title, @"body" : body } success:successURL cancel:cancelURL];
}

#pragma mark - Private

+ (void)performAction:(NSString *)action parameters:(NSDictionary *)parameters {
    [self performAction:action parameters:parameters success:nil cancel:nil];
}

+ (void)performAction:(NSString *)action parameters:(NSDictionary *)parameters success:(NSURL *)successURL cancel:(NSURL *)cancelURL {
    if (![self isTumblrInstalled])
        return;
    
    if (successURL || cancelURL) {
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        mutableParameters[@"x-success"] = [successURL absoluteString];
        mutableParameters[@"x-cancel"] = [cancelURL absoluteString];
        
        parameters = mutableParameters;
    }
    
    NSString *URLString = [NSString stringWithFormat:@"tumblr://x-callback-url/%@?%@", action,
                           dictionaryToQueryString(parameters)];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
}

// TODO: These currently exist for both the authenticator and app client. Consolidate

static inline NSString *dictionaryToQueryString(NSDictionary *dictionary) {
    NSMutableArray *parameters = [NSMutableArray array];
    
    for (NSString *key in [dictionary allKeys])
        [parameters addObject:[NSString stringWithFormat:@"%@=%@", URLEncode(key), URLEncode(dictionary[key])]];
    
    return [parameters componentsJoinedByString:@"&"];
}

static inline NSString *URLEncode(NSString *string) {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]%"), kCFStringEncodingUTF8));
}

@end
