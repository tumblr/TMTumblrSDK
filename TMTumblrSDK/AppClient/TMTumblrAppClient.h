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

/// Create a text post with a title, body, and tags
+ (void)createTextPost:(NSString *)title body:(NSString *)body tags:(NSArray *)tags;

/// Create a text post with a title, body, tags, and success/cancel URLs
+ (void)createTextPost:(NSString *)title body:(NSString *)body tags:(NSArray *)tags success:(NSURL *)successURL
                cancel:(NSURL *)cancelURL;

/// Create a quote post with a quote, source, and tags
+ (void)createQuotePost:(NSString *)quote source:(NSString *)source tags:(NSArray *)tags;

/// Create a quote post with a quote, source, tags, and success/cancel URLs
+ (void)createQuotePost:(NSString *)quote source:(NSString *)source tags:(NSArray *)tags success:(NSURL *)successURL
                 cancel:(NSURL *)cancelURL;

/// Create a link post with a title, URL, description, and tags
+ (void)createLinkPost:(NSString *)title URLString:(NSString *)URLString description:(NSString *)description
                  tags:(NSArray *)tags;

/// Create a link post with a title, URL, description, tags, and success/cancel URLs
+ (void)createLinkPost:(NSString *)title URLString:(NSString *)URLString description:(NSString *)description
                  tags:(NSArray *)tags success:(NSURL *)successURL cancel:(NSURL *)cancelURL;

/// Create a chat post with a title, body, and tags
+ (void)createChatPost:(NSString *)title body:(NSString *)body tags:(NSArray *)tags;

/// Create a chat post with a title, body, tags, and success/cancel URLs
+ (void)createChatPost:(NSString *)title body:(NSString *)body tags:(NSArray *)tags success:(NSURL *)successURL
                cancel:(NSURL *)cancelURL;

/// Create a photo post with a caption, link, source, and success/cancel URLs
+ (void)createPhotoPost:(NSString *)caption link:(NSString *)link photoURL:(NSString *)photoURL
                success:(NSURL *)successURL cancel:(NSURL *)cancelURL;

/// Create a photo post with a caption, link, source, tags, and success/cancel URLs
+ (void)createPhotoPost:(NSString *)caption link:(NSString *)link photoURL:(NSString *)photoURL tags:(NSArray *)tags
                success:(NSURL *)successURL cancel:(NSURL *)cancelURL;

@end
