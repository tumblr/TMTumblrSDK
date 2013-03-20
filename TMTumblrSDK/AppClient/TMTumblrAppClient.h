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

// Open the Tumblr app in the app store
- (void)viewInAppStore;

// Open the dashboard in the Tumblr app
- (void)viewDashboard;

// View a tag in the tumblr app
- (void)viewTag:(NSString *)tag;

// View a blog in the tumblr app
- (void)viewBlog:(NSString *)blogName;

// View a post in the tumblr app (on a given blog)
- (void)viewPost:(NSString *)postID blogName:(NSString *)blogName;

@end
