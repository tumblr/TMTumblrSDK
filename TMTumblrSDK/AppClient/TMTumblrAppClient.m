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
        NSMutableDictionary *params = [@{ @"blogName" : blogName } mutableCopy];
        
        if (postID) {
            params[@"postID"] = postID;
        }
        
        [self performAction:@"blog" parameters:params];
    }
}

+ (void)createTextPost:(NSString *)title body:(NSString *)body tags:(NSArray *)tags {
    [self createTextPost:title body:body tags:tags success:nil cancel:nil];
}

+ (void)createTextPost:(NSString *)title body:(NSString *)body tags:(NSArray *)tags success:(NSURL *)successURL
                cancel:(NSURL *)cancelURL {
    NSMutableDictionary *params = [@{} mutableCopy];
    
    if (title) {
        [params setValue:title forKey:@"title"];
    }
    
    if (body) {
        [params setValue:body forKey:@"body"];
    }
    
    if (tags) {
        [params setValue:tags forKey:@"tags"];
    }
    
    [self performAction:@"text" parameters:params success:successURL cancel:cancelURL];
}

+ (void)createQuotePost:(NSString *)quote source:(NSString *)source tags:(NSArray *)tags {
    [self createQuotePost:quote source:source tags:tags success:nil cancel:nil];
}

+ (void)createQuotePost:(NSString *)quote source:(NSString *)source tags:(NSArray *)tags success:(NSURL *)successURL
                 cancel:(NSURL *)cancelURL {
    NSMutableDictionary *params = [@{} mutableCopy];
    
    if (quote) {
        [params setValue:quote forKey:@"quote"];
    }
    
    if (source) {
        [params setValue:source forKey:@"source"];
    }
    
    if (tags) {
        [params setValue:tags forKey:@"tags"];
    }

    [self performAction:@"quote" parameters:params success:successURL cancel:cancelURL];
}

+ (void)createLinkPost:(NSString *)title URLString:(NSString *)URLString description:(NSString *)description
                  tags:(NSArray *)tags {
    [self createLinkPost:title URLString:URLString description:description tags:tags success:nil cancel:nil];
}

+ (void)createLinkPost:(NSString *)title URLString:(NSString *)URLString description:(NSString *)description
                  tags:(NSArray *)tags success:(NSURL *)successURL cancel:(NSURL *)cancelURL {
    NSMutableDictionary *params = [@{} mutableCopy];
    
    if (title) {
        [params setValue:title forKey:@"title"];
    }
    
    if (URLString) {
        [params setValue:URLString forKey:@"url"];
    }

    if (description) {
        [params setValue:description forKey:@"description"];
    }
    
    if (tags) {
        [params setValue:tags forKey:@"tags"];
    }
    
    [self performAction:@"link" parameters:params success:successURL cancel:cancelURL];
}

+ (void)createChatPost:(NSString *)title body:(NSString *)body tags:(NSArray *)tags {
    [self createChatPost:title body:body tags:tags success:nil cancel:nil];
}

+ (void)createChatPost:(NSString *)title body:(NSString *)body tags:(NSArray *)tags  success:(NSURL *)successURL
                cancel:(NSURL *)cancelURL {
    NSMutableDictionary *params = [@{} mutableCopy];
    
    if (title) {
        [params setValue:title forKey:@"title"];
    }

    if (body) {
        [params setValue:body forKey:@"body"];
    }
    
    if (tags) {
        [params setValue:tags forKey:@"tags"];
    }
    
    [self performAction:@"chat" parameters:params success:successURL cancel:cancelURL];
}

#pragma mark - Private

+ (void)performAction:(NSString *)action parameters:(NSDictionary *)parameters {
    [self performAction:action parameters:parameters success:nil cancel:nil];
}

+ (void)performAction:(NSString *)action parameters:(NSDictionary *)parameters success:(NSURL *)successURL cancel:(NSURL *)cancelURL {
    if ([self isTumblrInstalled]) {
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        
        mutableParameters[@"referrer"] = @"TMTumblrSDK";
        
        if (successURL) {
            mutableParameters[@"x-success"] = [successURL absoluteString];
        }
        
        if (cancelURL) {
            mutableParameters[@"x-cancel"] = [cancelURL absoluteString];
        }
        
        NSString *URLString = [NSString stringWithFormat:@"tumblr://x-callback-url/%@?%@", action,
                               TMDictionaryToQueryString(mutableParameters)];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }
}

@end
