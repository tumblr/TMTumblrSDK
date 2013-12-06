//
//  TMAPIClient.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2013 Tumlr. All rights reserved.
//

#import "TMAPIClient.h"

#import "TMHTTPSessionManager.h"
#import "TMOAuth.h"
#import "TMTumblrAuthenticator.h"

static NSTimeInterval const TMAPIClientDefaultRequestTimeoutInterval = 60;

@interface TMAPIClient()

@property (nonatomic, strong) TMHTTPSessionManager *sessionManager;

NSString *blogPath(NSString *ext, NSString *blogName);

NSString *fullBlogName(NSString *blogName);

NSString *URLWithPath(NSString *path);

@end


@implementation TMAPIClient

+ (id)sharedInstance {
    static TMAPIClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[TMAPIClient alloc] init]; });
    return instance;
}

#pragma mark - Authentication

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

- (NSString *)OAuthConsumerSecret {
    return [TMTumblrAuthenticator sharedInstance].OAuthConsumerSecret;
}

#pragma mark - User

- (NSURLSessionDataTask *)userInfo:(TMAPICallback)callback {
    return [self.sessionManager GET:@"user/info" parameters:nil callback:callback];
}

- (NSURLSessionDataTask *)dashboard:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:@"user/dashboard" parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)likes:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:@"user/likes" parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)following:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:@"user/following" parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)follow:(NSString *)blogName callback:(TMAPICallback)callback {
    return [self.sessionManager POST:@"user/follow" parameters:@{ @"url" : fullBlogName(blogName) } callback:callback];
}

- (NSURLSessionDataTask *)unfollow:(NSString *)blogName callback:(TMAPICallback)callback {
    return [self.sessionManager POST:@"user/unfollow" parameters:@{ @"url" : fullBlogName(blogName) } callback:callback];
}

- (NSURLSessionDataTask *)like:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback {
    return [self.sessionManager POST:@"user/like" parameters:@{ @"id" : postID, @"reblog_key" : reblogKey } callback:callback];
}

- (NSURLSessionDataTask *)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback {
    return [self.sessionManager POST:@"user/unlike" parameters:@{ @"id" : postID, @"reblog_key" : reblogKey } callback:callback];
}

#pragma mark - Blog

- (NSURLSessionDataTask *)avatar:(NSString *)blogName size:(int)size callback:(TMAPICallback)callback {
    [self avatar:blogName size:size queue:self.defaultCallbackQueue callback:callback];
}
/*
 - (void)avatar:(NSString *)blogName size:(int)size queue:(NSOperationQueue *)queue callback:(TMAPICallback)callback {
 NSURLSessionDataTask *request = [self getRequestWithPath:[blogPath(@"avatar", blogName) stringByAppendingFormat:@"/%d", size]
 parameters:nil];
 
 if (callback) {
 __block typeof(callback) blockCallback = callback;
 
 request.didFinishLoadingBlock = ^(NSURLSessionDataTask *operation) {
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
 
 request.didFailBlock = ^(NSURLSessionDataTask *operation) {
 [queue addOperationWithBlock:^{
 blockCallback(nil, operation.error);
 blockCallback = nil;
 }];
 };
 }
 
 [self.queue addOperation:request];
 }
 */
- (NSURLSessionDataTask *)blogInfo:(NSString *)blogName callback:(TMAPICallback)callback {
    return [self.sessionManager GET:blogPath(@"info", blogName) parameters:nil callback:callback];
}

- (NSURLSessionDataTask *)followers:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:blogPath(@"followers", blogName) parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    NSString *path = blogPath(@"posts", blogName);
    
    if (type) {
        path = [path stringByAppendingFormat:@"/%@", type];
    }
    
    return [self getRequestWithPath:path parameters:parameters];
}

- (NSURLSessionDataTask *)queue:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self getRequestWithPath:blogPath(@"posts/queue", blogName) parameters:parameters];
}

- (NSURLSessionDataTask *)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self getRequestWithPath:blogPath(@"posts/draft", blogName) parameters:parameters];
}

- (NSURLSessionDataTask *)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self getRequestWithPath:blogPath(@"posts/submission", blogName) parameters:parameters];
}

- (NSURLSessionDataTask *)likes:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self getRequestWithPath:blogPath(@"likes", blogName) parameters:parameters];
}

#pragma mark - Posting

- (NSURLSessionDataTask *)post:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"type"] = type;
    
    return [self postRequestWithPath:blogPath(@"post", blogName) parameters:mutableParameters];
}

- (NSURLSessionDataTask *)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self postRequestWithPath:blogPath(@"post/edit", blogName) parameters:parameters];
}

- (NSURLSessionDataTask *)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self postRequestWithPath:blogPath(@"post/reblog", blogName) parameters:parameters];
}

- (NSURLSessionDataTask *)deletePost:(NSString *)blogName id:(NSString *)postID callback:(TMAPICallback)callback {
    return [self postRequestWithPath:blogPath(@"post/delete", blogName) parameters:@{ @"id": postID }];
}

#pragma mark -  Posting (convenience)

- (NSURLSessionDataTask *)text:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self post:blogName type:@"text" parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)quote:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self post:blogName type:@"quote" parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)link:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self post:blogName type:@"link" parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)chat:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self post:blogName type:@"chat" parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)photo:(NSString *)blogName filePathArray:(NSArray *)filePathArrayOrNil
               contentTypeArray:(NSArray *)contentTypeArrayOrNil fileNameArray:(NSArray *)fileNameArrayOrNil
                     parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self multipartPost:blogName type:@"photo" parameters:parameters filePathArray:filePathArrayOrNil
              contentTypeArray:contentTypeArrayOrNil fileNameArray:fileNameArrayOrNil];
}

- (NSURLSessionDataTask *)video:(NSString *)blogName filePath:(NSString *)filePathOrNil
                    contentType:(NSString *)contentTypeOrNil fileName:(NSString *)fileNameOrNil
                     parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self multipartPost:blogName type:@"video" parameters:parameters
                 filePathArray:filePathOrNil ? @[filePathOrNil] : nil
              contentTypeArray:contentTypeOrNil ? @[contentTypeOrNil] : nil
                 fileNameArray:fileNameOrNil ? @[fileNameOrNil] : nil];
}

- (NSURLSessionDataTask *)audio:(NSString *)blogName filePath:(NSString *)filePathOrNil
                    contentType:(NSString *)contentTypeOrNil fileName:(NSString *)fileNameOrNil
                     parameters:(NSDictionary *)parameters {
    return [self multipartPost:blogName type:@"audio" parameters:parameters
                 filePathArray:filePathOrNil ? @[filePathOrNil] : nil
              contentTypeArray:contentTypeOrNil ? @[contentTypeOrNil] : nil
                 fileNameArray:fileNameOrNil ? @[fileNameOrNil] : nil];
}

#pragma mark - Tagging

- (NSURLSessionDataTask *)tagged:(NSString *)tag parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"tag"] = tag;
    
    return [self getRequestWithPath:@"tagged" parameters:mutableParameters];
}

#pragma mark - Private

- (NSURLSessionDataTask *)getRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    [self.sessionManager GET:path parameters:mutableParameters];
    NSURLSessionDataTask *request = [NSURLSessionDataTask withURLString:URLWithPath(path) queryParameters:mutableParameters];
    request.continuesInAppBackground = YES;
    request.requestTimeoutInterval = self.timeoutInterval;
    
    [self sign:request withParameters:nil];
    
    return request;
}

- (NSURLSessionDataTask *)postRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    NSURLSessionDataTask *request = [NSURLSessionDataTask withURLString:URLWithPath(path)];
    request.requestMethod = @"POST";
    request.continuesInAppBackground = YES;
    request.requestBody = [JXHTTPFormEncodedBody withDictionary:mutableParameters];
    request.requestTimeoutInterval = self.timeoutInterval;
    
    [self sign:request withParameters:mutableParameters];
    
    return request;
}

- (NSURLSessionDataTask *)multipartPost:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
                          filePathArray:(NSArray *)filePathArray contentTypeArray:(NSArray *)contentTypeArray
                          fileNameArray:(NSArray *)fileNameArray {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    mutableParameters[@"type"] = type;
    
    NSURLSessionDataTask *request = [NSURLSessionDataTask withURLString:URLWithPath(blogPath(@"post", blogName))];
    request.requestMethod = @"POST";
    request.continuesInAppBackground = YES;
    request.requestBody = [self multipartBodyForParameters:mutableParameters filePathArray:filePathArray
                                          contentTypeArray:contentTypeArray fileNameArray:fileNameArray];
    request.requestTimeoutInterval = self.timeoutInterval;
    
    [self sign:request withParameters:mutableParameters];
    
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

- (void)sign:(NSURLSessionDataTask *)request withParameters:(NSDictionary *)parameters {
    [request setValue:@"TMTumblrSDK" forRequestHeader:@"User-Agent"];
    
    for (NSString *header in self.customHeaders)
        [request setValue:self.customHeaders[header] forRequestHeader:header];
    
    [request setValue:[TMOAuth headerForURL:request.requestURL method:request.requestMethod postParameters:parameters
                                      nonce:request.uniqueString consumerKey:self.OAuthConsumerKey
                             consumerSecret:self.OAuthConsumerSecret token:self.OAuthToken
                                tokenSecret:self.OAuthTokenSecret] forRequestHeader:@"Authorization"];
}

//- (void)send:(NSURLSessionDataTask *)request callback:(TMAPICallback)callback {
//    [self send:request queue:self.defaultCallbackQueue callback:callback];
//}
//
//- (void)send:(NSURLSessionDataTask *)request queue:(NSOperationQueue *)queue callback:(TMAPICallback)callback {
//    if (callback) {
//        __block typeof(callback) blockCallback = callback;
//
//        request.didFinishLoadingBlock = ^(NSURLSessionDataTask *operation) {
//            NSDictionary *response = operation.responseJSON;
//            int statusCode = response[@"meta"] ? [response[@"meta"][@"status"] intValue] : 0;
//
//            NSError *error = nil;
//
//            if (statusCode/100 != 2)
//                error = [NSError errorWithDomain:@"Request failed" code:statusCode userInfo:nil];
//
//            [queue addOperationWithBlock:^{
//                blockCallback(response[@"response"], error);
//                blockCallback = nil;
//            }];
//        };
//
//        request.didFailBlock = ^(NSURLSessionDataTask *operation) {
//            [queue addOperationWithBlock:^{
//                blockCallback(nil, operation.error);
//                blockCallback = nil;
//            }];
//        };
//    }
//
//    [self.queue addOperation:request];
//}

NSString *blogPath(NSString *ext, NSString *blogName) {
    return [NSString stringWithFormat:@"blog/%@/%@", fullBlogName(blogName), ext];
}

NSString *fullBlogName(NSString *blogName) {
    if ([blogName rangeOfString:@"."].location == NSNotFound) {
        return blogName = [blogName stringByAppendingString:@".tumblr.com"];
    }
    
    return blogName;
}

NSString *URLWithPath(NSString *path) {
    return [@"http://api.tumblr.com/v2/" stringByAppendingString:path];
}

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        self.sessionManager = [[TMHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.tumblr.com/v2/"]];
        
        self.queue = [[NSURLSessionDataTaskQueue alloc] init];
        self.defaultCallbackQueue = [NSOperationQueue mainQueue];
        self.timeoutInterval = TMAPIClientDefaultRequestTimeoutInterval;
    }
    
    return self;
}

@end
