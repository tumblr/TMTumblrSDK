//
//  TMTumblrAppClient.h
//  TumblrAppClient
//
//  Created by Bryan Irace on 11/24/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

/**
 Convenience wrapper around the URLs that [Tumblr for iOS](https://itunes.apple.com/us/app/tumblr/id305343404) knows how 
 to open.
 */
@interface TMTumblrAppClient : NSObject

/// Check if the Tumblr app is installed
+ (BOOL)isTumblrInstalled;

/// Open Tumblr for iOS in the App Store
+ (void)viewInAppStore;

/// View the authenticated user's dashboard
+ (void)viewDashboard;

/// View a tag
+ (void)viewTag:(NSString *)tag;

/// View a blog
+ (void)viewBlog:(NSString *)blogName;

/// View a blog's post
+ (void)viewPost:(NSString *)postID blogName:(NSString *)blogName;

+ (void)createTextPost:(NSString *)title body:(NSString *)body;

+ (void)createTextPost:(NSString *)title body:(NSString *)body success:(NSURL *)successURL cancel:(NSURL *)cancelURL;

+ (void)createQuotePost:(NSString *)quote source:(NSString *)source;

+ (void)createQuotePost:(NSString *)quote source:(NSString *)source success:(NSURL *)successURL
                 cancel:(NSURL *)cancelURL;

+ (void)createLinkPost:(NSString *)title URLString:(NSString *)URLString description:(NSString *)description;

+ (void)createLinkPost:(NSString *)title URLString:(NSString *)URLString description:(NSString *)description
               success:(NSURL *)successURL cancel:(NSURL *)cancelURL;

+ (void)createChatPost:(NSString *)title body:(NSString *)body;

+ (void)createChatPost:(NSString *)title body:(NSString *)body success:(NSURL *)successURL cancel:(NSURL *)cancelURL;

@end
