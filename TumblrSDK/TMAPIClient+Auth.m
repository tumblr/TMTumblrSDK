//
//  TMAPIClient+Auth.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/30/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient+Auth.h"
#import "NSData+Base64.h"

@implementation TMAPIClient (Auth)

- (JXHTTPOperation *)xAuthRequest:(NSString *)userName password:(NSString *)password callback:(TMAPICallback)callback {
    __block JXHTTPOperation *request = [JXHTTPOperation withURLString:@"https://www.tumblr.com/oauth/access_token"];
    request.requestMethod = @"POST";
    
    NSDictionary *parameters = @{
        @"x_auth_username" : userName,
        @"x_auth_password" : password,
        @"x_auth_mode" : @"client_auth"
    };
    
    request.requestBody = [JXHTTPFormEncodedBody withDictionary:parameters];
    
    request.completionBlock = ^ {
        if (callback) {
            if (request.responseStatusCode == 200) {
                NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
                
                NSArray *parameterStrings = [request.responseString componentsSeparatedByString:@"&"];
                
                for (NSString *parameterString in parameterStrings) {
                    NSArray *parameterComponents = [parameterString componentsSeparatedByString:@"="];
                    NSString *key = URLDecode(parameterComponents[0]);
                    NSString *value = URLDecode(parameterComponents[1]);
                    
                    parameterDictionary[key] = value;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(parameterDictionary, nil);
                });
            } else {
                callback(nil, [NSError errorWithDomain:@"Authentication request failed" code:request.responseStatusCode
                                              userInfo:nil]);
            }
        }
    };
    
    [self sendRequest:request];
    
    return request;
}

#pragma mark - Helper functions

static inline NSString *URLDecode(NSString *string) {
    return [(NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)string, CFSTR("")) autorelease];
}

@end
