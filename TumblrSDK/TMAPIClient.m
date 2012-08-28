//
//  TMAPIClient.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"
#import "TMOAuth.h"

static NSString * const TMAPIBaseURL = @"http://api.tumblr.com/v2/";

// Parameter keys
static NSString * const TMAPIParameterAPIKey = @"api_key";
static NSString * const TMAPIParameterLimit = @"limit";
static NSString * const TMAPIParameterOffset = @"offset";
static NSString * const TMAPIParameterTag = @"tag";
static NSString * const TMAPIParameterURL = @"url";
static NSString * const TMAPIParameterPostID = @"id";
static NSString * const TMAPIParameterReblogKey = @"reblog_key";
static NSString * const TMAPIParameterType = @"type";

// Response keys
static NSString * const TMAPIResponseKeyMeta = @"meta";
static NSString * const TMAPIResponseKeyStatus = @"status";
static NSString * const TMAPIResponseKeyResponse = @"response";


@interface TMAPIClient()

@property (nonatomic, retain) JXHTTPOperationQueue *queue;

- (void)get:(NSString *)path parameters:(NSDictionary *)parameters success:(TMAPICallback)success
      error:(TMAPIErrorCallback)error;

- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error;

- (void)createPost:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
           success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)sendRequest:(JXHTTPOperation *)request success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

NSMutableDictionary *nilSafeMutableDictionary(NSDictionary *dictionary);

@end


@implementation TMAPIClient

#pragma mark - Blog methods

- (void)blogInfo:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/info", blogName] parameters:@{ TMAPIParameterAPIKey : self.APIKey }
      success:success error:error];
}

- (void)followers:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
            error:(TMAPIErrorCallback)error {
    [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/followers", blogName] parameters:parameters success:success
        error:error];
}

- (void)avatar:(NSString *)blogName size:(int)size success:(TMAPIDataCallback)success error:(TMAPIErrorCallback)error {
    NSString *URLString = [TMAPIBaseURL stringByAppendingString:[NSString stringWithFormat:@"blog/%@.tumblr.com/avatar/%d",
                                                                 blogName, size]];
    
    __block JXHTTPOperation *request = [JXHTTPOperation withURLString:URLString];
    
    request.completionBlock = ^ {
        if (request.responseStatusCode == 200) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(request.responseData);
                });
            }
        } else {
            error([NSError errorWithDomain:@"Request failed" code:request.responseStatusCode userInfo:nil]);
        }
    };

    [self.queue addOperation:request];
}

- (void)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
      success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    NSString *path = [NSString stringWithFormat:@"blog/%@.tumblr.com/posts", blogName];
    if (type) path = [path stringByAppendingFormat:@"/%@", type];
    
    NSMutableDictionary *mutableParameters = nilSafeMutableDictionary(parameters);
    mutableParameters[TMAPIParameterAPIKey] = self.APIKey;
    
    [self get:path parameters:mutableParameters success:success error:error];
}

- (void)queue:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error {
    [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/queue", blogName] parameters:parameters
      success:success error:error];
}

- (void)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
         error:(TMAPIErrorCallback)error {
    [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/draft", blogName] parameters:parameters
      success:success error:error];
}

- (void)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
              error:(TMAPIErrorCallback)error {
    [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/submission", blogName] parameters:parameters
      success:success error:error];
}

#pragma mark - Posting methods

- (void)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
           error:(TMAPIErrorCallback)error {
    [self post:@"post/edit" parameters:parameters success:success error:error];
}

- (void)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
             error:(TMAPIErrorCallback)error {
    [self post:@"post/reblog" parameters:parameters success:success error:error];
}

- (void)deletePost:(NSString *)blogName id:(NSString *)postID success:(TMAPICallback)success
             error:(TMAPIErrorCallback)error {
    [self post:@"post/delete" parameters:@{ TMAPIParameterPostID : postID } success:success error:error];
}

- (void)text:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error {
    [self createPost:blogName type:@"text" parameters:parameters success:success error:error];
}

- (void)quote:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error {
    [self createPost:blogName type:@"quote" parameters:parameters success:success error:error];
}

- (void)link:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error {
    [self createPost:blogName type:@"link" parameters:parameters success:success error:error];
}

- (void)chat:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error {
    [self createPost:blogName type:@"chat" parameters:parameters success:success error:error];
}

- (void)audio:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error {
    // TODO
}

- (void)video:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error {
    // TODO
}

- (void)photo:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error {
    // TODO
}

#pragma mark - User methods

- (void)userInfo:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self get:@"user/info" parameters:nil success:success error:error];
}

- (void)dashboard:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self get:@"user/dashboard" parameters:parameters success:success error:error];
}

- (void)likes:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self get:@"user/likes" parameters:parameters success:success error:error];
}

- (void)following:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self get:@"user/following" parameters:parameters success:success error:error];
}

- (void)follow:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self post:@"/user/follow" parameters:@{ TMAPIParameterURL : [NSString stringWithFormat:@"blog/%@.tumblr.com", blogName] }
       success:success error:error];
}

- (void)unfollow:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self post:@"/user/unfollow" parameters:@{ TMAPIParameterURL : [NSString stringWithFormat:@"blog/%@.tumblr.com", blogName] }
       success:success error:error];
}

- (void)like:(NSString *)postID reblogKey:(NSString *)reblogKey success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error {
    [self post:@"/user/like" parameters:@{ TMAPIParameterPostID : postID, TMAPIParameterReblogKey : reblogKey }
       success:success error:error];
}

- (void)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey success:(TMAPICallback)success
         error:(TMAPIErrorCallback)error {
    [self post:@"/user/unlike" parameters:@{ TMAPIParameterPostID : postID, TMAPIParameterReblogKey : reblogKey }
       success:success error:error];
}

#pragma mark - Tagged methods

- (void)tagged:(NSString *)tag parameters:(NSDictionary *)parameters success:(TMAPICallback)success
         error:(TMAPIErrorCallback)error {
    NSMutableDictionary *mutableParameters = nilSafeMutableDictionary(parameters);
    mutableParameters[TMAPIParameterTag] = tag;
    mutableParameters[TMAPIParameterAPIKey] = self.APIKey;
    
    [self get:@"tagged" parameters:mutableParameters success:success error:error];
}

#pragma mark - Initialization

- (id)init {
    if (self = [super init]) {
        _queue = [[JXHTTPOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

+ (id)sharedInstance {
    static TMAPIClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[TMAPIClient alloc] init]; });
    return instance;
}

#pragma mark - Convenience

- (void)get:(NSString *)path parameters:(NSDictionary *)parameters success:(TMAPICallback)success
      error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [JXHTTPOperation withURLString:[TMAPIBaseURL stringByAppendingString:path]
                                              queryParameters:parameters];
    
    [self sendRequest:request success:success error:error];
}

- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [JXHTTPOperation withURLString:[TMAPIBaseURL stringByAppendingString:path]];
    request.requestBody = [JXHTTPJSONBody withJSONObject:parameters];

    [self sendRequest:request success:success error:error];
}

- (void)createPost:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
           success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    NSMutableDictionary *mutableParameters = nilSafeMutableDictionary(parameters);
    mutableParameters[TMAPIParameterType] = type;
    
    [self post:[NSString stringWithFormat:@"blog/%@.tumblr.com/post", blogName] parameters:mutableParameters success:success
         error:error];
}

- (void)sendRequest:(JXHTTPOperation *)request success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    __block JXHTTPOperation *blockRequest = request;
    
    request.completionBlock = ^ {
        NSDictionary *response = blockRequest.responseJSON;
        int statusCode = response[TMAPIResponseKeyMeta] ? [response[TMAPIResponseKeyMeta][TMAPIResponseKeyStatus] intValue] : 0;
        
        if (statusCode == 200) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(response[TMAPIResponseKeyResponse]);
                });
            }
        } else {
            NSLog(@"%@", request.requestURL);
            
            if (error) {
                // TODO: Pass blog or user errors from server in user info dictionary
                dispatch_async(dispatch_get_main_queue(), ^{
                    error([NSError errorWithDomain:@"Request failed" code:statusCode userInfo:nil]);
                });
            }
        }
    };
    
    NSString *authorizationHeaderValue = [TMOAuth authorizationHeaderForRequest:request
                                                                          nonce:request.uniqueIDString
                                                                    consumerKey:self.OAuthConsumerKey
                                                                 consumerSecret:self.OAuthConsumerSecret
                                                                          token:self.OAuthToken
                                                                    tokenSecret:self.OAuthTokenSecret];
    
    [request setValue:authorizationHeaderValue forRequestHeader:@"Authorization"];
    
    [self.queue addOperation:request];
}

NSMutableDictionary *nilSafeMutableDictionary(NSDictionary *dictionary) {
    return dictionary ? [NSMutableDictionary dictionaryWithDictionary:dictionary] : [NSMutableDictionary dictionary];
}

#pragma mark - Memory management

- (void)dealloc {
    self.APIKey = nil;
    self.OAuthConsumerKey = nil;
    self.OAuthConsumerSecret = nil;
    self.OAuthToken = nil;
    self.OAuthTokenSecret = nil;
    
    self.queue = nil;
    
    [super dealloc];
}

@end
