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

typedef NS_ENUM(NSUInteger, TMUniversalLink) {
    TMUniversalLinkAuthorize
};

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

+ (void)viewExplore {
    [self performAction:@"explore" parameters:nil];
}

+ (void)viewActivityForPrimaryBlog {
    [self viewActivity:nil];
}

+ (void)viewActivity:(NSString *)blogName {
    NSDictionary *params;
    
    if (blogName) {
        params = @{ @"blogName" : blogName };
    }
    
    [self performAction:@"activity" parameters:params];
}

+ (void)viewTag:(NSString *)tag {
    if (tag) {
        [self performAction:@"tag" parameters:@{ @"tag" : tag }];
    }
}

+ (void)viewPrimaryBlog {
    [self viewBlog:nil];
}

+ (void)viewBlog:(NSString *)blogName {
    NSDictionary *params;
    
    if (blogName) {
        params = @{ @"blogName" : blogName };
    }
    
    [self performAction:@"blog" parameters:params];
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

+ (void)showAuthorizeWithToken:(NSString *)token {
    [self openLink:TMUniversalLinkAuthorize parameters:@{ @"oauth_token" : token }];
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

+ (void)openLink:(TMUniversalLink)link parameters:(NSDictionary *)parameters {
    NSString *URLString;
    
    switch (link) {
        case TMUniversalLinkAuthorize:
            URLString = [NSString stringWithFormat:@"https://www.tumblr.com/oauth/authorize?%@", TMDictionaryToQueryString(parameters)];
            break;
    }
    
    if (URLString) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }
}

@end
