//
//  TMRequestFactory.m
//  Orangina
//
//  Created by Bryan Irace on 3/26/15.
//  Copyright (c) 2015 Tumblr. All rights reserved.
//

#import "TMRequestFactory.h"
#import "TMRequest.h"
#import "TMAPIRequest.h"
#import "TMJSONEncodedRequestBody.h"
#import "TMFormEncodedRequestBody.h"
#import "TMMultipartRequestBody.h"
#import "TMMultipartRequestBodyFactory.h"
#import "TMRouteConstants.h"
#import "TMSDKFunctions.h"
#import "TMBaseURLDetermining.h"
#import "TMBasicBaseURLDeterminer.h"

NSString * _Nonnull const TMRequestFactoryInvalidateBaseURLNotificationKey = @"TMRequestFactoryInvalidateBaseURLNotificationKey";

@interface TMRequestFactory ()

@property (nonatomic, nonnull, readonly) NSURL *baseURL;
@property (nonatomic, nonnull, readonly) id <TMBaseURLDetermining> baseURLDeterminer;

@end

@implementation TMRequestFactory

#pragma mark - Initialization

- (nonnull instancetype)initWithBaseURLDeterminer:(nonnull id <TMBaseURLDetermining>)baseURLDeterminer {
    NSParameterAssert(baseURLDeterminer);

    self = [super init];
    if (self) {
        _baseURLDeterminer = baseURLDeterminer;
    }

    return self;
}

- (instancetype)init {
    return [self initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];
}

#pragma mark - TMBaseURLDetermining

- (NSURL *)baseURL {
    return [self.baseURLDeterminer baseURL];
}

#pragma mark - TMRequestFactory

- (nonnull id <TMRequest>)notesRequestWithPostID:(nonnull NSString *)postID blogUUID:(nonnull NSString *)blogUUID beforeDate:(nullable NSDate *)beforeDate {
    NSParameterAssert(postID);
    NSParameterAssert(blogUUID);

    NSMutableDictionary *parameters = [@{@"id" : postID} mutableCopy];

    if (beforeDate) {
        parameters[@"before_timestamp"] = @(round([beforeDate timeIntervalSince1970]));
    }

    return [self requestWithPath:[[NSString alloc] initWithFormat:@"blog/%@/notes", blogUUID] method:TMHTTPRequestMethodGET queryParameters:[parameters copy]];
}

- (nonnull id <TMRequest>)dashboardRequest:(nullable NSDictionary *)parameters {
    NSString * const TMRoutePathDashboard = @"user/dashboard";

    return [self requestWithPath:TMRoutePathDashboard
                          method:TMHTTPRequestMethodGET
                 queryParameters:parameters];

}

- (nonnull id <TMRequest>)unfollowRequest:(nonnull NSString *)blogName {
    NSParameterAssert(blogName);
    NSString * const TMRoutePathUnfollow = @"user/unfollow";
    return [self requestWithPath:TMRoutePathUnfollow
                          method:TMHTTPRequestMethodPOST
                 queryParameters:nil
                     requestBody:[[TMFormEncodedRequestBody alloc] initWithBody:@{ @"url" : fullBlogName(blogName) }]];
}

- (nonnull id <TMRequest>)followRequest:(nonnull NSString *)blogName parameters:(nullable NSDictionary *)parameters {
    NSParameterAssert(blogName);
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];

    [requestParameters setObject:fullBlogName(blogName) forKey:@"url"];
    [requestParameters addEntriesFromDictionary:parameters];

    NSString * const TMRoutePathFollow = @"user/follow";
    return [self requestWithPath:TMRoutePathFollow
                          method:TMHTTPRequestMethodPOST
                 queryParameters:nil
                     requestBody:[[TMFormEncodedRequestBody alloc] initWithBody:requestParameters]];
}

- (nonnull id <TMRequest>)deletePostRequest:(nonnull NSString *)blogName postID:(nonnull NSString *)postID {
    NSParameterAssert(blogName);
    NSParameterAssert(postID);
    NSString * const TMRouteBlogPathDelete = @"post/delete";
    return [self requestWithPath:blogPath(TMRouteBlogPathDelete, blogName)
                          method:TMHTTPRequestMethodPOST
                 queryParameters:nil
                     requestBody:[[TMFormEncodedRequestBody alloc] initWithBody:@{ @"id": postID }]];
}

- (nonnull id <TMRequest>)likeRequest:(nonnull NSString *)postID reblogKey:(nonnull NSString *)reblogKey {
    NSParameterAssert(postID);
    NSParameterAssert(reblogKey);
    return [self likeRequest:postID reblogKey:reblogKey additionalParameters:nil];
}

- (nonnull id <TMRequest>)likeRequest:(nonnull NSString *)postID reblogKey:(nonnull NSString *)reblogKey additionalParameters:(nullable NSDictionary *)additionalParameters {
    NSParameterAssert(postID);
    NSParameterAssert(reblogKey);

    NSDictionary *parameters = @{ @"id" : postID, @"reblog_key" : reblogKey };

    if (additionalParameters) {
        NSMutableDictionary *mutableParameters = [parameters mutableCopy];
        [mutableParameters addEntriesFromDictionary:additionalParameters];
        parameters = [mutableParameters copy];
    }

    NSString * const TMRoutePathLike = @"user/like";
    return [self requestWithPath:TMRoutePathLike
                          method:TMHTTPRequestMethodPOST
                 queryParameters:nil
                     requestBody:[[TMFormEncodedRequestBody alloc] initWithBody:parameters]];
}

- (nonnull id <TMRequest>)unlikeRequest:(nonnull NSString *)postID reblogKey:(nonnull NSString *)reblogKey {
    NSParameterAssert(reblogKey);
    NSParameterAssert(postID);

    NSString * const TMRoutePathUnlike = @"user/unlike";
    return [self requestWithPath:TMRoutePathUnlike
                          method:TMHTTPRequestMethodPOST
                 queryParameters:nil
                     requestBody:[[TMFormEncodedRequestBody alloc] initWithBody:@{ @"id" : postID, @"reblog_key" : reblogKey }]];
}

- (nonnull id <TMRequest>)userInfoRequest {
    NSString * const TMRoutePathUserInfo = @"user/info";
    return [self requestWithPath:TMRoutePathUserInfo method:TMHTTPRequestMethodGET queryParameters:nil];
}

- (nonnull id <TMRequest>)likesRequestWithParameters:(nonnull NSDictionary *)parameters {
    NSParameterAssert(parameters);

    NSString * const TMRoutePathLikes = @"user/likes";
    return [self requestWithPath:TMRoutePathLikes method:TMHTTPRequestMethodGET queryParameters:parameters];
}

- (nonnull id <TMRequest>)likesRequestForBlogWithUUID:(nonnull NSString *)blogUUID queryParameters:(nonnull NSDictionary *)parameters {
    NSParameterAssert(blogUUID);
    NSParameterAssert(parameters);
    
    return [self requestWithPath:[NSString stringWithFormat:@"blog/%@/likes", blogUUID] method:TMHTTPRequestMethodGET queryParameters:parameters];
}

- (nonnull id <TMRequest>)blogInfoRequestForBlogName:(nonnull NSString *)blogName {
    NSParameterAssert(blogName);
    NSString * const TMRouteBlogPathInfo = @"info";
    return [self requestWithPath:blogPath(TMRouteBlogPathInfo, blogName) method:TMHTTPRequestMethodGET queryParameters:nil];
}

- (nonnull id <TMRequest>)blogInfoRequestForBlogUUID:(nonnull NSString *)blogUUID {
    NSParameterAssert(blogUUID);
    return [self requestWithPath:[NSString stringWithFormat:@"blog/%@/info/", blogUUID] method:TMHTTPRequestMethodGET queryParameters:nil];
}

- (nonnull id <TMRequest>)queueRequestForBlogWithName:(nonnull NSString *)blogName queryParameters:(nonnull NSDictionary *)queryParameters {
    NSParameterAssert(queryParameters);
    NSParameterAssert(blogName);

    return [self requestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/queue", blogName] method:TMHTTPRequestMethodGET queryParameters:queryParameters];
}

- (nonnull id <TMRequest>)followingRequestWithParameters:(nullable NSDictionary *)parameters {
    NSString * const TMRoutePathFollowing = @"user/following";
    return [self requestWithPath:TMRoutePathFollowing method:TMHTTPRequestMethodGET queryParameters:parameters];
}

- (nonnull id <TMRequest>)avatarWithBlogName:(nonnull NSString *)blogName size:(NSUInteger)size {
    NSParameterAssert(blogName);
    NSString * const TMRouteBlogPathAvatar = @"avatar";
    return [self requestWithPath:[blogPath(TMRouteBlogPathAvatar, blogName) stringByAppendingFormat:@"/%ld", (long)size] method:TMHTTPRequestMethodGET queryParameters:nil];
}

- (nonnull id <TMRequest>)postsRequestWithBlogName:(nonnull NSString *)blogName type:(nullable NSString *)type queryParameters:(nonnull NSDictionary *)queryParameters {
    NSParameterAssert(blogName);
    NSParameterAssert(queryParameters);
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:queryParameters];
    if (type) {
        mutableParameters[@"type"] = type;
    }

    NSString * const TMRouteBlogPathPosts = @"posts";
    return [self requestWithPath:blogPath(TMRouteBlogPathPosts, blogName) method:TMHTTPRequestMethodGET queryParameters:[mutableParameters copy]];
}

- (nonnull id <TMRequest>)permalinkRequestWithBlogName:(nonnull NSString *)blogName postID:(nonnull NSString *)postID {
    NSParameterAssert(blogName);
    NSParameterAssert(postID);

    return [self requestWithPath:[NSString stringWithFormat:@"blog/%@/posts/%@/permalink", fullBlogName(blogName), postID] method:TMHTTPRequestMethodGET queryParameters:nil];
}

- (nonnull id <TMRequest>)permalinkRequestWithBlogUUID:(nonnull NSString *)blogUUID postID:(nonnull NSString *)postID {
    NSParameterAssert(blogUUID);
    NSParameterAssert(postID);

    return [self requestWithPath:[NSString stringWithFormat:@"blog/%@/posts/%@/permalink", blogUUID, postID] method:TMHTTPRequestMethodGET queryParameters:nil];
}

- (nonnull id <TMRequest>)postRequestWithBlogName:(nonnull NSString *)blogName type:(nullable NSString *)type parameters:(nonnull NSDictionary *)parameters {
    NSParameterAssert(blogName);
    NSParameterAssert(parameters);

    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (type) {
        mutableParameters[@"type"] = type;
    }

    NSString * const TMRouteBlogPathPost = @"post";
    return [self requestWithPath:blogPath(TMRouteBlogPathPost, blogName)
                          method:TMHTTPRequestMethodPOST
                 queryParameters:nil
                     requestBody:[[TMFormEncodedRequestBody alloc] initWithBody:[mutableParameters copy]]];
}

- (nonnull id <TMRequest>)editPostRequest:(nonnull NSString *)blogName parameters:(nullable NSDictionary *)parameters {
    NSParameterAssert(blogName);

    NSString * const TMRouteBlogPathEditPost = @"post/edit";
    return [self requestWithPath:blogPath(TMRouteBlogPathEditPost, blogName)
                          method:TMHTTPRequestMethodPOST
                 queryParameters:nil
                     requestBody:[[TMFormEncodedRequestBody alloc] initWithBody:[parameters copy]]];
}

- (nonnull id <TMRequest>)followersRequestForBlog:(nonnull NSString *)blogName queryParameters:(nonnull NSDictionary *)queryParameters {
    NSParameterAssert(blogName);
    NSParameterAssert(queryParameters);
    
    NSString * const TMRouteBlogPathFollowers = @"followers";
    return [self requestWithPath:blogPath(TMRouteBlogPathFollowers, blogName) method:TMHTTPRequestMethodGET queryParameters:queryParameters];
}

- (nonnull id <TMRequest>)draftsRequestForBlog:(nonnull NSString *)blogName queryParameters:(nonnull NSDictionary *)queryParameters {
    NSParameterAssert(blogName);
    NSParameterAssert(queryParameters);
    
    return [self requestWithPath:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/draft", blogName] method:TMHTTPRequestMethodGET queryParameters:queryParameters];
}

- (nonnull id <TMRequest>)sumbissionsRequestForBlog:(nonnull NSString *)blogName queryParameters:(nonnull NSDictionary *)queryParameters {
    NSParameterAssert(blogName);
    NSParameterAssert(queryParameters);

    NSString * const TMRouteBlogPathSubmissions = @"posts/submission";
    return [self requestWithPath:blogPath(TMRouteBlogPathSubmissions, blogName) method:TMHTTPRequestMethodGET queryParameters:queryParameters];
}

- (nonnull id <TMRequest>)multipartPostRequestForParameters:(nullable NSDictionary *)parameters
                                                                 path:(nonnull NSString *)path
                                                                 type:(NSString *)type
                                                        filePathArray:(NSArray *)filePathArray
                                                     contentTypeArray:(NSArray *)contentTypeArray
                                                        fileNameArray:(NSArray *)fileNameArray {
    NSParameterAssert(path);
    return [self multipartPostRequestForParameters:parameters
                                              path:path
                                              type:type
                                     filePathArray:filePathArray
                                  contentTypeArray:contentTypeArray
                                     fileNameArray:fileNameArray
                                              keys:[TMMultipartRequestBodyFactory keyArrayOfLength:fileNameArray.count key:@"data"]];

}

- (nonnull id <TMRequest>)multipartPostRequestForParameters:(nullable NSDictionary *)parameters
                                                   blogName:(nonnull NSString *)blogName
                                                       type:(NSString *)type
                                              filePathArray:(NSArray *)filePathArray
                                           contentTypeArray:(NSArray *)contentTypeArray
                                              fileNameArray:(NSArray *)fileNameArray {
    NSParameterAssert(blogName);
    NSString * const TMRouteBlogPathPost = @"post";
    return [self multipartPostRequestForParameters:parameters
                                          path:blogPath(TMRouteBlogPathPost, blogName)
                                              type:type
                                     filePathArray:filePathArray
                                  contentTypeArray:contentTypeArray
                                     fileNameArray:fileNameArray
                                              keys:[TMMultipartRequestBodyFactory keyArrayOfLength:fileNameArray.count key:@"data"]];
}

- (nonnull id <TMRequest>)multipartPostRequestForParameters:(nullable NSDictionary *)parameters
                                                   path:(nonnull NSString *)path
                                                       type:(NSString *)type
                                              filePathArray:(NSArray *)filePathArray
                                           contentTypeArray:(NSArray *)contentTypeArray
                                              fileNameArray:(NSArray *)fileNameArray
                                                       keys:(NSArray <NSString *> *)keys {
    NSParameterAssert(path);

    return [self multipartPostRequestForParameters:parameters
                                              path:path
                                       requestBody:[TMMultipartRequestBodyFactory multipartRequestBodyForParameters:parameters
                                                                                                      filePathArray:filePathArray
                                                                                                   contentTypeArray:contentTypeArray
                                                                                                      fileNameArray:fileNameArray
                                                                                                               type:type
                                                                                                               keys:keys]];
}

- (nonnull id <TMRequest>)multipartPostRequestForParameters:(nullable NSDictionary *)parameters
                                                   blogName:(nonnull NSString *)blogName
                                                requestBody:(nonnull id <TMRequestBody>)multipartRequestBody {
    NSParameterAssert(blogName);
    NSParameterAssert(multipartRequestBody);

    NSString * const TMRouteBlogPathPost = @"post";
    return [self multipartPostRequestForParameters:parameters path:blogPath(TMRouteBlogPathPost, blogName) requestBody:multipartRequestBody];


}

- (nonnull id <TMRequest>)multipartPostRequestForParameters:(nullable NSDictionary *)parameters
                                                       path:(nonnull NSString *)path
                                                requestBody:(nonnull id <TMRequestBody>)multipartRequestBody {
    NSParameterAssert(path);
    NSParameterAssert(multipartRequestBody);

    return [[TMAPIRequest alloc] initWithBaseURL:self.baseURL
                                          method:TMHTTPRequestMethodPOST
                                            path:path
                                 queryParameters:nil
                                     requestBody:multipartRequestBody
                               additionalHeaders:nil
                                        isUpload:YES];


}

- (nonnull id <TMRequest>)reblogPostRequestWithBlogName:(nonnull NSString *)blogName parameters:(nonnull NSDictionary *)parameters {
    NSParameterAssert(blogName);
    NSParameterAssert(parameters);

    NSString * const TMRouteBlogPathReblogPost = @"post/reblog";
    return [self requestWithPath:blogPath(TMRouteBlogPathReblogPost, blogName)
                          method:TMHTTPRequestMethodPOST
                 queryParameters:nil
                     requestBody:[[TMFormEncodedRequestBody alloc] initWithBody:parameters]];
}

#pragma mark - Private


- (nonnull id <TMRequest>)POSTRequestWithPath:(nonnull NSString *)path JSONParameters:(nullable NSDictionary *)JSONParameters {
    NSParameterAssert(path);
    return [[TMAPIRequest alloc] initWithBaseURL:self.baseURL
                                          method:TMHTTPRequestMethodPOST
                                            path:path
                                 queryParameters:nil
                                     requestBody:[[TMJSONEncodedRequestBody alloc] initWithJSONDictionary:JSONParameters]
                               additionalHeaders:nil];
}

/**
 *  Produce a @c TMAPIRequest for request.
 *
 *  @param path       (Required) URL path. (ex: config)
 *  @param method     (Required) The request method.
 *  @param queryParameters (Optional) Post queryParameters.
 *
 *  @return The new @c TMAPIRequest.
 */
- (nonnull id <TMRequest>)requestWithPath:(nonnull NSString *)path
                                   method:(TMHTTPRequestMethod)method
                          queryParameters:(nullable NSDictionary *)queryParameters {
    NSParameterAssert(path);

    return [[TMAPIRequest alloc] initWithBaseURL:self.baseURL
                                          method:method
                                            path:path
                                 queryParameters:queryParameters];
}

/**
 *  Produce a @c TMAPIRequest for request.
 *
 *  @param path       (Required) URL path. (ex: config)
 *  @param method     (Required) The request method.
 *  @param queryParameters (Optional) Post queryParameters.
 *
 *  @return The new @c TMAPIRequest.
 */
- (nonnull id <TMRequest>)requestWithPath:(nonnull NSString *)path
                                   method:(TMHTTPRequestMethod)method
                          queryParameters:(nullable NSDictionary *)queryParameters
                              requestBody:(nonnull id <TMRequestBody>)requestBody {
    NSParameterAssert(path);
    NSParameterAssert(requestBody);

    return [[TMAPIRequest alloc] initWithBaseURL:self.baseURL
                                          method:method
                                            path:path
                                 queryParameters:nil
                                     requestBody:requestBody
                               additionalHeaders:nil];
}

@end
