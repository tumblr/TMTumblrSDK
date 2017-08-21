//
//  TMRequestFactory.h
//  Orangina
//
//  Created by Bryan Irace on 3/26/15.
//  Copyright (c) 2015 Tumblr. All rights reserved.
//

@class TMAPIApplicationCredentials;
@class TMAPIUserCredentials;
@class TMAPIRequest;

@protocol TMRequest;
@protocol TMRequestBody;
@protocol TMBaseURLDetermining;

#import "TMHTTPRequestMethod.h"

/**
 Produces network requests.
 */
__attribute__((objc_subclassing_restricted))
@interface TMRequestFactory : NSObject

/**
 *  Initialize a request factory instance.
 *
 *  @param baseURLDeterminer  (Required) Class providing the base URL for all requests.
 *
 *  @return The new request factory.
 */
- (nonnull instancetype)initWithBaseURLDeterminer:(nonnull id <TMBaseURLDetermining>)baseURLDeterminer NS_DESIGNATED_INITIALIZER;

/**
 Initialize a request factory instance configured with the default base URL.

 @return The new request factory.
 */
- (nonnull instancetype)init;

#pragma mark - API routes

/**
 Creates a dashboard request represented by a @c TMRequest.

 @param parameters Additional query parameters to pass to the API.
 @return A new @c TMRequest given the query parameters.
 */
- (nonnull id <TMRequest>)dashboardRequest:(nullable NSDictionary *)parameters;

/**
 *  Creates a @c TMRequest given a path, method and parameters.
 *
 *  @param path                     The path of the API request.
 *  @param method                   The HTTP method of the API request.
 *  @param queryParameters          The associated query parameters for the API request.
 *
 *  @return A @c TMRequest given a path, method and parameters.
 */
- (nonnull id <TMRequest>)requestWithPath:(nonnull NSString *)path
                                   method:(TMHTTPRequestMethod)method
                          queryParameters:(nullable NSDictionary *)queryParameters;

/**
 *  Creates a request that can upload a new post.
 *
 *  @param parameters           The corresponding POST parameters.
 *  @param path                 The path of the request on the tumblr API.
 *  @param multipartRequestBody The request body that represents a multipart data body.
 *
 *  @return A new request that can upload a post to Tumblr.
 */
- (nonnull id <TMRequest>)multipartPostRequestForParameters:(nullable NSDictionary *)parameters
                                                       path:(nonnull NSString *)path
                                                requestBody:(nonnull id <TMRequestBody>)multipartRequestBody;

/**
 *  Creates a @c TMRequest given a path, method and parameters.
 *
 *  @param path                     The path of the API request.
 *  @param method                   The HTTP method of the API request.
 *  @param queryParameters          The associated query parameters for the API request.
 *  @param requestBody              The request body object that represents a HTTP request body
 *
 *  @return A @c TMRequest given a path, method and parameters.
 */
- (nonnull id <TMRequest>)requestWithPath:(nonnull NSString *)path
                                   method:(TMHTTPRequestMethod)method
                          queryParameters:(nullable NSDictionary *)queryParameters
                              requestBody:(nonnull id <TMRequestBody>)requestBody;

/**
 *  Create a @c TMRequest using HTTP POST method and JSON encoded body
 *
 *  @param path           The path of the API request.
 *  @param JSONParameters The parameters to be converted to a JSON object.
 *
 *  @return A @c TMRequest given a path and parameters.
 */
- (nonnull id <TMRequest>)POSTRequestWithPath:(nonnull NSString *)path JSONParameters:(nullable NSDictionary *)JSONParameters;

/**
 *  Creates a request that can follow a blog.
 *
 *  @param blogName   The blog's name for which to follow.
 *  @param parameters Additional parameters on the request.
 *
 *  @return A new request object that can follow a blog.
 */
- (nonnull id <TMRequest>)followRequest:(nonnull NSString *)blogName parameters:(nullable NSDictionary *)parameters;

/**
 *  Gets a request for post notes.
 *
 *  @param postID     The post for whose notes we are trying to gather.
 *  @param blogUUID   The UUID of the post's authoring blog.
 *  @param beforeDate The date for which to look before on all of the post's notes.
 *
 *  @return A request for a post's notes.
 */
- (nonnull id <TMRequest>)notesRequestWithPostID:(nonnull NSString *)postID blogUUID:(nonnull NSString *)blogUUID beforeDate:(nullable NSDate *)beforeDate;

/**
 *  Creates a new request that unfollows a blog.
 *
 *  @param blogName The blog we want to unfollow.
 *
 *  @return A new request that allows you to unfollow a blog.
 */
- (nonnull id <TMRequest>)unfollowRequest:(nonnull NSString *)blogName;

/**
 *  Creates a URL request for making a GET request to the API's 'v2/user/info' route
 *
 *  @return A new user info API request.
 */
- (nonnull id <TMRequest>)userInfoRequest;

/**
 *  Creates a request that retrieves the authenticated user's likes.
 *
 *  @param parameters The parameters to pass to the user's like API endpoint.
 *
 *  @return A new user likes API request.
 */
- (nonnull id <TMRequest>)likesRequestWithParameters:(nonnull NSDictionary *)parameters;

/**
 *  Creates a request that retrieves the given blog name.
 *
 *  @param blogUUID        The blog UUID of the user you wish to look up likes for.
 *  @param queryParameters The parameters to pass to the user's like API endpoint.
 *
 *  @return A new user likes API request.
 */
- (nonnull id <TMRequest>)likesRequestForBlogWithUUID:(nonnull NSString *)blogUUID queryParameters:(nonnull NSDictionary *)queryParameters;

/**
 *  Creates a request that can retrieve info about a blog.
 *
 *  @param blogName The blog name to retrieve info for.
 *
 *  @return A new blog info API request.
 */
- (nonnull id <TMRequest>)blogInfoRequestForBlogName:(nonnull NSString *)blogName;

/**
 *  Creates a request that can retrieve info about a blog.
 *
 *  @param blogUUID The blog UUID to retrieve info for.
 *
 *  @return A new blog info API request.
 */
- (nonnull id <TMRequest>)blogInfoRequestForBlogUUID:(nonnull NSString *)blogUUID;

/**
 *  Creates a request that can get a blog's queued up posts.
 *
 *  @param blogName        The name of the blog to get the queued posts for.
 *  @param queryParameters The query parameters to be included on this request.
 *
 *  @return A request that can get a blog's queued up posts.
 */
- (nonnull id <TMRequest>)queueRequestForBlogWithName:(nonnull NSString *)blogName queryParameters:(nonnull NSDictionary *)queryParameters;

/*
 *  Creates a request that gets the authenticated user's following list.
 *
 *  @param queryParameters The query parameters of the request.
 *
 *  @return A new request to get a user's following list.
 */
- (nonnull id <TMRequest>)followingRequestWithParameters:(nullable NSDictionary *)parameters;

/**
 *  Creates a request that gets a user's avatar.
 *
 *  @param blogName The blog name to get the avatar of.
 *  @param size     The size of the avatar to retrieve.
 *
 *  @return A new request to get a user's avatar.
 */
- (nonnull id <TMRequest>)avatarWithBlogName:(nonnull NSString *)blogName size:(NSUInteger)size;

- (nonnull id <TMRequest>)deletePostRequest:(nonnull NSString *)blogName postID:(nonnull NSString *)postID;

/*
 *  Creates a request that fetches blog posts.
 *
 *  @param blogName        The blog name associated with the user making the post.
 *  @param type            The type of the blog post being created.
 *  @param queryParameters The parameters of the request.
 *
 *  @return A new request to fetch blog posts.
 */
- (nonnull id <TMRequest>)postsRequestWithBlogName:(nonnull NSString *)blogName type:(nullable NSString *)type queryParameters:(nonnull NSDictionary *)queryParameters;

/*
 *  Creates a request that fetches an individual blog post and its associated recommended content.
 *
 *  @param blogName     The name of the blog to which the post belongs.
 *  @param postID       The ID of the post in question.
 *
 *  @return A new request to fetch a permalink content package.
 */
- (nonnull id <TMRequest>)permalinkRequestWithBlogName:(nonnull NSString *)blogName postID:(nonnull NSString *)postID;

/*
 *  Creates a request that fetches an individual blog post and its associated recommended content.
 *
 *  @param blogUUID     The UUID of the blog to which the post belongs.
 *  @param postID       The ID of the post in question.
 *
 *  @return A new request to fetch a permalink content package.
 */
- (nonnull id <TMRequest>)permalinkRequestWithBlogUUID:(nonnull NSString *)blogUUID postID:(nonnull NSString *)postID;

/**
 *  Makes a request that creates a new blog post.
 *
 *  @param blogName        The blog name associated with the user making the post.
 *  @param type            The type of the blog post being created.
 *  @param parameters The parameters of the request.
 *
 *  @return A new request to make a new blog post.
 */
- (nonnull id <TMRequest>)postRequestWithBlogName:(nonnull NSString *)blogName type:(nullable NSString *)type parameters:(nonnull NSDictionary *)parameters;

/**
 *  Creates a new multipart POST request for a Tumblr post.
 *
 *  @param parameters       Additional POST parameters for the request.
 *  @param blogName         The blog name to post this multipart request to.
 *  @param type             The type of the multipart request. For example Photo posts are `photo`.
 *  @param filePathArray    An array of file paths for the files we want to upload.
 *  @param contentTypeArray The content types of the corresponding files in the file path array.
 *  @param fileNameArray    The file names of the files in the file path array.
 *
 *  @return A new multipart POST request.
 */
- (nonnull id <TMRequest>)multipartPostRequestForParameters:(nullable NSDictionary *)parameters
                                                   blogName:(nonnull NSString *)blogName
                                                       type:(nonnull NSString *)type
                                              filePathArray:(nonnull NSArray *)filePathArray
                                           contentTypeArray:(nonnull NSArray *)contentTypeArray
                                              fileNameArray:(nonnull NSArray *)fileNameArray;

/**
 *  Creates a new multipart POST request.
 *
 *  @param parameters       Additional POST parameters for the request.
 *  @param path             The path of the URL route on the Tumblr v2 API.
 *  @param type             The type of the multipart request. For example Photo posts are `photo`.
 *  @param filePathArray    An array of file paths for the files we want to upload.
 *  @param contentTypeArray The content types of the corresponding files in the file path array.
 *  @param fileNameArray    The file names of the files in the file path array.
 *
 *  @return A new multipart POST request.
 */
- (nonnull id <TMRequest>)multipartPostRequestForParameters:(nullable NSDictionary *)parameters
                                                       path:(nonnull NSString *)path
                                                       type:(nonnull NSString *)type
                                              filePathArray:(nonnull NSArray *)filePathArray
                                           contentTypeArray:(nonnull NSArray *)contentTypeArray
                                              fileNameArray:(nonnull NSArray *)fileNameArray;

/**
 *  Creates a new multipart body POST request to make a new post.
 *
 *  @param parameters           Additional POST parameters for the request.
 *  @param blogName             The blog name to post this multipart request to.
 *  @param multipartRequestBody The request body to attach to this request.
 *
 *  @return A new multipart body request that posts a post to a blog.
 */
- (nonnull id <TMRequest>)multipartPostRequestForParameters:(nullable NSDictionary *)parameters
                                                   blogName:(nonnull NSString *)blogName
                                                requestBody:(nonnull id <TMRequestBody>)multipartRequestBody;

/**
 *  Creates a new request that reblogs a post to a blog.
 *
 *  @param blogName   The blog name to reblog a post to.
 *  @param parameters Additional POST parameters for this request.
 *
 *  @return A new request that reblogs a post to a blog.
 */
- (nonnull id <TMRequest>)reblogPostRequestWithBlogName:(nonnull NSString *)blogName parameters:(nonnull NSDictionary *)parameters;

/**
 *  Creats a new request that likes a post by the current user.
 *
 *  @param postID    The post ID of the post to like.
 *  @param reblogKey A key that represents a reblog.
 *
 *  @return A new request that can like a post by ID.
 */
- (nonnull id <TMRequest>)likeRequest:(nonnull NSString *)postID reblogKey:(nonnull NSString *)reblogKey;

/**
 *  Creats a new request that unlikes a post by the current user.
 *
 *  @param postID    The post ID of the post to unlike.
 *  @param reblogKey A key that represents a reblog.
 *
 *  @return A new request that can like a post by ID.
 */
- (nonnull id <TMRequest>)unlikeRequest:(nonnull NSString *)postID reblogKey:(nonnull NSString *)reblogKey;

/**
 *  Creats a new request that likes a post by the current user.
 *
 *  @param postID                The post ID of the post to like.
 *  @param reblogKey             A key that represents a reblog.
 *  @param additionalParameters  Additional POST parameters to add to the request.
 *
 *  @return A new request that can like a post by ID.
 */
- (nonnull id <TMRequest>)likeRequest:(nonnull NSString *)postID
                            reblogKey:(nonnull NSString *)reblogKey
                 additionalParameters:(nullable NSDictionary *)additionalParameters;

/**
 *  Creates a request that edits a post.
 *
 *  @param blogName     The blog name of the blog that the post to be edited, is on.
 *  @param parameters   Query parameters to pass to the endpoint.
 *
 *  @return A new @C TMAPIRequest that can be used to edit a post.
 */
- (nonnull id <TMRequest>)editPostRequest:(nonnull NSString *)blogName parameters:(nullable NSDictionary *)parameters;

/**
 *  Creates a request that can be used to get all the followers of a blog.
 *
 *  @param blogName         The name of the blog for which to fetch the followers of.
 *  @param queryParameters  Query parameters to pass to the followers endpoint.
 *
 *  @return A request that can fetch the followers of a blog.
 */
- (nonnull id <TMRequest>)followersRequestForBlog:(nonnull NSString *)blogName queryParameters:(nonnull NSDictionary *)queryParameters;

/**
 *  Creates a request to fetch drafts for a given blog.
 *
 *  @param blogName         The blog name to fetch drafts for.
 *  @param queryParameters  Any additional pramaters to pass along with the request.
 *
 *  @return A requst that can fetch the drafts for a blog.
 */
- (nonnull id <TMRequest>)draftsRequestForBlog:(nonnull NSString *)blogName queryParameters:(nonnull NSDictionary *)queryParameters;

/**
 *  Creates a request to fetch submissions for a given blog.
 *
 *  @param blogName        The blog name to fetch submissions for.
 *  @param queryParameters Any additional pramaters to pass along with the request.
 *
 *  @return A request that can fetch submissions for a blog.
 */
- (nonnull id <TMRequest>)sumbissionsRequestForBlog:(nonnull NSString *)blogName queryParameters:(nonnull NSDictionary *)queryParameters;

@end
