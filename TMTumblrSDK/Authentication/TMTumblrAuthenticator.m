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

@property (nonatomic, copy) TMAuthenticationCallback threeLeggedOAuthCallback;
@property (nonatomic, copy) NSString *threeLeggedOAuthTokenSecret;

NSMutableURLRequest *mutableRequestWithURLString(NSString *URLString);

NSError *errorWithStatusCode(NSInteger statusCode);

NSDictionary *formEncodedDataToDictionary(NSData *data);

@end

@implementation TMTumblrAuthenticator

+ (id)sharedInstance {
    static TMTumblrAuthenticator *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[TMTumblrAuthenticator alloc] init]; });
    return instance;
}

#ifdef __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__

- (void)authenticate:(NSString *)URLScheme callback:(TMAuthenticationCallback)callback {
    // Clear token secret in case authentication was previously started but not finished
    self.threeLeggedOAuthTokenSecret = nil;
    
    NSString *tokenRequestURLString = [NSString stringWithFormat:@"http://www.tumblr.com/oauth/request_token?oauth_callback=%@",
                                       TMURLEncode([NSString stringWithFormat:@"%@://tumblr-authorize", URLScheme])];
    
    NSMutableURLRequest *request = mutableRequestWithURLString(tokenRequestURLString);
    [[self class] signRequest:request withParameters:nil consumerKey:self.OAuthConsumerKey
               consumerSecret:self.OAuthConsumerSecret token:nil tokenSecret:nil];
    
    NSURLConnectionCompletionHandler handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (callback) {
                callback(nil, nil, error);
            }
            
            return;
        }
        
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
        if (statusCode == 200) {
            self.threeLeggedOAuthCallback = callback;
            
            NSDictionary *responseParameters = formEncodedDataToDictionary(data);
            self.threeLeggedOAuthTokenSecret = responseParameters[@"oauth_token_secret"];
            
            NSURL *authURL = [NSURL URLWithString:
                              [NSString stringWithFormat:@"https://www.tumblr.com/oauth/authorize?oauth_token=%@",
                               responseParameters[@"oauth_token"]]];
            
            [[NSWorkspace sharedWorkspace] openURL:authURL];
            
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
        self.threeLeggedOAuthTokenSecret = nil;
        self.threeLeggedOAuthCallback = nil;
    };
    
    NSDictionary *URLParameters = TMQueryStringToDictionary(url.query);
    
    if ([[URLParameters allKeys] count] == 0) {
        if (self.threeLeggedOAuthCallback) {
            self.threeLeggedOAuthCallback(nil, nil, [NSError errorWithDomain:@"Permission denied by user" code:0 userInfo:nil]);
        }
        
        clearState();
        
        return NO;
    }
    
    NSString *OAuthToken = URLParameters[@"oauth_token"];
    
    NSDictionary *requestParameters = @{ @"oauth_verifier" : URLParameters[@"oauth_verifier"] };
    
    NSMutableURLRequest *request = mutableRequestWithURLString(@"https://www.tumblr.com/oauth/access_token");
    request.HTTPMethod = @"POST";
    request.HTTPBody = [TMDictionaryToQueryString(requestParameters) dataUsingEncoding:NSUTF8StringEncoding];
    
    [[self class] signRequest:request withParameters:requestParameters consumerKey:self.OAuthConsumerKey
               consumerSecret:self.OAuthConsumerSecret token:OAuthToken tokenSecret:self.threeLeggedOAuthTokenSecret];
    
    NSURLConnectionCompletionHandler handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (self.threeLeggedOAuthCallback) {
                self.threeLeggedOAuthCallback(nil, nil, error);
            }
        } else {
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            
            if (self.threeLeggedOAuthCallback) {
                if (statusCode == 200) {
                    NSDictionary *responseParameters = formEncodedDataToDictionary(data);
                    
                    self.threeLeggedOAuthCallback(responseParameters[@"oauth_token"], responseParameters[@"oauth_token_secret"], nil);
                    
                } else {
                    self.threeLeggedOAuthCallback(nil, nil, errorWithStatusCode(statusCode));
                }
            }
        }
        
        clearState();
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
    
    return YES;
}

#endif

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
    
    [[self class] signRequest:request withParameters:requestParameters consumerKey:self.OAuthConsumerKey
               consumerSecret:self.OAuthConsumerSecret token:nil tokenSecret:nil];

    NSURLConnectionCompletionHandler handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (callback) {
                callback(nil, nil, error);
            }
            
            return;
        }
        
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
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

+ (void)signRequest:(NSMutableURLRequest *)request
     withParameters:(NSDictionary *)parameters
        consumerKey:(NSString *)consumerKey
     consumerSecret:(NSString *)consumerSecret
              token:(NSString *)OAuthToken
        tokenSecret:(NSString *)OAuthTokenSecret {
    [request setValue:@"TMTumblrSDK" forHTTPHeaderField:@"User-Agent"];
    
    [request setValue:[TMOAuth headerForURL:request.URL
                                     method:request.HTTPMethod
                             postParameters:parameters
                                      nonce:[[NSProcessInfo processInfo] globallyUniqueString]
                                consumerKey:consumerKey
                             consumerSecret:consumerSecret
                                      token:OAuthToken
                                tokenSecret:OAuthTokenSecret] forHTTPHeaderField:@"Authorization"];
}

NSMutableURLRequest *mutableRequestWithURLString(NSString *URLString) {
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
}

NSError *errorWithStatusCode(NSInteger statusCode) {
    return [NSError errorWithDomain:@"Authentication request failed" code:statusCode userInfo:nil];
}

NSDictionary *formEncodedDataToDictionary(NSData *data) {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = TMQueryStringToDictionary(string);
    
    return dictionary;
}

@end
