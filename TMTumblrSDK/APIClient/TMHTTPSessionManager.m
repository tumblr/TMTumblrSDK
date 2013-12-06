//
//  TMHTTPSessionManager.m
//  TMTumblrSDK
//
//  Created by Bryan Irace on 12/6/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMHTTPSessionManager.h"

@implementation TMHTTPSessionManager

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters
                     callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    return [super GET:URLString parameters:parameters success:[[self class] successBlockForCallback:callback]
              failure:[[self class] failureBlockForCallback:callback]];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters
                     callback:(TMAPICallback)callback {
    return [super POST:URLString parameters:parameters success:[[self class] successBlockForCallback:callback]
               failure:[[self class] failureBlockForCallback:callback]];
}

#pragma mark - Private

+ (void (^)(NSURLSessionDataTask *, id))successBlockForCallback:(TMAPICallback)callback {
    void (^successBlock)(NSURLSessionDataTask *, id) = nil;
    
    if (callback) {
        successBlock = ^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *response = responseObject;
            
            int statusCode = response[@"meta"] ? [response[@"meta"][@"status"] intValue] : 0;
            
            NSError *error = nil;
            
            if (statusCode/100 != 2) {
                error = [NSError errorWithDomain:@"Request failed" code:statusCode userInfo:nil];
            }
            
            callback(response[@"response"], error);
        };
    }
    
    return successBlock;
}

+ (void (^)(NSURLSessionDataTask *, NSError *))failureBlockForCallback:(TMAPICallback)callback {
    void (^failureBlock)(NSURLSessionDataTask *, NSError *) = nil;
    
    if (callback) {
        failureBlock = ^(NSURLSessionDataTask *task, NSError *error) {
            callback(nil, error);
        };
    }
    
    return failureBlock;
}

@end
