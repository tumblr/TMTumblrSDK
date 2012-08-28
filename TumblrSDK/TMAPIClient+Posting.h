//
//  TMAPIClient+Posting.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

@interface TMAPIClient (Posting)

- (void)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
           error:(TMAPIErrorCallback)error;

- (void)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
             error:(TMAPIErrorCallback)error;

- (void)deletePost:(NSString *)blogName id:(NSString *)postID success:(TMAPICallback)success
             error:(TMAPIErrorCallback)error;

- (void)text:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error;

- (void)quote:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error;

- (void)link:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error;

- (void)chat:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error;

- (void)audio:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error;

- (void)video:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error;

- (void)photo:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error;

@end
