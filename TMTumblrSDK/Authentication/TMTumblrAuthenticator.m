//
//  TMTumblrAuthenticator.m
//  TumblrAuthentication
//
//  Created by Bryan Irace on 11/19/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

#import "TMTumblrAuthenticator.h"

#import "TMOAuth.h"
#import "TMSDKFunctions.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

typedef void (^NSURLConnectionCompletionHandler)(NSURLResponse *, NSData *, NSError *);

@interface TMTumblrAuthenticator()

@property (nonatomic, copy) TMAuthenticationCallback ThreeLeggedOAuthCallback;
@property (nonatomic, copy) NSString *ThreeLeggedOAuthTokenSecret;

NSMutableURLRequest *mutableRequestWithURLString(NSString *URLString);

NSError *errorWithStatusCode(int statusCode);

NSDictionary *formEncodedDataToDictionary(NSData *data);

@end

@implementation TMTumblrAuthenticator

+ (id)sharedInstance {
    static TMTumblrAuthenticator *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[TMTumblrAuthenticator alloc] init]; });
    return instance;
}

- (void)authenticate:(NSString *)URLScheme callback:(TMAuthenticationCallback)callback {
    // Clear token secret in case authentication was previously started but not finished
    self.ThreeLeggedOAuthTokenSecret = nil;
    
    NSString *tokenRequestURLString = [NSString stringWithFormat:@"http://www.tumblr.com/oauth/request_token?oauth_callback=%@",
                                       TMURLEncode([NSString stringWithFormat:@"%@://tumblr-authorize", URLScheme])];
    
    NSMutableURLRequest *request = mutableRequestWithURLString(tokenRequestURLString);
    [self signRequest:request withParameters:nil token:nil tokenSecret:nil];
    
    NSURLConnectionCompletionHandler handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (callback) {
                callback(nil, nil, error);
            }
            
            return;
        }
        
        int statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
        if (statusCode == 200) {
            self.ThreeLeggedOAuthCallback = callback;
            
            NSDictionary *responseParameters = formEncodedDataToDictionary(data);
            self.ThreeLeggedOAuthTokenSecret = responseParameters[@"oauth_token_secret"];
            
            NSURL *authURL = [NSURL URLWithString:
                              [NSString stringWithFormat:@"https://www.tumblr.com/oauth/authorize?oauth_token=%@",
                               responseParameters[@"oauth_token"]]];
            
#if __IPHONE_OS_VERSION_MIN_REQUIRED
            [[UIApplication sharedApplication] openURL:authURL];
#else
            [[NSWorkspace sharedWorkspace] openURL:authURL];
#endif

        } else {
            if (callback) {
                callback(nil, nil, errorWithStatusCode(statusCode));
            }
        }
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if (![url.host isEqualToString:@"tumblr-authorize"]) {
        return NO;
    }
    
    void(^clearState)() = ^ {
        self.ThreeLeggedOAuthTokenSecret = nil;
        self.ThreeLeggedOAuthCallback = nil;
    };
    
    NSDictionary *URLParameters = TMQueryStringToDictionary(url.query);
    
    if ([[URLParameters allKeys] count] == 0) {
        if (self.ThreeLeggedOAuthCallback) {
            self.ThreeLeggedOAuthCallback(nil, nil, [NSError errorWithDomain:@"Permission denied by user" code:0 userInfo:nil]);
        }
        
        clearState();
        
        return NO;
    }
    
    NSString *OAuthToken = URLParameters[@"oauth_token"];
    
    NSDictionary *requestParameters = @{ @"oauth_verifier" : URLParameters[@"oauth_verifier"] };
    
    NSMutableURLRequest *request = mutableRequestWithURLString(@"https://www.tumblr.com/oauth/access_token");
    request.HTTPMethod = @"POST";
    request.HTTPBody = [TMDictionaryToQueryString(requestParameters) dataUsingEncoding:NSUTF8StringEncoding];
    [self signRequest:request withParameters:requestParameters token:OAuthToken tokenSecret:self.ThreeLeggedOAuthTokenSecret];
    
    NSURLConnectionCompletionHandler handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (self.ThreeLeggedOAuthCallback) {
                self.ThreeLeggedOAuthCallback(nil, nil, error);
            }
        } else {
            int statusCode = ((NSHTTPURLResponse *)response).statusCode;
            
            if (self.ThreeLeggedOAuthCallback) {
                if (statusCode == 200) {
                    NSDictionary *responseParameters = formEncodedDataToDictionary(data);
                    
                    self.ThreeLeggedOAuthCallback(responseParameters[@"oauth_token"], responseParameters[@"oauth_token_secret"], nil);
                    
                } else {
                    self.ThreeLeggedOAuthCallback(nil, nil, errorWithStatusCode(statusCode));
                }
            }
        }
        
        clearState();
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
    
    return YES;
}

- (void)xAuth:(NSString *)emailAddress password:(NSString *)password callback:(TMAuthenticationCallback)callback {
    NSDictionary *requestParameters = @{
        @"x_auth_username" : emailAddress,
        @"x_auth_password" : password,
        @"x_auth_mode" : @"client_auth",
        @"api_key" : self.OAuthConsumerKey
    };
    
    NSMutableURLRequest *request = mutableRequestWithURLString(@"https://www.tumblr.com/oauth/access_token");
    request.HTTPMethod = @"POST";
    request.HTTPBody = [TMDictionaryToQueryString(requestParameters) dataUsingEncoding:NSUTF8StringEncoding];
    [self signRequest:request withParameters:requestParameters token:nil tokenSecret:nil];

    NSURLConnectionCompletionHandler handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (callback) {
                callback(nil, nil, error);
            }
            
            return;
        }
        
        int statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
        if (statusCode == 200) {
            NSDictionary *responseParameters = formEncodedDataToDictionary(data);

            if (callback) {
                callback(responseParameters[@"oauth_token"], responseParameters[@"oauth_token_secret"], nil);
            }
            
        } else {
            if (callback) {
                callback(nil, nil, errorWithStatusCode(statusCode));
            }
        }
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
}

#pragma mark - NSObject


#pragma mark - Helpers

- (void)signRequest:(NSMutableURLRequest *)request withParameters:(NSDictionary *)parameters token:(NSString *)OAuthToken tokenSecret:(NSString *)OAuthTokenSecret {
    [request setValue:@"TMTumblrSDK" forHTTPHeaderField:@"User-Agent"];
    
    [request setValue:[TMOAuth headerForURL:request.URL
                                     method:request.HTTPMethod
                             postParameters:parameters
                                      nonce:[[NSProcessInfo processInfo] globallyUniqueString]
                                consumerKey:self.OAuthConsumerKey
                             consumerSecret:self.OAuthConsumerSecret
                                      token:OAuthToken
                                tokenSecret:OAuthTokenSecret] forHTTPHeaderField:@"Authorization"];
}

NSMutableURLRequest *mutableRequestWithURLString(NSString *URLString) {
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
}

NSError *errorWithStatusCode(int statusCode) {
    return [NSError errorWithDomain:@"Authentication request failed" code:statusCode userInfo:nil];
}

NSDictionary *formEncodedDataToDictionary(NSData *data) {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = TMQueryStringToDictionary(string);
    
    return dictionary;
}

@end
