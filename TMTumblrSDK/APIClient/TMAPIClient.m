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

@interface TMAPIClient()

@property (nonatomic, strong) TMHTTPSessionManager *sessionManager;

@end


@implementation TMAPIClient

+ (instancetype)sharedInstance {
    static TMAPIClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[self alloc] init]; });
    return instance;
}

#pragma mark - NSObject

- (instancetype)initWithSessionManager:(TMHTTPSessionManager *)sessionManager {
    if (self = [super init]) {
        self.sessionManager = sessionManager;
    }
    
    return self;
}

#pragma mark - Authentication

- (void)authenticate:(NSString *)URLScheme callback:(void(^)(NSError *))callback {
    [[TMTumblrAuthenticator sharedInstance] authenticate:URLScheme callback:^(NSString *token, NSString *secret, NSError *error) {
        self.sessionManager.OAuthToken = token;
        self.sessionManager.OAuthTokenSecret = secret;
        
        if (callback) {
            callback(error);
        }
    }];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [[TMTumblrAuthenticator sharedInstance] handleOpenURL:url];
}

- (void)xAuth:(NSString *)emailAddress password:(NSString *)password callback:(void(^)(NSError *))callback {
    return [[TMTumblrAuthenticator sharedInstance] xAuth:emailAddress password:password callback:^(NSString *token, NSString *secret, NSError *error) {
        self.sessionManager.OAuthToken = token;
        self.sessionManager.OAuthTokenSecret = secret;
        
        if (callback) {
            callback(error);
        }
    }];
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
    return [self.sessionManager POST:@"user/follow" parameters:@{ @"url" : TMFullyQualifiedBlogHost(blogName) } callback:callback];
}

- (NSURLSessionDataTask *)unfollow:(NSString *)blogName callback:(TMAPICallback)callback {
    return [self.sessionManager POST:@"user/unfollow" parameters:@{ @"url" : TMFullyQualifiedBlogHost(blogName) } callback:callback];
}

- (NSURLSessionDataTask *)like:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback {
    return [self.sessionManager POST:@"user/like" parameters:@{ @"id" : postID, @"reblog_key" : reblogKey } callback:callback];
}

- (NSURLSessionDataTask *)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback {
    return [self.sessionManager POST:@"user/unlike" parameters:@{ @"id" : postID, @"reblog_key" : reblogKey } callback:callback];
}

#pragma mark - Blog

- (NSURLSessionDataTask *)avatar:(NSString *)blogName size:(NSUInteger)size callback:(TMAPICallback)callback {
    return [self.sessionManager GET:[TMBlogPath(@"avatar", blogName) stringByAppendingFormat:@"/%ld", size]
                         parameters:nil callback:callback];
}

- (NSURLSessionDataTask *)blogInfo:(NSString *)blogName callback:(TMAPICallback)callback {
    return [self.sessionManager GET:TMBlogPath(@"info", blogName) parameters:nil callback:callback];
}

- (NSURLSessionDataTask *)followers:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:TMBlogPath(@"followers", blogName) parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    NSString *path = TMBlogPath(@"posts", blogName);
    
    if (type) {
        path = [path stringByAppendingFormat:@"/%@", type];
    }
    
    return [self.sessionManager GET:path parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)queue:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:TMBlogPath(@"posts/queue", blogName) parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:TMBlogPath(@"posts/draft", blogName) parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:TMBlogPath(@"posts/submission", blogName) parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)likes:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager GET:TMBlogPath(@"likes", blogName) parameters:parameters callback:callback];
}

#pragma mark - Posting

- (NSURLSessionDataTask *)post:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"type"] = type;
    
    return [self.sessionManager POST:TMBlogPath(@"post", blogName) parameters:mutableParameters callback:callback];
}

- (NSURLSessionDataTask *)post:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"type"] = type;
    
    return [self.sessionManager POST:TMBlogPath(@"post", blogName) parameters:mutableParameters constructingBodyWithBlock:block callback:callback];
}

- (NSURLSessionDataTask *)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager POST:TMBlogPath(@"post/edit", blogName) parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self.sessionManager POST:TMBlogPath(@"post/reblog", blogName) parameters:parameters callback:callback];
}

- (NSURLSessionDataTask *)deletePost:(NSString *)blogName id:(NSString *)postID callback:(TMAPICallback)callback {
    return [self.sessionManager POST:TMBlogPath(@"post/delete", blogName) parameters:@{ @"id": postID } callback:callback];
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
            
            [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:@"photo" fileName:fileName mimeType:contentType error:&error];
        }];
    };
    
    return [self post:blogName type:@"photo" parameters:parameters constructingBodyWithBlock:multipartConstructor callback:callback];
}

- (NSURLSessionDataTask *)video:(NSString *)blogName filePath:(NSString *)filePathOrNil
                    contentType:(NSString *)contentTypeOrNil fileName:(NSString *)fileNameOrNil
                     parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    void(^multipartConstructor)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        NSError *error = nil;
        
        [formData appendPartWithFileURL:[NSURL URLWithString:filePathOrNil] name:@"video" fileName:fileNameOrNil mimeType:contentTypeOrNil error:&error];
    };
    
    return [self post:blogName type:@"photo" parameters:parameters constructingBodyWithBlock:multipartConstructor callback:callback];
}

- (NSURLSessionDataTask *)audio:(NSString *)blogName filePath:(NSString *)filePathOrNil
                    contentType:(NSString *)contentTypeOrNil fileName:(NSString *)fileNameOrNil
                     parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    void(^multipartConstructor)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        NSError *error = nil;
        
        [formData appendPartWithFileURL:[NSURL URLWithString:filePathOrNil] name:@"audio" fileName:fileNameOrNil mimeType:contentTypeOrNil error:&error];
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

static NSString *TMBlogPath(NSString *path, NSString *blogName) {
    return [NSString stringWithFormat:@"blog/%@/%@", TMFullyQualifiedBlogHost(blogName), path];
}

static NSString *TMFullyQualifiedBlogHost(NSString *blogName) {
    if ([blogName rangeOfString:@"."].location == NSNotFound) {
        return blogName = [blogName stringByAppendingString:@".tumblr.com"];
    }
    
    return blogName;
}

@end