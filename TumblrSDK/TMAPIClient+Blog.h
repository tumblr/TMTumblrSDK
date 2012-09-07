//
//  TMAPIClient+Blog.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

@interface TMAPIClient (Blog)

- (JXHTTPOperation *)blogInfo:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)followers:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                         error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)avatar:(NSString *)blogName size:(int)size success:(TMAPIDataCallback)success error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
                   success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)queue:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                     error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                      error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                           error:(TMAPIErrorCallback)error;

@end
