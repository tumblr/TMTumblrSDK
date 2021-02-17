//
//  TMAPIClient.h
//  Pods
//
//  Created by Kenny Ackerson on 11/18/15.
//
//

#import <Foundation/Foundation.h>
#import "TMURLSession.h"
#import "TMRequestFactory.h"

typedef void (^TMAPIClientCallback)(NSDictionary * _Nullable response, NSError * _Nullable error);

__attribute__((objc_subclassing_restricted))
@interface TMAPIClient : NSObject


/**
 The session used to create data tasks.
 */
@property (nonnull, nonatomic, readonly) id <TMSession> session;

/**
 An object responsible for creating request objects.
 */
@property (nonnull, nonatomic, readonly) TMRequestFactory *requestFactory;

/**
 *  Initializes an instance of `TMAPIClient`.
 *
 *  @param session The Session to create data tasks.
 *  @param requestFactory An object responsible for creating request objects.
 *
 *  @return Initialized instance of `TMAPIClient`.
 */
- (nonnull instancetype)initWithSession:(nonnull id <TMSession>)session requestFactory:(nonnull TMRequestFactory *)requestFactory;

/**
 Creates a task that requests a users dashboard.

 @param parameters The query parameters to include in the URL request.
 @param callback   The callback for when the request is completed.
 @return A task that can request a list of posts on a user's dashboard.
 */
- (nonnull NSURLSessionTask *)dashboardRequest:(nullable NSDictionary *)parameters callback:(nonnull TMAPIClientCallback)callback;

/**
 *  Creates a task that requests a list of posts for a blog.
 *
 *  @param blogName        The blog name to fetch posts for.
 *  @param type            The type of request that this is.
 *  @param queryParameters The query parameters to include in the URL request.
 *  @param callback        The callback for when the request is completed.
 *
 *  @return A task that can get a list of posts for a blog given a name.
 */
- (nonnull NSURLSessionTask *)postsTask:(nonnull NSString *)blogName
                                   type:(nullable NSString *)type
                        queryParameters:(nonnull NSDictionary *)queryParameters
                               callback:(nonnull TMAPIClientCallback)callback;

/**
 *  Gets a task given a @c TMRequest.
 *
 *  This allows you to use this class with your own requests.
 *  The reason to use this over the Session directly is that this class does a lot of parsing and base error handling for you.
 *
 *  @param request  The request to get a task for.
 *  @param callback The callback for when the request is completed.
 *
 *  @return A new request using the request provided.
 */
- (nonnull NSURLSessionTask *)taskWithRequest:(nonnull id <TMRequest>)request callback:(nonnull TMAPIClientCallback)callback;

/**
 *  Gets the user info data task.
 *
 *  @param callback The callback for when the request is completed.
 *
 *  @return The data task for the user info route.
 */
- (nonnull NSURLSessionTask *)userInfoDataTaskWithCallback:(nonnull TMAPIClientCallback)callback;

/**
 *  Gets the post notes data task.
 *
 *  @param postId     The post id of the post to get the notes of.
 *  @param blogUUID   The UUID of the post's authoring blog.
 *  @param beforeDate The date for which to look before on all of the post's notes.
 *  @param callback The callback for when the request is completed.
 *
 *  @return The data task for the post notes route.
 */
- (nonnull NSURLSessionTask *)notesDataTaskWithPostID:(nonnull NSString *)postId blogUUID:(nonnull NSString *)blogUUID beforeDate:(nullable NSDate *)beforeDate :(nonnull TMAPIClientCallback)callback;

/**
 *  Gets a data task that can retrieve the authenticated user's likes.
 *
 *  @param parameters The parameters you wish to pass to this route.
 *  @param callback The callback for when the request is completed.
 *
 *  @return The data task that can retrieve the authenticated user's likes.
 */
- (nonnull NSURLSessionTask *)likesDataTaskWithParameters:(nonnull NSDictionary *)parameters callback:(nonnull TMAPIClientCallback)callback;

/**
 *  Gets a data task that can retrieve a user's likes.
 *
 *  @param blogUUID   The UUID of the blog for the user whose likes you would wish to retrieve.
 *  @param parameters The parameters you wish to pass to this route.
 *  @param callback The callback for when the request is completed.
 *
 *  @return The data task that can retrieve the authenticated user's likes.
 */
- (nonnull NSURLSessionTask *)likesDataTaskForBlogWithUUID:(nonnull NSString *)blogUUID parameters:(nonnull NSDictionary *)parameters callback:(nonnull TMAPIClientCallback)callback;

/**
 *  Gets a data task that can retrieve a blog's info.
 *
 *  @param blogName The blog name to retrieve the blog info of.
 *  @param callback The callback for when the request is completed.
 *
 *  @return The data task that can retrieve a blog's info.
 */
- (nonnull NSURLSessionTask *)blogInfoDataTaskForBlogName:(nonnull NSString *)blogName callback:(nonnull TMAPIClientCallback)callback;

/*
 *  Gets a list of the authenticated user's following list.
 *
 *  @param parameters The parameters to pass to the API.
 *  @param callback The callback for when the request is completed.
 *
 *  @return A data task that can fetch the authenticated user's following list.
 */
- (nonnull NSURLSessionTask *)followingDataTaskWithParameters:(nullable NSDictionary *)parameters callback:(nonnull TMAPIClientCallback)callback;

/**
 *  Gets a blog's avatar at a given size.
 *
 *  @param blogName The blog name to fetch the avatar for.
 *  @param size     The size of the avatar we want to get back.
 *  @param callback The callback for when the request is completed.
 *
 *  @return A data task that can get a blog's avatar.
 */
- (nonnull NSURLSessionTask *)avatarWithBlogName:(nonnull NSString *)blogName size:(NSUInteger)size callback:(nonnull TMURLSessionRequestCompletionHandler)callback;

/**
 *  Creates a data task for making a new blog post.
 *  
 *  @param blogName The blog name associated with the new post.
 *  @param type The blog post type associated with the new post.
 *  @param parameters The parameters to pass to the API.
 *  @param callback The callback for when the request is completed.
 *
 *  @return A data task that can post a new blog post to the API.
 */
- (nonnull NSURLSessionTask *)postDataTaskWithBlogName:(nonnull NSString *)blogName type:(nonnull NSString *)type parameters:(nonnull NSDictionary *)parameters callback:(nonnull TMURLSessionRequestCompletionHandler)callback;

/**
 *  Allows editing of a post.
 *
 *  @param blogName     The blog name of the blog that the post to be edited is on.
 *  @param parameters   Parameters to pass to the endpoint.
 *  @param callback     The callback for when the request is completed.
 *
 *  @return A data task that can edit a post.
 */
- (nonnull NSURLSessionTask *)editPost:(nonnull NSString *)blogName parameters:(nullable NSDictionary *)parameters callback:(nonnull TMAPIClientCallback)callback;

/**
 *  Fetches all the followers of a blog.
 *
 *  @param blogName   The blog name to get the followers of.
 *  @param parameters The parameters to pass to the blog followers endpoint.
 *  @param callback   The callback for when the request is completed.
 *
 *  @return A session task that can fetch all the followers of a blog.
 */
- (nonnull NSURLSessionTask *)followersRequestForBlogName:(nonnull NSString *)blogName
                                               parameters:(nonnull NSDictionary *)parameters
                                                 callback:(nonnull TMAPIClientCallback)callback;

/**
 *  Fetches drafts for a given blog.
 *
 *  @param blogName   The blog name to get the drafts of.
 *  @param parameters The paramaters to pass along to the drafts endpoint.
 *  @param callback   The callback to run when the request has completed.
 *
 *  @return A session task that can fetch the drafts of a blog.
 */
- (nonnull NSURLSessionTask *)draftsRequestForBlogWithName:(nonnull NSString *)blogName
                                                parameters:(nonnull NSDictionary *)parameters
                                                  callback:(nonnull TMAPIClientCallback)callback;

/**
 *  Fetches submissions for a given blog.
 *
 *  @param blogName   The blog name to get the submissions for.
 *  @param parameters The paramaters to pass along to the submissions endpoint.
 *  @param callback   The callback to run when the request has completed.
 *
 *  @return A session task that can fetch the submsisions of a blog.
 */
- (nonnull NSURLSessionTask *)submissionsRequestforBlogName:(nonnull NSString *)blogName
                                                 parameters:(nonnull NSDictionary *)parameters
                                                   callback:(nonnull TMAPIClientCallback)callback;

#pragma mark - Convenience

/**
 Convenience method to convert a @c TMAPIClientCallback into a @c TMURLSessionRequestCompletionHandler.

 @param callback The @c TMAPIClientCallback to call when the API client receives data.
 @return A @c TMURLSessionRequestCompletionHandler to call when the API client receives data.
 */
- (nonnull TMURLSessionRequestCompletionHandler)completionHandlerWithAPIClientCallback:(nonnull TMAPIClientCallback)callback;

@end
