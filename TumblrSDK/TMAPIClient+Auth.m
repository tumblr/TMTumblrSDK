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

- (void)xAuthRequest:(NSString *)userName password:(NSString *)password {
    __block JXHTTPOperation *request = [JXHTTPOperation withURLString:@"https://www.tumblr.com/oauth/access_token"];
    request.requestMethod = @"POST";
    
    NSDictionary *parameters = @{
        @"x_auth_username" : userName,
        @"x_auth_password" : password,
        @"x_auth_mode" : @"client_auth"
    };
    
    request.requestBody = [JXHTTPFormEncodedBody withDictionary:parameters];
    
    request.completionBlock = ^ {
        if (request.responseStatusCode == 200) {
//            if (success) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    success(request.responseData);
//                });
//            }
        } else {
//            error([NSError errorWithDomain:@"Request failed" code:request.responseStatusCode userInfo:nil]);
        }
    };
    
    [self sendRequest:request];
}

@end
