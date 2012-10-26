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

@interface TMAPIClient()

- (JXHTTPOperation *)getRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters;

- (JXHTTPOperation *)postRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters;

- (void)signRequest:(JXHTTPOperation *)request withParameters:(NSDictionary *)parameters;

@end


@implementation TMAPIClient

- (id)init {
    if (self = [super init]) {
        _queue = [[JXHTTPOperationQueue alloc] init];
    }
    
    return self;
}

+ (id)sharedInstance {
    static TMAPIClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[TMAPIClient alloc] init]; });
    return instance;
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
                if (!operation.isCancelled)
                    callback(response[@"response"], error);
            });
        };
        
        request.didFailBlock = ^(JXHTTPOperation *operation) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!operation.isCancelled)
                    callback(nil, operation.error);
            });
        };
    }

    [_queue addOperation:request];
}

#pragma mark - Authentication

/*- (void)authenticate:(void(^)(NSString *, NSString *))callback {
    JXHTTPOperation *request = [JXHTTPOperation withURLString:@"https://www.tumblr.com/oauth/access_token"];
    
    request.didFinishLoadingBlock = ^(JXHTTPOperation *operation) {
        if (callback) {
            NSDictionary *response = operation.responseJSON;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *OAuthURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",
                                   response[@"oauth_token"]];
                
                [[UIApplication sharedApplication] openURL:OAuthURL];
            });
        }
    };
    
    [_queue addOperation:request];
}*/

- (JXHTTPOperation *)xAuth:(NSString *)userName password:(NSString *)password callback:(TMAPICallback)callback {
    NSDictionary *parameters = @{
        @"x_auth_username" : userName,
        @"x_auth_password" : password,
        @"x_auth_mode" : @"client_auth", @"api_key" :
        self.OAuthConsumerKey
    };
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:@"https://www.tumblr.com/oauth/access_token"];
    request.requestMethod = @"POST";
    request.requestBody = [JXHTTPFormEncodedBody withDictionary:parameters];
    request.continuesInAppBackground = YES;
    
    [self signRequest:request withParameters:parameters];
    
    if (callback) {
        request.didFinishLoadingBlock = ^(JXHTTPOperation *operation) {
            NSMutableDictionary *parameterDictionary = nil;
            NSError *error = nil;
            
            if (operation.responseStatusCode == 200) {
                parameterDictionary = [NSMutableDictionary dictionary];
                
                NSArray *parameterStrings = [operation.responseString componentsSeparatedByString:@"&"];
                
                for (NSString *parameterString in parameterStrings) {
                    NSArray *parameterComponents = [parameterString componentsSeparatedByString:@"="];
                    parameterDictionary[URLDecode(parameterComponents[0])] = URLDecode(parameterComponents[1]);
                }
            } else {
                error = [NSError errorWithDomain:@"Authentication request failed" code:operation.responseStatusCode
                                        userInfo:nil];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!operation.isCancelled)
                    callback(parameterDictionary, error);
            });
        };
        
        request.didFailBlock = ^(JXHTTPOperation *operation) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!operation.isCancelled)
                    callback(nil, operation.error);
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
    return [self getRequestWithPath:[NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar/%d",
                                     blogName, size] parameters:nil];
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
                if (!operation.isCancelled)
                    callback(response, error);
            });
        };
        
        request.didFailBlock = ^(JXHTTPOperation *operation) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!operation.isCancelled)
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

- (JXHTTPOperation *)audioRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    // TODO
    return [self postRequest:blogName type:@"audio" parameters:parameters];
}

- (void)audio:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self audioRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)videoRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    // TODO
    return [self postRequest:blogName type:@"video" parameters:parameters];
}

- (void)video:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self videoRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)photoRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    // TODO
    return [self postRequest:blogName type:@"photo" parameters:parameters];
}

- (void)photo:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    
    
    [self sendRequest:[self photoRequest:blogName parameters:parameters] callback:callback];
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

#pragma mark - Class extension

- (JXHTTPOperation *)getRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:URLWithPath(path) queryParameters:mutableParameters];
    request.continuesInAppBackground = YES;
    
    [self signRequest:request withParameters:mutableParameters];
    
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
    
    if (data) {
        JXHTTPMultipartBody *multipartBody = [JXHTTPMultipartBody withDictionary:mutableParameters];
        [multipartBody addData:data forKey:@"data" contentType:contentType fileName:@"foo.bar"];
        
        request.requestBody = multipartBody;
        
    } else {
        request.requestBody = [JXHTTPFormEncodedBody withDictionary:mutableParameters];
    }
    
    [self signRequest:request withParameters:mutableParameters];
    
    return request;
}

- (void)signRequest:(JXHTTPOperation *)request withParameters:(NSDictionary *)parameters {
    [request setValue:[TMOAuth headerForURL:request.requestURL method:request.requestMethod postParameters:parameters
                                      nonce:request.uniqueString consumerKey:self.OAuthConsumerKey consumerSecret:self.OAuthConsumerSecret
                                      token:self.OAuthToken tokenSecret:self.OAuthTokenSecret] forRequestHeader:@"Authorization"];
}

#pragma mark - Helper function

static inline NSString *URLWithPath(NSString *path) {
    return [@"http://api.tumblr.com/v2/" stringByAppendingString:path];
}

static inline NSString *URLDecode(NSString *string) {
    return [(NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)string, CFSTR("")) autorelease];
}

#pragma mark - Memory management

- (void)dealloc {
    self.OAuthConsumerKey = nil;
    self.OAuthConsumerSecret = nil;
    self.OAuthToken = nil;
    self.OAuthTokenSecret = nil;
    
    [_queue release];
    
    [super dealloc];
}

@end
