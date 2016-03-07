//
//  TMTumblrAppClient.h
//  TumblrAppClient
//
//  Created by Bryan Irace on 11/24/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

#import <Foundation/Foundation.h>

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

/// View the explore page
+ (void)viewExplore;

/// View the activity page for the primary blog
+ (void)viewActivityForPrimaryBlog;

// View the activity page for a given blog. If blogName is nil, will display the primary blog.
+ (void)viewActivity:(NSString *)blogName;

/// View a tag
+ (void)viewTag:(NSString *)tag;

/// View the primary blog
+ (void)viewPrimaryBlog;

/// View a blog. If blogName is nil, will display the primary blog
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

/**
 *  Present the OAuth authorize screen to the user.
 *
 *  @param token Token to use from Tumblr's Request-token URL (see https://www.tumblr.com/docs/en/api/v2#auth)
 */
+ (void)showAuthorizeWithToken:(NSString *)token;

@end
