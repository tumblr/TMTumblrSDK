//
//  TMAPIClient+Posting.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

@interface TMAPIClient (Posting)

- (JXHTTPOperation *)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                        error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                          error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)deletePost:(NSString *)blogName id:(NSString *)postID success:(TMAPICallback)success
                          error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)text:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                    error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)quote:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                     error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)link:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                    error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)chat:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                    error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)audio:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                     error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)video:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                     error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)photo:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                     error:(TMAPIErrorCallback)error;

@end
