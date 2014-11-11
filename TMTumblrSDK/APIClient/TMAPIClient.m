//
//  TMAPIClient.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2013 Tumlr. All rights reserved.
//

#import "TMAPIClient.h"

#import "TMOAuth.h"
#import "TMTumblrAuthenticator.h"

static NSTimeInterval const TMAPIClientDefaultRequestTimeoutInterval = 60;

@interface TMAPIClient()

@property (nonatomic, strong) JXHTTPOperationQueue *queue;

NSString *blogPath(NSString *ext, NSString *blogName);

NSString *fullBlogName(NSString *blogName);

@end


@implementation TMAPIClient

+ (instancetype)sharedInstance {
    static TMAPIClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[self alloc] init]; });
    return instance;
}

#pragma mark - Authentication

#ifdef __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__

- (void)authenticate:(NSString *)URLScheme callback:(void(^)(NSError *))callback {
    [[TMTumblrAuthenticator sharedInstance] authenticate:URLScheme
                                                callback:^(NSString *token, NSString *secret, NSError *error) {
                                                    self.OAuthToken = token;
                                                    self.OAuthTokenSecret = secret;
                                                    
                                                    callback(error);
                                                }];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [[TMTumblrAuthenticator sharedInstance] handleOpenURL:url];
}

#endif

- (void)xAuth:(NSString *)emailAddress password:(NSString *)password callback:(void(^)(NSError *))callback {
    return [[TMTumblrAuthenticator sharedInstance] xAuth:emailAddress password:password
                                                callback:^(NSString *token, NSString *secret, NSError *error) {
        self.OAuthToken = token;
        self.OAuthTokenSecret = secret;
        
        callback(error);
    }];
}

- (void)setOAuthConsumerKey:(NSString *)OAuthConsumerKey {
    [TMTumblrAuthenticator sharedInstance].OAuthConsumerKey = OAuthConsumerKey;
}

- (NSString *)OAuthConsumerKey {
    return [TMTumblrAuthenticator sharedInstance].OAuthConsumerKey;
}

- (void)setOAuthConsumerSecret:(NSString *)OAuthConsumerSecret {
    [TMTumblrAuthenticator sharedInstance].OAuthConsumerSecret = OAuthConsumerSecret;
}

- (NSString *)OAuthConsumerSecret {
    return [TMTumblrAuthenticator sharedInstance].OAuthConsumerSecret;
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
    return [self postRequestWithPath:@"user/follow" parameters:@{ @"url" : fullBlogName(blogName) }];
}

- (void)follow:(NSString *)blogName callback:(TMAPICallback)callback {
    [self sendRequest:[self followRequest:blogName] callback:callback];
}

- (JXHTTPOperation *)unfollowRequest:(NSString *)blogName {
    return [self postRequestWithPath:@"user/unfollow" parameters:@{ @"url" : fullBlogName(blogName) }];
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

- (void)avatar:(NSString *)blogName size:(NSUInteger)size callback:(TMAPICallback)callback {
    [self avatar:blogName size:size queue:self.defaultCallbackQueue callback:callback];
}

- (void)avatar:(NSString *)blogName size:(NSUInteger)size queue:(NSOperationQueue *)queue callback:(TMAPICallback)callback {
    JXHTTPOperation *request = [self getRequestWithPath:[blogPath(@"avatar", blogName) stringByAppendingFormat:@"/%ld", (long)size]
                                             parameters:nil];
    
    if (callback) {
        __block typeof(callback) blockCallback = callback;
        
        request.didFinishLoadingBlock = ^(JXHTTPOperation *operation) {
            id response = nil;
            NSError *error = nil;
            
            if (operation.responseStatusCode/100 == 2) {
                response = operation.responseData;
            } else {
                error = [NSError errorWithDomain:@"Request failed" code:operation.responseStatusCode
                                        userInfo:nil];
            }
            
            [queue addOperationWithBlock:^{
                blockCallback(response, error);
                blockCallback = nil;
            }];
        };
        
        request.didFailBlock = ^(JXHTTPOperation *operation) {
            [queue addOperationWithBlock:^{
                blockCallback(nil, operation.error);
                blockCallback = nil;
            }];
        };
    }
    
    [self.queue addOperation:request];
}

- (JXHTTPOperation *)blogInfoRequest:(NSString *)blogName {
    return [self getRequestWithPath:blogPath(@"info", blogName) parameters:nil];
}

- (void)blogInfo:(NSString *)blogName callback:(TMAPICallback)callback {
    [self sendRequest:[self blogInfoRequest:blogName] callback:callback];
}

- (JXHTTPOperation *)followersRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self getRequestWithPath:blogPath(@"followers", blogName) parameters:parameters];
}

- (void)followers:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self followersRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)postsRequest:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters {
    NSString *path = blogPath(@"posts", blogName);
    
    if (type) {
        path = [path stringByAppendingFormat:@"/%@", type];
    }
    
    return [self getRequestWithPath:path parameters:parameters];
}

- (void)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self postsRequest:blogName type:type parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)queueRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self getRequestWithPath:blogPath(@"posts/queue", blogName) parameters:parameters];
}

- (void)queue:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self queueRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)draftsRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self getRequestWithPath:blogPath(@"posts/draft", blogName) parameters:parameters];
}

- (void)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self draftsRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)submissionsRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self getRequestWithPath:blogPath(@"posts/submission", blogName) parameters:parameters];
}

- (void)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self submissionsRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)likesRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self getRequestWithPath:blogPath(@"likes", blogName) parameters:parameters];
}

- (void)likes:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self likesRequest:blogName parameters:parameters] callback:callback];
}

#pragma mark - Posting

- (JXHTTPOperation *)postRequest:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"type"] = type;
    
    return [self postRequestWithPath:blogPath(@"post", blogName) parameters:mutableParameters];
}

- (void)post:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self postRequest:blogName type:type parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)editPostRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self postRequestWithPath:blogPath(@"post/edit", blogName) parameters:parameters];
}

- (void)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self editPostRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)reblogPostRequest:(NSString *)blogName parameters:(NSDictionary *)parameters {
    return [self postRequestWithPath:blogPath(@"post/reblog", blogName) parameters:parameters];
}

- (void)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self sendRequest:[self reblogPostRequest:blogName parameters:parameters] callback:callback];
}

- (JXHTTPOperation *)deletePostRequest:(NSString *)blogName id:(NSString *)postID {
    return [self postRequestWithPath:blogPath(@"post/delete", blogName) parameters:@{ @"id": postID }];
}

- (void)deletePost:(NSString *)blogName id:(NSString *)postID callback:(TMAPICallback)callback {
    [self sendRequest:[self deletePostRequest:blogName id:postID] callback:callback];
}

#pragma mark -  Posting (convenience)

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

- (JXHTTPOperation *)photoRequest:(NSString *)blogName filePathArray:(NSArray *)filePathArrayOrNil
                 contentTypeArray:(NSArray *)contentTypeArrayOrNil fileNameArray:(NSArray *)fileNameArrayOrNil
                       parameters:(NSDictionary *)parameters {
    return [self multipartPostRequest:blogName type:@"photo" parameters:parameters filePathArray:filePathArrayOrNil
                     contentTypeArray:contentTypeArrayOrNil fileNameArray:fileNameArrayOrNil];
}

- (void)photo:(NSString *)blogName filePathArray:(NSArray *)filePathArrayOrNil contentTypeArray:(NSArray *)contentTypeArrayOrNil
fileNameArray:(NSArray *)fileNameArrayOrNil parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self photoRequest:blogName filePathArray:filePathArrayOrNil contentTypeArray:contentTypeArrayOrNil
                           fileNameArray:fileNameArrayOrNil parameters:parameters] callback:(TMAPICallback)callback];
}

- (JXHTTPOperation *)videoRequest:(NSString *)blogName filePath:(NSString *)filePathOrNil
                      contentType:(NSString *)contentTypeOrNil fileName:(NSString *)fileNameOrNil
                       parameters:(NSDictionary *)parameters {
    return [self multipartPostRequest:blogName type:@"video" parameters:parameters
                        filePathArray:filePathOrNil ? @[filePathOrNil] : nil
                     contentTypeArray:contentTypeOrNil ? @[contentTypeOrNil] : nil
                        fileNameArray:fileNameOrNil ? @[fileNameOrNil] : nil];
}

- (void)video:(NSString *)blogName filePath:(NSString *)filePathOrNil contentType:(NSString *)contentTypeOrNil
     fileName:(NSString *)fileNameOrNil parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self videoRequest:blogName filePath:filePathOrNil contentType:contentTypeOrNil fileName:fileNameOrNil
                              parameters:parameters] callback:(TMAPICallback)callback];
}

- (JXHTTPOperation *)audioRequest:(NSString *)blogName filePath:(NSString *)filePathOrNil
                      contentType:(NSString *)contentTypeOrNil fileName:(NSString *)fileNameOrNil
                       parameters:(NSDictionary *)parameters {
    return [self multipartPostRequest:blogName type:@"audio" parameters:parameters
                        filePathArray:filePathOrNil ? @[filePathOrNil] : nil
                     contentTypeArray:contentTypeOrNil ? @[contentTypeOrNil] : nil
                        fileNameArray:fileNameOrNil ? @[fileNameOrNil] : nil];
}

- (void)audio:(NSString *)blogName filePath:(NSString *)filePathOrNil contentType:(NSString *)contentTypeOrNil
     fileName:(NSString *)fileNameOrNil parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self audioRequest:blogName filePath:filePathOrNil contentType:contentTypeOrNil fileName:fileNameOrNil
                              parameters:parameters] callback:(TMAPICallback)callback];
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

- (JXHTTPOperation *)getRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:[self URLWithPath:path] queryParameters:mutableParameters];
    request.continuesInAppBackground = YES;
    request.requestTimeoutInterval = self.timeoutInterval;
    
    [self signRequest:request withParameters:nil];
    
    return request;
}

- (JXHTTPOperation *)postRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:[self URLWithPath:path]];
    request.requestMethod = @"POST";
    request.continuesInAppBackground = YES;
    request.requestBody = [JXHTTPFormEncodedBody withDictionary:mutableParameters];
    request.requestTimeoutInterval = self.timeoutInterval;
    
    [self signRequest:request withParameters:mutableParameters];
    
    return request;
}

- (JXHTTPOperation *)multipartPostRequest:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
                            filePathArray:(NSArray *)filePathArray contentTypeArray:(NSArray *)contentTypeArray
                            fileNameArray:(NSArray *)fileNameArray {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    mutableParameters[@"type"] = type;

    JXHTTPOperation *request = [JXHTTPOperation withURLString:[self URLWithPath:blogPath(@"post", blogName)]];
    request.requestMethod = @"POST";
    request.continuesInAppBackground = YES;
    request.requestBody = [self multipartBodyForParameters:mutableParameters filePathArray:filePathArray
                                          contentTypeArray:contentTypeArray fileNameArray:fileNameArray];
    request.requestTimeoutInterval = self.timeoutInterval;
    
    [self signRequest:request withParameters:mutableParameters];
    
    return request;
}

- (JXHTTPMultipartBody *)multipartBodyForParameters:(NSDictionary *)parameters filePathArray:(NSArray *)filePathArray
                                   contentTypeArray:(NSArray *)contentTypeArray fileNameArray:(NSArray *)fileNameArray {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPMultipartBody *multipartBody = [JXHTTPMultipartBody withDictionary:mutableParameters];
    
    BOOL multiple = [filePathArray count] > 1;
    
    [filePathArray enumerateObjectsUsingBlock:^(NSString *path, NSUInteger index, BOOL *stop) {
        [multipartBody addFile:path forKey:multiple ? [NSString stringWithFormat:@"data[%lu]", (unsigned long)index] : @"data"
                   contentType:contentTypeArray[index] fileName:fileNameArray[index]];
    }];
    
    return multipartBody;
}

- (void)signRequest:(JXHTTPOperation *)request withParameters:(NSDictionary *)parameters {
    [request setValue:@"TMTumblrSDK" forRequestHeader:@"User-Agent"];
    
    for (NSString *header in self.customHeaders)
        [request setValue:self.customHeaders[header] forRequestHeader:header];
    
    [request setValue:[TMOAuth headerForURL:request.requestURL method:request.requestMethod postParameters:parameters
                                      nonce:request.uniqueString consumerKey:self.OAuthConsumerKey
                             consumerSecret:self.OAuthConsumerSecret token:self.OAuthToken
                                tokenSecret:self.OAuthTokenSecret] forRequestHeader:@"Authorization"];
}

- (void)sendRequest:(JXHTTPOperation *)request callback:(TMAPICallback)callback {
    [self sendRequest:request queue:self.defaultCallbackQueue callback:callback];
}

- (void)sendRequest:(JXHTTPOperation *)request queue:(NSOperationQueue *)queue callback:(TMAPICallback)callback {
    if (callback) {
        __block typeof(callback) blockCallback = callback;
        
        request.didFinishLoadingBlock = ^(JXHTTPOperation *operation) {
            NSDictionary *response = operation.responseJSON;
            int statusCode = response[@"meta"] ? [response[@"meta"][@"status"] intValue] : 0;
            
            NSError *error = nil;
            
            if (statusCode/100 != 2)
                error = [NSError errorWithDomain:@"Request failed" code:statusCode userInfo:nil];
            
            [queue addOperationWithBlock:^{
                blockCallback(response[@"response"], error);
                blockCallback = nil;
            }];
        };
        
        request.didFailBlock = ^(JXHTTPOperation *operation) {
            [queue addOperationWithBlock:^{
                blockCallback(nil, operation.error);
                blockCallback = nil;
            }];
        };
    }
    
    [self.queue addOperation:request];
}

- (NSString *)URLWithPath:(NSString *)path {
    return [[self.baseURL URLByAppendingPathComponent:path] absoluteString];
}

NSString *blogPath(NSString *ext, NSString *blogName) {
    return [NSString stringWithFormat:@"blog/%@/%@", fullBlogName(blogName), ext];
}

NSString *fullBlogName(NSString *blogName) {
    if ([blogName rangeOfString:@"."].location == NSNotFound) {
        return blogName = [blogName stringByAppendingString:@".tumblr.com"];
    }
    
    return blogName;
}

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        self.queue = [[JXHTTPOperationQueue alloc] init];
        self.defaultCallbackQueue = [NSOperationQueue mainQueue];
        self.timeoutInterval = TMAPIClientDefaultRequestTimeoutInterval;
        self.baseURL = [NSURL URLWithString:@"https://api.tumblr.com/v2/"];
    }
    
    return self;
}

@end
