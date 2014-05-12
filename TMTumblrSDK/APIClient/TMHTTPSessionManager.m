//
//  TMHTTPSessionManager.m
//  TMTumblrSDK
//
//  Created by Bryan Irace on 5/12/14.
//  Copyright (c) 2014 Tumblr. All rights reserved.
//

#import "TMHTTPSessionManager.h"

#import "TMHTTPSessionManager.h"
#import "TMHTTPRequestSerializer.h"

static NSString * const BaseURLString = @"http://api.tumblr.com/v2/";
static NSString * const APIKeyParameter = @"api_key";
static NSString * const UserAgentHeader = @"User-Agent";
static NSString * const UserAgentSDKValue = @"TMTumblrSDK";

@interface TMHTTPSessionManager() <TMHTTPRequestSerializerDelegate>
@end

@implementation TMHTTPSessionManager

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration {
    if (!sessionConfiguration.HTTPAdditionalHeaders[UserAgentHeader]) {
        NSMutableDictionary *headers = [sessionConfiguration.HTTPAdditionalHeaders mutableCopy];
        headers[UserAgentHeader] = UserAgentSDKValue;
        
        sessionConfiguration.HTTPAdditionalHeaders = headers;
    }
    
    if (self = [super initWithBaseURL:[NSURL URLWithString:BaseURLString] sessionConfiguration:sessionConfiguration]) {
        self.requestSerializer = [[TMHTTPRequestSerializer alloc] initWithDelegate:self];
    }
    
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters
                     callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    mutableParameters[APIKeyParameter] = self.OAuthConsumerKey;
    
    return [super GET:URLString parameters:mutableParameters success:TMSuccessBlockForCallback(callback) failure:TMFailureBlockForCallback(callback)];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters
                      callback:(TMAPICallback)callback {
    return [super POST:URLString parameters:parameters success:TMSuccessBlockForCallback(callback) failure:TMFailureBlockForCallback(callback)];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      callback:(TMAPICallback)callback {
    
    return [super POST:URLString parameters:parameters constructingBodyWithBlock:block success:TMSuccessBlockForCallback(callback) failure:TMFailureBlockForCallback(callback)];
}

#pragma mark - Private

typedef void (^TMHTTPSuccessBlock)(NSURLSessionDataTask *, id);
typedef void (^TMHTTPFailureBlock)(NSURLSessionDataTask *, NSError *error);

TMHTTPSuccessBlock TMSuccessBlockForCallback(TMAPICallback callback) {
    TMHTTPSuccessBlock successBlock = nil;
    
    if (callback) {
        successBlock = ^(NSURLSessionDataTask *task, id responseObject) {
            callback(responseObject, nil);
        };
    }
    
    return successBlock;
}

TMHTTPFailureBlock TMFailureBlockForCallback(TMAPICallback callback) {
    TMHTTPFailureBlock failureBlock = nil;
    
    if (callback) {
        failureBlock = ^(NSURLSessionDataTask *task, NSError *error) {
            callback(nil, error);
        };
    }
    
    return failureBlock;
}

@end
