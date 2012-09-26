//
//  TMAPIClient+User.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

@interface TMAPIClient (User)

- (JXHTTPOperation *)userInfo:(TMAPICallback)callback;

- (JXHTTPOperation *)dashboard:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)likes:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)following:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)follow:(NSString *)blogName callback:(TMAPICallback)callback;

- (JXHTTPOperation *)unfollow:(NSString *)blogName callback:(TMAPICallback)callback;

- (JXHTTPOperation *)like:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback;

- (JXHTTPOperation *)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback;

@end
