//
//  TMTumblrAppClient.h
//  TumblrAppClient
//
//  Created by Bryan Irace on 11/24/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IACClient.h"

/**
 Convenience wrapper around the URL schemes that the Tumblr app for iOS allows other apps to communicate using.
 */
@interface TMTumblrAppClient : IACClient

- (void)viewInAppStore;

- (void)viewDashboard;

- (void)viewTag:(NSString *)tag;

- (void)viewBlog:(NSString *)blogName;

- (void)viewPost:(NSString *)postID blogName:(NSString *)blogName;

- (void)createTextPost:(NSString *)title body:(NSString *)body;

- (void)createQuotePost:(NSString *)quote source:(NSString *)source;

- (void)createLinkPost:(NSString *)title URL:(NSString *)URL description:(NSString *)description;

- (void)createChatPost:(NSString *)title body:(NSString *)body;

@end
