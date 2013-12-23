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
#import "TMHTTPRequestSerializer.h"
#import "TMTumblrAuthenticator.h"

@interface TMAPIClient() <TMHTTPSessionManagerDelegate, TMHTTPRequestSerializerDelegate>

@property (nonatomic, strong) TMHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;

NSString *blogPath(NSString *ext, NSString *blogName);

NSString *fullBlogName(NSString *blogName);

@end


@implementation TMAPIClient

+ (id)sharedInstance {
    static TMAPIClient *instance;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[TMAPIClient alloc] init];
    });
    
    return instance;
}

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        self.sessionManager = [[TMHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.tumblr.com/v2/"]
                                                       sessionConfiguration:nil];
        self.sessionManager.delegate = self;
        self.sessionManager.requestSerializer = [[TMHTTPRequestSerializer alloc] initWithDelegate:self];
    }
    
    return self;
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

- (void)setOAuthConsumerSecret:(NSString *)OAuthConsumerSecret {
    [TMTumblrAuthenticator sharedInstance].OAuthConsumerSecret = OAuthConsumerSecret;
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

- (NSURLSessionDataTask *)avatar:(NSString *)blogName size:(NSInteger)size callback:(TMAPICallback)callback {
    return [self.sessionManager GET:[blogPath(@"avatar", blogName) stringByAppendingFormat:@"/%d", size]
                         parameters:nil callback:callback];
}

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
    
    return [self.sessionManager GET:path parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)queue:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:blogPath(@"posts/queue", blogName) parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:blogPath(@"posts/draft", blogName) parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:blogPath(@"posts/submission", blogName) parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)likes:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:blogPath(@"likes", blogName) parameters:parameters callback:callback];
}

#pragma mark - Posting

- (NSURLSessionDataTask *)post:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"type"] = type;
    
    return [self.sessionManager POST:blogPath(@"post", blogName) parameters:mutableParameters callback:callback];
}

- (NSURLSessionDataTask *)post:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"type"] = type;
    
    return [self.sessionManager POST:blogPath(@"post", blogName) parameters:mutableParameters
           constructingBodyWithBlock:block callback:callback];
}

- (NSURLSessionDataTask *)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager POST:blogPath(@"post/edit", blogName) parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager POST:blogPath(@"post/reblog", blogName) parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)deletePost:(NSString *)blogName id:(NSString *)postID callback:(TMAPICallback)callback {
    return [self.sessionManager POST:blogPath(@"post/delete", blogName) parameters:@{ @"id": postID } callback:callback];
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
    void(^multipartConstructor)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        [filePathArrayOrNil enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger index, BOOL *stop) {
            NSString *contentType = contentTypeArrayOrNil[index];
            NSString *fileName = fileNameArrayOrNil[index];
            
            NSError *error = nil;
            
            [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:fileName fileName:fileName
                                   mimeType:contentType error:&error];
        }];
    };
    
    return [self post:blogName type:@"photo" parameters:parameters constructingBodyWithBlock:multipartConstructor callback:callback];
}

- (NSURLSessionDataTask *)video:(NSString *)blogName filePath:(NSString *)filePathOrNil
                    contentType:(NSString *)contentTypeOrNil fileName:(NSString *)fileNameOrNil
                     parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    void(^multipartConstructor)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        NSError *error = nil;
        
        [formData appendPartWithFileURL:[NSURL URLWithString:filePathOrNil] name:fileNameOrNil fileName:fileNameOrNil
                               mimeType:contentTypeOrNil error:&error];
    };
    
    return [self post:blogName type:@"photo" parameters:parameters constructingBodyWithBlock:multipartConstructor callback:callback];
}

- (NSURLSessionDataTask *)audio:(NSString *)blogName filePath:(NSString *)filePathOrNil
                    contentType:(NSString *)contentTypeOrNil fileName:(NSString *)fileNameOrNil
                     parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    void(^multipartConstructor)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        NSError *error = nil;
        
        [formData appendPartWithFileURL:[NSURL URLWithString:filePathOrNil] name:fileNameOrNil fileName:fileNameOrNil
                               mimeType:contentTypeOrNil error:&error];
    };
    
    return [self post:blogName type:@"audio" parameters:parameters constructingBodyWithBlock:multipartConstructor callback:callback];
}

#pragma mark - Tagging

- (NSURLSessionDataTask *)tagged:(NSString *)tag parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"tag"] = tag;
    
    return [self.sessionManager GET:@"tagged" parameters:mutableParameters callback:callback];
}

#pragma mark - Private

NSString *blogPath(NSString *ext, NSString *blogName) {
    return [NSString stringWithFormat:@"blog/%@/%@", fullBlogName(blogName), ext];
}

NSString *fullBlogName(NSString *blogName) {
    if ([blogName rangeOfString:@"."].location == NSNotFound) {
        return blogName = [blogName stringByAppendingString:@".tumblr.com"];
    }
    
    return blogName;
}

@end
