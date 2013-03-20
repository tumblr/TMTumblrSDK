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

@end
