//
//  TMAPIClient+Blog.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

typedef void (^TMAPIDataCallback)(NSData *, NSError *error);

@interface TMAPIClient (Blog)

- (JXHTTPOperation *)blogInfo:(NSString *)blogName callback:(TMAPICallback)callback;

- (JXHTTPOperation *)followers:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)avatar:(NSString *)blogName size:(int)size callback:(TMAPIDataCallback)callback;

- (JXHTTPOperation *)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
                   callback:(TMAPICallback)callback;

- (JXHTTPOperation *)queue:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

@end
