//
//  TMAPIClient.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

#import "NSData+Base64.h"
#import "TMOAuth.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_2_0
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

@interface TMAPIClient()

@property (nonatomic, copy) TMAPIAuthenticationCallback authCallback;

@end

@implementation TMAPIClient

+ (id)sharedInstance {
    static TMAPIClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[TMAPIClient alloc] init]; });
    return instance;
}

#pragma mark - Authentication

- (void)authenticate:(NSString *)URLScheme callback:(TMAPIAuthenticationCallback)callback {    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:@"http://www.tumblr.com/oauth/request_token"];
    request.continuesInAppBackground = YES;
    [self signRequest:request withParameters:nil];

    request.didFinishLoadingBlock = ^(JXHTTPOperation *operation) {
        if (operation.responseStatusCode == 200) {
            self.authCallback = callback;
            
            NSDictionary *responseParameters = queryStringToDictionary(operation.responseString);
            self.OAuthTokenSecret = responseParameters[@"oauth_token_secret"];
	            
            NSString *callbackURL = URLEncode([NSString stringWithFormat:@"%@://tumblr-authorize", URLScheme]);
            
            NSURL *authURL = [NSURL URLWithString:
                              [NSString stringWithFormat:@"https://www.tumblr.com/oauth/authorize?oauth_token=%@&oauth_callback=%@",
                               responseParameters[@"oauth_token"], callbackURL]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:authURL];
                // TODO: OS X support -- [[NSWorkspace sharedWorkspace] openURL:authURL];
            });
            
        } else {
            if (callback)
                callback([NSError errorWithDomain:@"Authentication request failed" code:operation.responseStatusCode
                                         userInfo:nil]);
        }
    };
    
    request.didFailBlock = ^(JXHTTPOperation *operation) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback)
                callback(operation.error);
        });
    };
    
    [_queue addOperation:request];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if (![url.host isEqualToString:@"tumblr-authorize"]) return NO;
    
    NSDictionary *URLParameters = queryStringToDictionary(url.query);
    
    // TODO: Handle case where user denied access
    
    self.OAuthToken = URLParameters[@"oauth_token"];
    
    NSDictionary *requestParameters = @{ @"oauth_verifier" : URLParameters[@"oauth_verifier"] };
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:@"http://www.tumblr.com/oauth/access_token"];
    request.requestMethod = @"POST";
    request.requestBody = [JXHTTPFormEncodedBody withDictionary:requestParameters];
    request.continuesInAppBackground = YES;
    [self signRequest:request withParameters:requestParameters];
    
    request.didFinishLoadingBlock = ^(JXHTTPOperation *operation) {
        if (operation.responseStatusCode == 200) {
            NSDictionary *responseParameters = queryStringToDictionary(operation.responseString);
            self.OAuthToken = responseParameters[@"oauth_token"];
            self.OAuthTokenSecret = responseParameters[@"oauth_token_secret"];
    
            if (self.authCallback)
                self.authCallback(nil);
            
        } else {
            self.OAuthToken = nil;
            self.OAuthTokenSecret = nil;

            if (self.authCallback)
                self.authCallback([NSError errorWithDomain:@"Authentication request failed" code:operation.responseStatusCode
                                                  userInfo:nil]);
        }
        
        self.authCallback = nil;
    };
    
    request.didFailBlock = ^(JXHTTPOperation *operation) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.authCallback)
                self.authCallback(operation.error);
            
            self.authCallback = nil;
        });
    };
    
    [_queue addOperation:request];
    
    return YES;
}

- (JXHTTPOperation *)xAuth:(NSString *)emailAddress password:(NSString *)password callback:(TMAPIAuthenticationCallback)callback {
    NSDictionary *requestParameters = @{
        @"x_auth_username" : emailAddress,
        @"x_auth_password" : password,
        @"x_auth_mode" : @"client_auth",
        @"api_key" : self.OAuthConsumerKey
    };
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:@"https://www.tumblr.com/oauth/access_token"];
    request.requestMethod = @"POST";
    request.requestBody = [JXHTTPFormEncodedBody withDictionary:requestParameters];
    request.continuesInAppBackground = YES;
    [self signRequest:request withParameters:requestParameters];
    
    if (callback) {
        request.didFinishLoadingBlock = ^(JXHTTPOperation *operation) {
            NSError *error = nil;
            
            if (operation.responseStatusCode == 200) {
                NSDictionary *responseParameters = queryStringToDictionary(operation.responseString);
                self.OAuthToken = responseParameters[@"oauth_token"];
                self.OAuthTokenSecret = responseParameters[@"oauth_token_secret"];
                
                callback(nil);
                
            } else {
                callback([NSError errorWithDomain:@"Authentication request failed" code:operation.responseStatusCode
                                         userInfo:nil]);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(error);
            });
        };
        
        request.didFailBlock = ^(JXHTTPOperation *operation) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(operation.error);
            });
        };
    }
    
    [_queue addOperation:request];
    
    return request;
}

#pragma mark - User

- (JXHTTPOperation *)userInfoRequest {
    return [self getRequestWithPath:@"user/info" parameters:nil];
}

- (void)userInfo:(TMAPICallback)callback {
    [self sendRequest:[self userInfoRequest] callback:callback];
}

- (JXHTTPOperation *)dashboardRequest:(NSDictionary *)parameters {
    return [self getRequestWithPath:@"user/dashboard" parameters:parameters];
}

- (void)dashboard:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self dashboardRequest:parameters] callback:callback];
}

- (JXHTTPOperation *)likesRequest:(NSDictionary *)parameters {
    return [self getRequestWithPath:@"user/likes" parameters:parameters];
}

- (void)likes:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self likesRequest:parameters] callback:callback];
}

- (JXHTTPOperation *)followingRequest:(NSDictionary *)parameters {
    return [self getRequestWithPath:@"user/following" parameters:parameters];
}

- (void)following:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self followingRequest:parameters] callback:callback];
}

- (JXHTTPOperation *)followRequest:(NSString *)blogName {
    return [self postRequestWithPath:@"user/follow" parameters:
            @{ @"url" : [NSString stringWithFormat:@"%@.tumblr.com", blogName] }];
}

- (void)follow:(NSString *)blogName callback:(TMAPICallback)callback {
    [self sendRequest:[self followRequest:blogName] callback:callback];
}

- (JXHTTPOperation *)unfollowRequest:(NSString *)blogName {
    return [self postRequestWithPath:@"user/unfollow" parameters:
            @{ @"url" : [NSString stringWithFormat:@"%@.tumblr.com", blogName] }];
}

- (void)unfollow:(NSString *)blogName callback:(TMAPICallback)callback {
    [self sendRequest:[self unfollowRequest:blogName] callback:callback];
}

- (JXHTTPOperation *)likeRequest:(NSString *)postID reblogKey:(NSString *)reblogKey {
    return [self postRequestWithPath:@"user/like" parameters:@{ @"id" : postID, @"reblog_key" : reblogKey }];
}

- (void)like:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback {
    [self sendRequest:[self likeRequest:postID reblogKey:reblogKey] callback:callback];
}

- (JXHTTPOperation *)unlikeRequest:(NSString *)postID reblogKey:(NSString *)reblogKey {
    return [self postRequestWithPath:@"user/unlike" parameters:@{ @"id" : postID, @"reblog_key" : reblogKey }];
}

- (void)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback {
    [self sendRequest:[self unlikeRequest:postID reblogKey:reblogKey] callback:callback];
}

#pragma mark - Blog

- (JXHTTPOperation *)blogInfoRequest:(NSString *)blogName {
    return [self getRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/info", blogName] parameters:nil];
}

- (void)blogInfo:(NSString *)blogName callback:(TMAPICallback)callback {
    [self sendRequest:[self blogInfoRequest:blogName] callback:callback];
}

- (JXHTTPOperation *)followersRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self getRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/followers", blogName] parameters:parameters];
}

- (void)followers:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self followersRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)avatarRequest:(NSString *)blogName size:(int)size {
    return [self getRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/avatar/%d", blogName, size] parameters:nil];
}

- (void)avatar:(NSString *)blogName size:(int)size callback:(TMAPICallback)callback {
    JXHTTPOperation *request = [self avatarRequest:blogName size:size];
    
    if (callback) {
        request.didFinishLoadingBlock = ^(JXHTTPOperation *operation) {
            id response = nil;
            NSError *error = nil;
            
            if (operation.responseStatusCode/100 == 2) {
                response = operation.responseData;
            } else {
                error = [NSError errorWithDomain:@"Request failed" code:operation.responseStatusCode
                                        userInfo:nil];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(response, error);
            });
        };
        
        request.didFailBlock = ^(JXHTTPOperation *operation) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(nil, operation.error);
            });
        };
    }
    
    [_queue addOperation:request];
}

- (JXHTTPOperation *)postsRequest:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters {
    NSString *path = [NSString stringWithFormat:@"blog/%@.tumblr.com/posts", blogName];
    if (type) path = [path stringByAppendingFormat:@"/%@", type];
    
    return [self getRequestWithPath:path parameters:parameters];
}

- (void)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self postsRequest:blogName type:type parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)queueRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self getRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/queue", blogName] parameters:parameters];
}

- (void)queue:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self queueRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)draftsRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self getRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/draft", blogName] parameters:parameters];
}

- (void)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self draftsRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)submissionsRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self getRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/submission", blogName] parameters:parameters];
}

- (void)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self submissionsRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)likesRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self getRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/likes", blogName] parameters:parameters];
}

- (void)likes:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self likesRequest:blogName parameters:parameters] callback:callback];
}

#pragma mark - Posting

- (JXHTTPOperation *)editPostRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self postRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/post/edit", blogName]
                          parameters:parameters];
}

- (void)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self editPostRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)reblogPostRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self postRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/post/reblog", blogName]
                          parameters:parameters];
}

- (void)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self sendRequest:[self reblogPostRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)deletePostRequest:(NSString *)blogName id:(NSString *)postID {
    return [self postRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/post/delete", blogName]
                          parameters:@{ @"id" : postID }];
}

- (void)deletePost:(NSString *)blogName id:(NSString *)postID callback:(TMAPICallback)callback {
    [self sendRequest:[self deletePostRequest:blogName id:postID] callback:callback];
}

- (JXHTTPOperation *)textRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self postRequest:blogName type:@"text" parameters:parameters];
}

- (void)text:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self textRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)quoteRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self postRequest:blogName type:@"quote" parameters:parameters];
}

- (void)quote:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self quoteRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)linkRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self postRequest:blogName type:@"link" parameters:parameters];
}

- (void)link:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self linkRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)chatRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self postRequest:blogName type:@"chat" parameters:parameters];
}

- (void)chat:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self chatRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)photoRequest:(NSString *)blogName data:(NSData *)data contentType:(NSString *)contentType
                       parameters:(NSDictionary *)parameters {
    return [self postRequest:blogName type:@"photo" parameters:parameters data:data filePath:nil contentType:contentType];
}

- (void)photo:(NSString *)blogName data:(NSData *)data contentType:(NSString *)contentType
   parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self photoRequest:blogName data:data contentType:contentType parameters:parameters]
             callback:callback];
}

- (JXHTTPOperation *)photoRequest:(NSString *)blogName filePath:(NSString *)filePath contentType:(NSString *)contentType
                       parameters:(NSDictionary *)parameters {
    return [self postRequest:blogName type:@"photo" parameters:parameters data:nil filePath:filePath contentType:contentType];
}

- (void)photo:(NSString *)blogName filePath:(NSString *)filePath contentType:(NSString *)contentType
   parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self photoRequest:blogName filePath:filePath contentType:contentType parameters:parameters]
             callback:callback];
}

#pragma mark - Tagging

- (JXHTTPOperation *)taggedRequest:(NSString *)tag parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"tag"] = tag;

    return [self getRequestWithPath:@"tagged" parameters:mutableParameters];
}

- (void)tagged:(NSString *)tag parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self taggedRequest:tag parameters:parameters] callback:callback];
}

#pragma mark - Private

- (JXHTTPOperation *)postRequest:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters {
    return [self postRequest:blogName type:type parameters:parameters data:nil filePath:nil contentType:nil];
}

- (void)post:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self postRequest:blogName type:type parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)postRequest:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
                            data:(NSData *)data filePath:(NSString *)filePath contentType:(NSString *)contentType {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"type"] = type;
    
    return [self postRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/post", blogName]
                          parameters:mutableParameters data:data filePath:filePath contentType:contentType];
}

- (void)post:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters data:(NSData *)data
    filePath:(NSString *)filePath contentType:(NSString *)contentType callback:(TMAPICallback)callback {
    [self sendRequest:[self postRequest:blogName type:type parameters:parameters data:data filePath:filePath
                            contentType:contentType] callback:callback];
}

- (JXHTTPOperation *)getRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:URLWithPath(path) queryParameters:mutableParameters];
    request.continuesInAppBackground = YES;
    
    [self signRequest:request withParameters:nil];
    
    return request;
}

- (JXHTTPOperation *)postRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    return [self postRequestWithPath:path parameters:parameters data:nil filePath:nil contentType:nil];
}

- (JXHTTPOperation *)postRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters data:(NSData *)data
                                filePath:(NSString *)filePath contentType:(NSString *)contentType {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:URLWithPath(path)];
    request.requestMethod = @"POST";
    request.continuesInAppBackground = YES;
    
    if (data || filePath) {
        JXHTTPMultipartBody *multipartBody = [JXHTTPMultipartBody withDictionary:mutableParameters];
        
        if (data) {
            [multipartBody addData:data forKey:@"data" contentType:contentType fileName:@"foo.bar"];
            
        } else {
            [multipartBody addFile:filePath forKey:@"data" contentType:contentType fileName:@"foo.bar"];
        }
        
        request.requestBody = multipartBody;

    } else {
        request.requestBody = [JXHTTPFormEncodedBody withDictionary:mutableParameters];
    }
    
    [self signRequest:request withParameters:mutableParameters];
    
    return request;
}

- (void)signRequest:(JXHTTPOperation *)request withParameters:(NSDictionary *)parameters {
    [request setValue:[TMOAuth headerForURL:request.requestURL method:request.requestMethod postParameters:parameters
                                      nonce:request.uniqueString consumerKey:self.OAuthConsumerKey
                             consumerSecret:self.OAuthConsumerSecret token:self.OAuthToken
                                tokenSecret:self.OAuthTokenSecret] forRequestHeader:@"Authorization"];
}

- (void)sendRequest:(JXHTTPOperation *)request callback:(TMAPICallback)callback {
    if (callback) {
        request.didFinishLoadingBlock = ^(JXHTTPOperation *operation) {
            NSDictionary *response = operation.responseJSON;
            int statusCode = response[@"meta"] ? [response[@"meta"][@"status"] intValue] : 0;
            
            NSError *error = nil;
            
            if (statusCode/100 != 2) {
                error = [NSError errorWithDomain:@"Request failed" code:statusCode userInfo:nil];
                NSLog(@"%@", operation.requestURL);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(response[@"response"], error);
            });
        };
        
        request.didFailBlock = ^(JXHTTPOperation *operation) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(nil, operation.error);
            });
        };
    }
    
    [_queue addOperation:request];
}

static inline NSString *URLWithPath(NSString *path) {
    return [@"http://api.tumblr.com/v2/" stringByAppendingString:path];
}

static inline NSString *URLDecode(NSString *string) {
    return [(NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)string, CFSTR("")) autorelease];
}

static inline NSString *URLEncode(NSString *string) {
    return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL,
                                                                CFSTR("!*'();:@&=+$,/?%#[]%"), kCFStringEncodingUTF8)
            autorelease];
}

static inline NSDictionary *queryStringToDictionary(NSString *string) {
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    
    NSArray *parameterStrings = [string componentsSeparatedByString:@"&"];
    
    for (NSString *parameterString in parameterStrings) {
        NSArray *parameterComponents = [parameterString componentsSeparatedByString:@"="];
        parameterDictionary[URLDecode(parameterComponents[0])] = URLDecode(parameterComponents[1]);
    }
    
    return parameterDictionary;
}

#pragma mark - Memory management

- (void)dealloc {
    self.authCallback = nil;
    self.OAuthConsumerKey = nil;
    self.OAuthConsumerSecret = nil;
    self.OAuthToken = nil;
    self.OAuthTokenSecret = nil;
    
    [_queue release];
    
    [super dealloc];
}

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        _queue = [[JXHTTPOperationQueue alloc] init];
    }
    
    return self;
}

@end
