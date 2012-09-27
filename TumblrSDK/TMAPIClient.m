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

NSString * const TMAPIParameterLimit = @"limit";
NSString * const TMAPIParameterOffset = @"offset";
NSString * const TMAPIParameterTag = @"tag";
NSString * const TMAPIParameterURL = @"url";
NSString * const TMAPIParameterPostID = @"id";
NSString * const TMAPIParameterReblogKey = @"reblog_key";
NSString * const TMAPIParameterType = @"type";

@implementation TMAPIClient

+ (id)sharedInstance {
    static TMAPIClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[TMAPIClient alloc] init]; });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _queue = [[JXHTTPOperationQueue alloc] init];
    }
    
    return self;
}

- (JXHTTPOperation *)get:(NSString *)path parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:URLWithPath(path) queryParameters:mutableParameters];
    [self sendRequest:request callback:callback];
    
    return request;
}

- (JXHTTPOperation *)post:(NSString *)path parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:URLWithPath(path)];
    request.requestBody = [JXHTTPFormEncodedBody withDictionary:mutableParameters];
    [self sendRequest:request callback:callback];
    
    return request;
}

- (void)sendRequest:(JXHTTPOperation *)request {
    NSString *authorizationHeaderValue = [TMOAuth authorizationHeaderForRequest:request
                                                                    consumerKey:self.OAuthConsumerKey
                                                                 consumerSecret:self.OAuthConsumerSecret
                                                                          token:self.OAuthToken
                                                                    tokenSecret:self.OAuthTokenSecret];
    
    [request setValue:authorizationHeaderValue forRequestHeader:@"Authorization"];
    
    [_queue addOperation:request]; 
}

- (void)sendRequest:(JXHTTPOperation *)request callback:(TMAPICallback)callback {
    __block JXHTTPOperation *blockRequest = request;
    
    request.completionBlock = ^ {
        NSDictionary *response = blockRequest.responseJSON;
        int statusCode = response[@"meta"] ? [response[@"meta"][@"status"] intValue] : 0;
        
        if (callback) {
            NSError *error = nil;
            
            if (statusCode != 200) {
                error = [NSError errorWithDomain:@"Request failed" code:statusCode userInfo:nil];
                NSLog(@"%@", blockRequest.requestURL);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(response[@"response"], error);
            });
        }
    };

    [self sendRequest:request];
}

#pragma mark - Authentication

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

#pragma mark - User

- (NSOperation *)userInfo:(TMAPICallback)callback {
    return [self get:@"user/info" parameters:nil callback:callback];
}

- (NSOperation *)dashboard:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:@"user/dashboard" parameters:parameters callback:callback];
}

- (NSOperation *)likes:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:@"user/likes" parameters:parameters callback:callback];
}

- (NSOperation *)following:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:@"user/following" parameters:parameters callback:callback];
}

- (NSOperation *)follow:(NSString *)blogName callback:(TMAPICallback)callback {
    return [self post:@"/user/follow" parameters:@{ TMAPIParameterURL : [NSString stringWithFormat:@"blog/%@.tumblr.com", blogName] }
             callback:callback];
}

- (NSOperation *)unfollow:(NSString *)blogName callback:(TMAPICallback)callback {
    return [self post:@"/user/unfollow" parameters:@{ TMAPIParameterURL : [NSString stringWithFormat:@"blog/%@.tumblr.com", blogName] }
             callback:callback];
}

- (NSOperation *)like:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback {
    return [self post:@"/user/like" parameters:@{ TMAPIParameterPostID : postID, TMAPIParameterReblogKey : reblogKey }
             callback:callback];
}

- (NSOperation *)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback {
    return [self post:@"/user/unlike" parameters:@{ TMAPIParameterPostID : postID, TMAPIParameterReblogKey : reblogKey }
             callback:callback];
}

#pragma mark - Blog

- (NSOperation *)blogInfo:(NSString *)blogName callback:(TMAPICallback)callback {
    return [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/info", blogName] parameters:nil callback:callback];
}

- (NSOperation *)followers:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/followers", blogName] parameters:parameters
            callback:callback];
}

- (NSOperation *)avatar:(NSString *)blogName size:(int)size callback:(TMAPIDataCallback)callback {
    NSString *URLString = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar/%d", blogName,
                           size];
    __block JXHTTPOperation *request = [JXHTTPOperation withURLString:URLString];
    
    request.completionBlock = ^ {
        if (callback) {
            if (request.responseStatusCode == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(request.responseData, nil);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(nil, [NSError errorWithDomain:@"Request failed" code:request.responseStatusCode userInfo:nil]);
                });
            }
        }
    };
    
    [self sendRequest:request];
    
    return request;
}

- (NSOperation *)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    NSString *path = [NSString stringWithFormat:@"blog/%@.tumblr.com/posts", blogName];
    if (type) path = [path stringByAppendingFormat:@"/%@", type];
    
    return [self get:path parameters:parameters callback:callback];
}

- (NSOperation *)queue:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/queue", blogName] parameters:parameters
            callback:callback];
}

- (NSOperation *)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/draft", blogName] parameters:parameters
            callback:callback];
}

- (NSOperation *)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/submission", blogName] parameters:parameters
            callback:callback];
}

#pragma mark - Posting

- (NSOperation *)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self post:@"post/edit" parameters:parameters callback:callback];
}

- (NSOperation *)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self post:@"post/reblog" parameters:parameters callback:callback];
}

- (NSOperation *)deletePost:(NSString *)blogName id:(NSString *)postID callback:(TMAPICallback)callback {
    return [self post:@"post/delete" parameters:@{ TMAPIParameterPostID : postID } callback:callback];
}

- (NSOperation *)createPost:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
                   callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = parameters
        ? [NSMutableDictionary dictionaryWithDictionary:parameters]
        : [NSMutableDictionary dictionary];
    mutableParameters[TMAPIParameterType] = type;
    
    return [self post:[NSString stringWithFormat:@"blog/%@.tumblr.com/post", blogName] parameters:mutableParameters
             callback:callback];
}

- (NSOperation *)text:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self createPost:blogName type:@"text" parameters:parameters callback:callback];
}

- (NSOperation *)quote:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self createPost:blogName type:@"quote" parameters:parameters callback:callback];
}

- (NSOperation *)link:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self createPost:blogName type:@"link" parameters:parameters callback:callback];
}

- (NSOperation *)chat:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self createPost:blogName type:@"chat" parameters:parameters callback:callback];
}

- (NSOperation *)audio:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    // TODO
    return nil;
}

- (NSOperation *)video:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    // TODO
    return nil;
}

- (NSOperation *)photo:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    // TODO
    return nil;
}

#pragma mark - Tagging

- (NSOperation *)tagged:(NSString *)tag parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:@"tagged" parameters:parameters callback:callback];
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
