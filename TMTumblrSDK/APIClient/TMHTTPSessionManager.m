//
//  TMHTTPSessionManager.m
//  TMTumblrSDK
//
//  Created by Bryan Irace on 12/6/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMHTTPSessionManager.h"

static NSString * const TMAPIResponseKeyAPIKey = @"api_key";

@implementation TMHTTPSessionManager

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters
                     callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    
    NSString *consumerKey = [self.delegate OAuthConsumerKey];
    
    if (consumerKey) {
        mutableParameters[TMAPIResponseKeyAPIKey] = consumerKey;
    }
    
    return [super GET:URLString parameters:mutableParameters
              success:[[self class] successBlockForCallback:callback]
              failure:[[self class] failureBlockForCallback:callback]];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters
                     callback:(TMAPICallback)callback {
    return [super POST:URLString parameters:parameters
               success:[[self class] successBlockForCallback:callback]
               failure:[[self class] failureBlockForCallback:callback]];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      callback:(TMAPICallback)callback {

    return [super POST:URLString parameters:parameters constructingBodyWithBlock:block
               success:[[self class] successBlockForCallback:callback]
               failure:[[self class] failureBlockForCallback:callback]];
}

#pragma mark - Private

+ (void (^)(NSURLSessionDataTask *, id))successBlockForCallback:(TMAPICallback)callback {
    void (^successBlock)(NSURLSessionDataTask *, id) = nil;
    
    if (callback) {
        successBlock = ^(NSURLSessionDataTask *task, id responseObject) {
            callback(responseObject, nil);
        };
    }
    
    return successBlock;
}

+ (void (^)(NSURLSessionDataTask *, NSError *))failureBlockForCallback:(void (^)(id, NSError *error))callback {
    void (^failureBlock)(NSURLSessionDataTask *, NSError *) = nil;
    
    if (callback) {
        failureBlock = ^(NSURLSessionDataTask *task, NSError *error) {
            callback(nil, error);
        };
    }
    
    return failureBlock;
}

@end
