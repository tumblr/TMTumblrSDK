//
//  TMAPIClient.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JXHTTPOperation;
@class JXHTTPOperationQueue;

typedef void (^TMAPICallback)(id, NSError *error);

/**
 Full wrapper around the [Tumblr API](http://www.tumblr.com/docs/en/api/). Please see API documentation for a listing 
 of each route's parameters.
 */
@interface TMAPIClient : NSObject

/// OAuth consumer key. Must be set prior to authenticating or making any API requests.
@property (nonatomic, copy) NSString *OAuthConsumerKey;

/// OAuth consumer key. Must be set prior to authenticating or making any API requests.
@property (nonatomic, copy) NSString *OAuthConsumerSecret;

/**
 OAuth token. Initially set by this library's OAuth/xAuth implementations after authenticating.
 
 The Tumblr SDK does not currently persist this value. You are responsible for storing this value and setting it on 
 subsequent app launches prior to making any API requests.
 */
@property (nonatomic, copy) NSString *OAuthToken;

/**
 OAuth token secret. Initially set by this library's OAuth/xAuth implementations after authenticating.
 
 The Tumblr SDK does not currently persist this value. You are responsible for storing this value and setting it on
 subsequent app launches prior to making any API requests.
 */
@property (nonatomic, copy) NSString *OAuthTokenSecret;

/**
 HTTP headers to be set on all requests, in addition to the `Authentication` header. These headers will be set just 
 prior to the request being signed.
 */
@property (nonatomic, copy) NSDictionary *customHeaders;

/**
 Default: 60 seconds
 */
@property (nonatomic) NSTimeInterval timeoutInterval;

/**
 Queue that requests sent through `sendRequest:callback:` or `sendRequest:queue:callback:` (and as such, any of the 
 `void` API methods) will be added to.
 */
@property (nonatomic, strong, readonly) JXHTTPOperationQueue *queue;

/**
 The queue that callback blocks will be executed on by default. `sendRequest:queue:callback:` allows the caller to 
 specify a callback queue to be used instead of this default.
 
 By default, this property is set to `[NSOperationQueue mainQueue]`.
 */
@property (nonatomic, strong) NSOperationQueue *defaultCallbackQueue;

@property (nonatomic, strong) NSURL *baseURL;

/** @name Singleton instance */

+ (instancetype)sharedInstance;

/** @name Sending raw requests */

/**
 Send an API request. This method should be used in conjunction with an API method below that return a `JXHTTPOperation`
 instance. These methods are provided for cases in which the calling code wants a reference to the operation in order
 to observe its properties, cancel it, etc. If the caller does not need to do this, the `void` API methods can be used
 instead.
 
 All requests sent using this method (and as such, any of the `void` API methods) will have their callback blocks 
 executed on the `defaultCallbackQueue`.
 */
- (void)sendRequest:(JXHTTPOperation *)request callback:(TMAPICallback)callback;

/**
 Send an API request and specify a queue to execute the callback block on. This method should be used in conjunction 
 with an API method below that returns a `JXHTTPOperation` instance. These methods are provided for cases in which the
 calling code wants a reference to the operation in order to observe its properties, cancel it, etc. If the caller does 
 not need to do this, the `void` API methods can be used instead.
 
 @param queue Queue to execute the callback block on.
 */
- (void)sendRequest:(JXHTTPOperation *)request queue:(NSOperationQueue *)queue callback:(TMAPICallback)callback;

#ifdef __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__

/** @name Authentication */

/**
 Authenticate via three-legged OAuth.
 
 Your `TMAPIClient` instance's `handleOpenURL:` method must also be called from your `UIApplicationDelegate`'s
 `application:openURL:sourceApplication:annotation:` method in order to receive the tokens.
 
 This method proxies to an underlying `TMTumblrAuthenticator`. That class can be used on its own but you do not need to
 invoke it directly if you are including the whole API client in your project.
 
 @param URLScheme a URL scheme that your application can handle requests to.
 */
- (void)authenticate:(NSString *)URLScheme callback:(void(^)(NSError *))error;

/**
 Authenticate via three-legged OAuth. This should be called from your `UIApplicationDelegate`'s
 `application:openURL:sourceApplication:annotation:` method in order to receive the tokens.
 
 This method proxies to an underlying `TMTumblrAuthenticator`. That class can be used on its own but you do not need to
 invoke it directly if you are including the whole API client in your project.
 
 This method is the last part of the authentication flow started by calling `authenticate:callback:`
 */
- (BOOL)handleOpenURL:(NSURL *)url;

#endif

/**
 Authenticate via xAuth. Please note that xAuth access [must be specifically requested](http://www.tumblr.com/oauth/apps) 
 for your application.
 
 This method proxies to an underlying `TMTumblrAuthenticator`. That class can be used on its own but you do not need to
 invoke it directly if you are including the whole API client in your project.
 */
- (void)xAuth:(NSString *)emailAddress password:(NSString *)password callback:(void(^)(NSError *))error;

/** @name User */

/// Get information about the authenticated user
- (JXHTTPOperation *)userInfoRequest;
- (void)userInfo:(TMAPICallback)callback;

/// Get posts for the authenticated user's dashboard
- (JXHTTPOperation *)dashboardRequest:(NSDictionary *)parameters;
- (void)dashboard:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get posts that the authenticated user has "liked"
- (JXHTTPOperation *)likesRequest:(NSDictionary *)parameters;
- (void)likes:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get blogs that the authenticated user is following
- (JXHTTPOperation *)followingRequest:(NSDictionary *)parameters;
- (void)following:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Follow a blog
- (JXHTTPOperation *)followRequest:(NSString *)blogName;
- (void)follow:(NSString *)blogName callback:(TMAPICallback)callback;

/// Unfollow a blog
- (JXHTTPOperation *)unfollowRequest:(NSString *)blogName;
- (void)unfollow:(NSString *)blogName callback:(TMAPICallback)callback;

/// Like a post
- (JXHTTPOperation *)likeRequest:(NSString *)postID reblogKey:(NSString *)reblogKey;
- (void)like:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback;

/// Unlike a post
- (JXHTTPOperation *)unlikeRequest:(NSString *)postID reblogKey:(NSString *)reblogKey;
- (void)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback;

/** @name Blog */

/// Get the avatar for a blog
- (void)avatar:(NSString *)blogName size:(NSUInteger)size callback:(TMAPICallback)callback;

/**
 Get the avatar for a blog.
 
 @param queue Queue to execute the callback block on.
 */
- (void)avatar:(NSString *)blogName size:(NSUInteger)size queue:(NSOperationQueue *)queue callback:(TMAPICallback)callback;

/// Get information about a blog
- (JXHTTPOperation *)blogInfoRequest:(NSString *)blogName;
- (void)blogInfo:(NSString *)blogName callback:(TMAPICallback)callback;

/// Get the followers for a blog
- (JXHTTPOperation *)followersRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)followers:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get the posts for a blog
- (JXHTTPOperation *)postsRequest:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters;
- (void)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get the queue posts for a blog
- (JXHTTPOperation *)queueRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)queue:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get the draft posts for a blog
- (JXHTTPOperation *)draftsRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get the submission posts for a blog
- (JXHTTPOperation *)submissionsRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get the likes for a blog
- (JXHTTPOperation *)likesRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)likes:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/** @name Posting */

/// Create a post of a given |type|
- (JXHTTPOperation *)postRequest:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters;
- (void)post:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Edit a post
- (JXHTTPOperation *)editPostRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Reblog a post
- (JXHTTPOperation *)reblogPostRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Delete a post
- (JXHTTPOperation *)deletePostRequest:(NSString *)blogName id:(NSString *)postID;
- (void)deletePost:(NSString *)blogName id:(NSString *)postID callback:(TMAPICallback)callback;

/** @name Posting (convenience) */

/// Create a text post
- (JXHTTPOperation *)textRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)text:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Create a quote post
- (JXHTTPOperation *)quoteRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)quote:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Create a link post
- (JXHTTPOperation *)linkRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)link:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Create a chat post
- (JXHTTPOperation *)chatRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)chat:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Create a photo post
- (JXHTTPOperation *)photoRequest:(NSString *)blogName filePathArray:(NSArray *)filePathArrayOrNil
                 contentTypeArray:(NSArray *)contentTypeArrayOrNil fileNameArray:(NSArray *)fileNameArrayOrNil
                       parameters:(NSDictionary *)parameters;
- (void)photo:(NSString *)blogName filePathArray:(NSArray *)filePathArrayOrNil contentTypeArray:(NSArray *)contentTypeArrayOrNil
fileNameArray:(NSArray *)fileNameArrayOrNil parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Create a video post
- (JXHTTPOperation *)videoRequest:(NSString *)blogName filePath:(NSString *)filePathOrNil
                      contentType:(NSString *)contentTypeOrNil fileName:(NSString *)fileNameOrNil
                       parameters:(NSDictionary *)parameters;
- (void)video:(NSString *)blogName filePath:(NSString *)filePathOrNil contentType:(NSString *)contentTypeOrNil
     fileName:(NSString *)fileNameOrNil parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Create a Video Post from URL or Embed HTML
- (JXHTTPOperation *)webVideoRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;

/// Create an audio post
- (JXHTTPOperation *)audioRequest:(NSString *)blogName filePath:(NSString *)filePathOrNil
                      contentType:(NSString *)contentTypeOrNil fileName:(NSString *)fileNameOrNil
                       parameters:(NSDictionary *)parameters;
- (void)audio:(NSString *)blogName filePath:(NSString *)filePathOrNil contentType:(NSString *)contentTypeOrNil
     fileName:(NSString *)fileNameOrNil parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/** @name Tagging */

/// Get posts with a given tag
- (JXHTTPOperation *)taggedRequest:(NSString *)tag parameters:(NSDictionary *)parameters;
- (void)tagged:(NSString *)tag parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

@end
