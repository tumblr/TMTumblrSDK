//
//  TMTumblrAppClient.h
//  TumblrAppClient
//
//  Created by Bryan Irace on 11/24/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

#import "IACClient.h"

/**
 Convenience wrapper around the URLs that [Tumblr for iOS](https://itunes.apple.com/us/app/tumblr/id305343404) knows how 
 to open.
 */
@interface TMTumblrAppClient : IACClient

/// Open Tumblr for iOS in the app store
- (void)viewInAppStore;

/// View the authenticated user's dashboard
- (void)viewDashboard;

/// View a tag
- (void)viewTag:(NSString *)tag;

/// View a blog
- (void)viewBlog:(NSString *)blogName;

/// View a blog's post
- (void)viewPost:(NSString *)postID blogName:(NSString *)blogName;

@end
