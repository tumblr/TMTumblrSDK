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
#import "TMSDKUserAgent.h"
#import "TMWebViewController.h"
#import "TMSDKConstants.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

typedef void (^NSURLConnectionCompletionHandler)(NSURLResponse *, NSData *, NSError *);
typedef void (^TMHandleAuthenticationURLCallback)(NSURL *authURL);

#if __IPHONE_OS_VERSION_MIN_REQUIRED
@interface TMTumblrAuthenticator() <TMWebViewControllerDelegate>
#else
@interface TMTumblrAuthenticator()
#endif

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

- (void)authenticate:(NSString *)URLScheme
       handleAuthURL:(TMHandleAuthenticationURLCallback)handleAuthURLBlock
        authCallback:(TMAuthenticationCallback)callback {

    // Clear token secret in case authentication was previously started but not finished
    self.threeLeggedOAuthTokenSecret = nil;
    
    NSString *tokenRequestURLString = [NSString stringWithFormat:@"https://www.tumblr.com/oauth/request_token?oauth_callback=%@",
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

            handleAuthURLBlock(authURL);

        } else {
            if (callback) {
                callback(nil, nil, errorWithStatusCode(statusCode));
            }
        }
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
}

#ifdef __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__

- (void)authenticate:(NSString *)URLScheme callback:(TMAuthenticationCallback)callback {
    [self authenticate:URLScheme handleAuthURL:^(NSURL *authURL) {
        [[NSWorkspace sharedWorkspace] openURL:authURL];
    } authCallback:callback];
}

#endif

#ifdef __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__

- (void)authenticate:(NSString *)URLScheme fromViewController:(UIViewController *)fromViewController callback:(TMAuthenticationCallback)callback {
    [self authenticate:URLScheme handleAuthURL:^(NSURL *authURL) {
        Class SFSafariViewControllerClass = NSClassFromString(@"SFSafariViewController");
        UIViewController *authController;
        if (SFSafariViewControllerClass) {
            authController = [[SFSafariViewControllerClass alloc] initWithURL:authURL];
            authController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [authController performSelector:@selector(setDelegate:) withObject:self];
        } else {
            TMWebViewController *controller = [[TMWebViewController alloc] initWithURL:authURL];
            controller.delegate = self;
            authController = [[UINavigationController alloc] initWithRootViewController:controller];
        }
        [fromViewController presentViewController:authController animated:YES completion:NULL];
    } authCallback:^(NSString *token, NSString *secret, NSError *error) {
        dispatch_block_t performCallback = ^{
            if (callback) {
                callback(token, secret, error);
            }
        };
        if (fromViewController.presentedViewController && !fromViewController.presentedViewController.isBeingDismissed) {
            [fromViewController dismissViewControllerAnimated:YES completion:performCallback];
        } else {
            performCallback();
        }
    }];
}

#endif

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
            self.threeLeggedOAuthCallback(nil, nil, errorCanceledByUser()); // Permission denied by user
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

#if __IPHONE_OS_VERSION_MIN_REQUIRED

#pragma mark - SFSafariViewControllerDelegate

- (void)safariViewControllerDidFinish:(UIViewController *)controller {
    void(^clearState)() = ^ {
        self.threeLeggedOAuthTokenSecret = nil;
        self.threeLeggedOAuthCallback = nil;
    };
    if (self.threeLeggedOAuthCallback) {
        self.threeLeggedOAuthCallback(nil, nil, errorCanceledByUser()); // Canceled by user
    }
    clearState();
}

#pragma mark - TMWebViewControllerDelegate

- (void)webViewControllerDidFinish:(TMWebViewController *)controller {
    void(^clearState)() = ^ {
        self.threeLeggedOAuthTokenSecret = nil;
        self.threeLeggedOAuthCallback = nil;
    };
    [controller dismissViewControllerAnimated:YES completion:^{
        if (self.threeLeggedOAuthCallback) {
            self.threeLeggedOAuthCallback(nil, nil, errorCanceledByUser()); // Canceled by user
        }
        clearState();
    }];
}

#endif

#pragma mark - Helpers

+ (void)signRequest:(NSMutableURLRequest *)request
     withParameters:(NSDictionary *)parameters
        consumerKey:(NSString *)consumerKey
     consumerSecret:(NSString *)consumerSecret
              token:(NSString *)OAuthToken
        tokenSecret:(NSString *)OAuthTokenSecret {
    [request setValue:[TMSDKUserAgent userAgentHeaderString] forHTTPHeaderField:@"User-Agent"];
    
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
    return [NSError errorWithDomain:TMTumblrSDKErrorDomain
                               code:TMTumblrSDKRequestFailedErrorCode
                           userInfo:@{NSLocalizedDescriptionKey: @"Authentication request failed.",
                                      TMTumblrSDKHTTPStatusCodeErrorKey: @(statusCode)}];
}

NSError *errorCanceledByUser() {
    return [NSError errorWithDomain:TMTumblrSDKErrorDomain
                               code:TMTumblrSDKCanceledErrorCode
                           userInfo:@{NSLocalizedDescriptionKey: @"Canceled by a user."}];
}

NSDictionary *formEncodedDataToDictionary(NSData *data) {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = TMQueryStringToDictionary(string);
    
    return dictionary;
}

@end
