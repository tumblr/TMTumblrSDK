//
//  TMAPIClient+User.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

@interface TMAPIClient (User)

- (JXHTTPOperation *)userInfo:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)dashboard:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)likes:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)following:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)follow:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)unfollow:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)like:(NSString *)postID reblogKey:(NSString *)reblogKey success:(TMAPICallback)success
                    error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey success:(TMAPICallback)success
                      error:(TMAPIErrorCallback)error;

@end
