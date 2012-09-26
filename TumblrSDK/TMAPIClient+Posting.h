//
//  TMAPIClient+Posting.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

@interface TMAPIClient (Posting)

- (JXHTTPOperation *)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)createPost:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
                       callback:(TMAPICallback)callback;

- (JXHTTPOperation *)deletePost:(NSString *)blogName id:(NSString *)postID callback:(TMAPICallback)callback;

- (JXHTTPOperation *)text:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)quote:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)link:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)chat:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)audio:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)video:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)photo:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

@end
