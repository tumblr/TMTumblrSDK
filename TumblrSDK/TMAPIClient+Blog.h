//
//  TMAPIClient+Blog.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

@interface TMAPIClient (Blog)

- (void)blogInfo:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)followers:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
            error:(TMAPIErrorCallback)error;

- (void)avatar:(NSString *)blogName size:(int)size success:(TMAPIDataCallback)success error:(TMAPIErrorCallback)error;

- (void)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
      success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)queue:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error;

- (void)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
         error:(TMAPIErrorCallback)error;

- (void)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
              error:(TMAPIErrorCallback)error;

@end
