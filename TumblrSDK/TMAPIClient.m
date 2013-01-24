//
//  TMAPIClient.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

#import "TMOAuth.h"

@interface TMAPIClient()

@property (nonatomic, copy) TMAuthenticationCallback authCallback;

@end

@implementation TMAPIClient

+ (id)sharedInstance {
    static TMAPIClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[TMAPIClient alloc] init]; });
    return instance;
}

#pragma mark - Authentication

- (void)authenticate:(NSString *)URLScheme callback:(TMAuthenticationCallback)callback {
    [[TMTumblrAuthenticator sharedInstance] authenticate:URLScheme callback:callback];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [[TMTumblrAuthenticator sharedInstance] handleOpenURL:url];
}

- (void)xAuth:(NSString *)emailAddress password:(NSString *)password callback:(TMAuthenticationCallback)callback {
    return [[TMTumblrAuthenticator sharedInstance] xAuth:emailAddress password:password callback:callback];
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

- (JXHTTPOperation *)postRequest:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"type"] = type;
    
    return [self postRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/post", blogName]
                          parameters:mutableParameters];
}

- (void)post:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self postRequest:blogName type:type parameters:parameters] callback:callback];
}

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

- (JXHTTPOperation *)photoRequest:(NSString *)blogName dataArray:(NSArray *)dataArrayOrNil
                    filePathArray:(NSArray *)filePathArrayOrNil contentTypeArray:(NSArray *)contentTypeArray
                       parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"type"] = @"photo";
    
    JXHTTPMultipartBody *body = [self multipartBodyForParameters:mutableParameters dataArray:dataArrayOrNil
                                                   filePathArray:filePathArrayOrNil contentTypeArray:contentTypeArray];
    
    return [self postRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/post", blogName]
                          parameters:parameters body:body];
}

- (void)photo:(NSString *)blogName dataArray:(NSArray *)dataArrayOrNil filePathArray:(NSArray *)filePathArrayOrNil
contentTypeArray:(NSArray *)contentTypeArray parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self photoRequest:blogName dataArray:dataArrayOrNil filePathArray:filePathArrayOrNil
                        contentTypeArray:contentTypeArray parameters:parameters] callback:(TMAPICallback)callback];
}

- (JXHTTPOperation *)videoRequest:(NSString *)blogName data:(NSData *)dataOrNil filePath:(NSString *)filePathOrNil
                      contentType:(NSString *)contentType parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"type"] = @"video";
    
    JXHTTPMultipartBody *body = [self multipartBodyForParameters:mutableParameters
                                                       dataArray:dataOrNil ? @[dataOrNil] : nil
                                                   filePathArray:filePathOrNil ? @[filePathOrNil] : nil
                                                contentTypeArray:@[contentType]];
    
    return [self postRequestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/post", blogName]
                          parameters:parameters body:body];
}

- (void)video:(NSString *)blogName data:(NSData *)dataOrNil filePath:(NSString *)filePathOrNil
  contentType:(NSString *)contentType parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    [self sendRequest:[self videoRequest:blogName data:dataOrNil filePath:filePathOrNil contentType:contentType
                              parameters:parameters] callback:(TMAPICallback)callback];

}

- (JXHTTPMultipartBody *)multipartBodyForParameters:(NSDictionary *)parameters dataArray:(NSArray *)dataArrayOrNil
                                      filePathArray:(NSArray *)filePathArrayOrNil contentTypeArray:(NSArray *)contentTypeArray {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPMultipartBody *multipartBody = [JXHTTPMultipartBody withDictionary:mutableParameters];
    
    BOOL multiple = filePathArrayOrNil ? [filePathArrayOrNil count] > 1 : [dataArrayOrNil count] > 1;
    
    NSString *(^keyForIndex)(int) = ^ (int index) {
        return multiple ? [NSString stringWithFormat:@"data[%d]", index] : @"data";
    };
    
    NSString *fileName = @"foo.bar"; // Should be using something better here?
    
    if (filePathArrayOrNil) {
        [filePathArrayOrNil enumerateObjectsUsingBlock:^(NSString *path, NSUInteger index, BOOL *stop) {
            [multipartBody addFile:path forKey:keyForIndex(index) contentType:contentTypeArray[index] fileName:fileName];
        }];
    } else if (dataArrayOrNil) {
        [dataArrayOrNil enumerateObjectsUsingBlock:^(NSData *data, NSUInteger index, BOOL *stop) {
            [multipartBody addData:data forKey:keyForIndex(index) contentType:contentTypeArray[index] fileName:fileName];
        }];
    }
    
    return multipartBody;
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
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:URLWithPath(path) queryParameters:mutableParameters];
    request.continuesInAppBackground = YES;
    
    [self signRequest:request withParameters:nil];
    
    return request;
}

- (JXHTTPOperation *)postRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:URLWithPath(path)];
    request.requestMethod = @"POST";
    request.continuesInAppBackground = YES;
    request.requestBody = [JXHTTPFormEncodedBody withDictionary:mutableParameters];
    
    [self signRequest:request withParameters:mutableParameters];
    
    return request;
}

- (JXHTTPOperation *)postRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters
                                    body:(id <JXHTTPRequestBody>) body {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:URLWithPath(path)];
    request.requestMethod = @"POST";
    request.continuesInAppBackground = YES;
    request.requestBody = body;
    [self signRequest:request withParameters:mutableParameters];
    
    return request;
}

- (void)signRequest:(JXHTTPOperation *)request withParameters:(NSDictionary *)parameters {
    for (NSString *header in self.customHeaders)
        [request setValue:self.customHeaders[header] forRequestHeader:header];
    
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
