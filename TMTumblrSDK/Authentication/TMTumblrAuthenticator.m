//
//  TMTumblrAuthenticator.m
//  TumblrAuthentication
//
//  Created by Bryan Irace on 11/19/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

#import "TMTumblrAuthenticator.h"

#import "TMOAuth.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

typedef void (^NSURLConnectionCompletionHandler)(NSURLResponse *, NSData *, NSError *);

@interface TMTumblrAuthenticator()

@property (nonatomic, copy) TMAuthenticationCallback authCallback;
@property (nonatomic, copy) NSString *OAuthToken;
@property (nonatomic, copy) NSString *OAuthTokenSecret;

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
    self.OAuthTokenSecret = nil;
    
    NSString *tokenRequestURLString = [NSString stringWithFormat:@"http://www.tumblr.com/oauth/request_token?oauth_callback=%@",
                                       URLEncode([NSString stringWithFormat:@"%@://tumblr-authorize", URLScheme])];
    
    NSMutableURLRequest *request = mutableRequestWithURLString(tokenRequestURLString);
    [self signRequest:request withParameters:nil];
    
    NSURLConnectionCompletionHandler handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (callback)
                callback(nil, nil, error);
            
            return;
        }
        
        int statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
        if (statusCode == 200) {
            self.authCallback = callback;
            
            NSDictionary *responseParameters = formEncodedDataToDictionary(data);
            self.OAuthTokenSecret = responseParameters[@"oauth_token_secret"];
            
            NSURL *authURL = [NSURL URLWithString:
                              [NSString stringWithFormat:@"https://www.tumblr.com/oauth/authorize?oauth_token=%@",
                               responseParameters[@"oauth_token"]]];
            
#if __IPHONE_OS_VERSION_MIN_REQUIRED
            [[UIApplication sharedApplication] openURL:authURL];
#else
            [[NSWorkspace sharedWorkspace] openURL:authURL];
#endif

        } else {
            if (callback)
                callback(nil, nil, errorWithStatusCode(statusCode));
        }
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if (![url.host isEqualToString:@"tumblr-authorize"])
        return NO;
    
    void(^clearState)() = ^ {
        self.OAuthToken = nil;
        self.OAuthTokenSecret = nil;
        self.authCallback = nil;
    };
    
    NSDictionary *URLParameters = queryStringToDictionary(url.query);
    
    if ([[URLParameters allKeys] count] == 0) {
        if (self.authCallback)
            self.authCallback(nil, nil, [NSError errorWithDomain:@"Permission denied by user" code:0 userInfo:nil]);
        
        clearState();
        
        return NO;
    }
    
    self.OAuthToken = URLParameters[@"oauth_token"];
    
    NSDictionary *requestParameters = @{ @"oauth_verifier" : URLParameters[@"oauth_verifier"] };
    
    NSMutableURLRequest *request = mutableRequestWithURLString(@"http://www.tumblr.com/oauth/access_token");
    request.HTTPMethod = @"POST";
    request.HTTPBody = [dictionaryToQueryString(requestParameters) dataUsingEncoding:NSUTF8StringEncoding];
    [self signRequest:request withParameters:requestParameters];
    
    NSURLConnectionCompletionHandler handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (self.authCallback)
                self.authCallback(nil, nil, error);
            
        } else {
            int statusCode = ((NSHTTPURLResponse *)response).statusCode;
            
            if (self.authCallback) {
                if (statusCode == 200) {
                    NSDictionary *responseParameters = formEncodedDataToDictionary(data);
                    
                    self.authCallback(responseParameters[@"oauth_token"], responseParameters[@"oauth_token_secret"], nil);
                    
                } else {
                    self.authCallback(nil, nil, errorWithStatusCode(statusCode));
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
    
    NSMutableURLRequest *request = mutableRequestWithURLString(@"http://www.tumblr.com/oauth/access_token");
    request.HTTPMethod = @"POST";
    request.HTTPBody = [dictionaryToQueryString(requestParameters) dataUsingEncoding:NSUTF8StringEncoding];
    [self signRequest:request withParameters:requestParameters];

    NSURLConnectionCompletionHandler handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (callback)
                callback(nil, nil, error);
            
            return;
        }
        
        int statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
        if (statusCode == 200) {
            NSDictionary *responseParameters = formEncodedDataToDictionary(data);
            self.OAuthToken = responseParameters[@"oauth_token"];
            self.OAuthTokenSecret = responseParameters[@"oauth_token_secret"];
            
            if (callback)
                callback(self.OAuthToken, self.OAuthTokenSecret, nil);
            
        } else {
            if (callback)
                callback(nil, nil, errorWithStatusCode(statusCode));
        }
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
}

#pragma mark - NSObject


#pragma mark - Helpers

- (void)signRequest:(NSMutableURLRequest *)request withParameters:(NSDictionary *)parameters {
    [request setValue:[TMOAuth headerForURL:request.URL
                                     method:request.HTTPMethod
                             postParameters:parameters
                                      nonce:[[NSProcessInfo processInfo] globallyUniqueString]
                                consumerKey:self.OAuthConsumerKey
                             consumerSecret:self.OAuthConsumerSecret
                                      token:self.OAuthToken
                                tokenSecret:self.OAuthTokenSecret] forHTTPHeaderField:@"Authorization"];
}

static inline NSMutableURLRequest *mutableRequestWithURLString(NSString *URLString) {
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
}

static inline NSError *errorWithStatusCode(int statusCode) {
    return [NSError errorWithDomain:@"Authentication request failed" code:statusCode userInfo:nil];
}

static inline NSString *URLDecode(NSString *string) {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)string, CFSTR("")));
}

static inline NSString *URLEncode(NSString *string) {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL,
                                                                CFSTR("!*'();:@&=+$,/?%#[]%"), kCFStringEncodingUTF8));
}

static inline NSString *dictionaryToQueryString(NSDictionary *dictionary) {
    NSMutableArray *parameters = [NSMutableArray array];
    
    for (NSString *key in [dictionary allKeys])
        [parameters addObject:[NSString stringWithFormat:@"%@=%@", URLEncode(key), URLEncode(dictionary[key])]];
    
    return [parameters componentsJoinedByString:@"&"];
}

static inline NSDictionary *queryStringToDictionary(NSString *string) {
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    
    NSArray *parameterStrings = [string componentsSeparatedByString:@"&"];
    
    for (NSString *parameterString in parameterStrings) {
        NSArray *parameterComponents = [parameterString componentsSeparatedByString:@"="];
        
        if ([parameterComponents count] == 2)
            parameterDictionary[URLDecode(parameterComponents[0])] = URLDecode(parameterComponents[1]);
    }
    
    return parameterDictionary;
}

static inline NSDictionary *formEncodedDataToDictionary(NSData *data) {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = queryStringToDictionary(string);
    
    return dictionary;
}

@end
