//
//  TMAPIClient.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

// Request methods
static NSString * const TMAPIRequestMethodGET = @"GET";
static NSString * const TMAPIRequestMethodPOST = @"POST";

// Parameter keys
static NSString * const TMAPIKeyParameterKey = @"api_key";

// Paths
static NSString * const TMAPIPathBlogInfo = @"blog/%@.tumblr.com/info";


@interface TMAPIClient()

- (JXHTTPOperation *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
                               success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

@end


@implementation TMAPIClient

- (void)blogInfo:(NSString *)blogName success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:
                                [NSString stringWithFormat:TMAPIPathBlogInfo, blogName]
                                            parameters:@{@"api_key" : @""}
                                               success:success error:nil];
    
    [[JXHTTPOperationQueue sharedQueue] addOperation:request];
}

+ (id)sharedInstance {
    static TMAPIClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[TMAPIClient alloc] init]; });
    return instance;
}

#pragma mark - Class extension

- (JXHTTPOperation *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
                             success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error {
    __block JXHTTPOperation *request;
    NSString *URLString = [NSString stringWithFormat:@"http://api.tumblr.com/v2/%@", path];
    
    if ([method isEqualToString:TMAPIRequestMethodGET]) {
        request = [JXHTTPOperation withURLString:URLString queryParameters:parameters];
        
    } else if ([method isEqualToString:TMAPIRequestMethodPOST]) {
        request = [JXHTTPOperation withURLString:URLString];
        request.requestBody = [JXHTTPJSONBody withJSONObject:parameters];
    }

    request.delegate = self;
    
    request.completionBlock = ^ {
        // TODO: Introspect response code to determine success or error
        
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(request.responseJSON);
            });
        }
    };
    
    return request;
}

#pragma mark - JXHTTPOperationDelegate

- (void)httpOperationWillStart:(JXHTTPOperation *)operation {
    NSLog(@"");
}

- (void)httpOperationDidFail:(JXHTTPOperation *)operation {
    // What happens if fails here? No way to invoke error block
    NSLog(@"");
}

- (void)httpOperationDidFinish:(JXHTTPOperation *)operation {
    NSLog(@"");
}

@end
