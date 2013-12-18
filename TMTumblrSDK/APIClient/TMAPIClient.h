//
//  TMAPIClient.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "AFNetworking.h"
#import "TMAPIBlocks.h"
#import "TMHTTPSessionManager.h"

/**
 Full wrapper around the [Tumblr API](http://www.tumblr.com/docs/en/api/). Please see API documentation for a listing
 of each route's parameters.
 */
@interface TMAPIClient : NSObject

@property (nonatomic, strong, readonly) TMHTTPSessionManager *sessionManager;

/// OAuth consumer key. Must be set prior to authenticating or making any API requests.
@property (nonatomic, copy) NSString *OAuthConsumerKey;

/// OAuth consumer key. Must be set prior to authenticating or making any API requests.
@property (nonatomic, copy) NSString *OAuthConsumerSecret;

/**
 OAuth token. Initially set by this library's OAuth/xAuth implementations after authenticating.
 
 The Tumblr SDK does not currently persist this value. You are responsible for storing this value and setting it on
 subsequent app launches prior to maki ng any API requests.
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
 The queue that callback blocks will be executed on by default. `sendRequest:queue:callback:` allows the caller to
 specify a callback queue to be used instead of this default.
 
 By default, this property is set to `[NSOperationQueue mainQueue]`.
 */
@property (nonatomic, strong) NSOperationQueue *defaultCallbackQueue;

/** @name Singleton instance */

+ (TMAPIClient *)sharedInstance;

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

/**
 Authenticate via xAuth. Please note that xAuth access [must be specifically requested](http://www.tumblr.com/oauth/apps)
 for your application.
 
 This method proxies to an underlying `TMTumblrAuthenticator`. That class can be used on its own but you do not need to
 invoke it directly if you are including the whole API client in your project.
 */
- (void)xAuth:(NSString *)emailAddress password:(NSString *)password callback:(void(^)(NSError *))error;

/** @name User */

/// Get information about the authenticated user
- (NSURLSessionDataTask *)userInfo:(TMAPICallback)callback;

/// Get posts for the authenticated user's dashboard
- (NSURLSessionDataTask *)dashboard:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get posts that the authenticated user has "liked"
- (NSURLSessionDataTask *)likes:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get blogs that the authenticated user is following
- (NSURLSessionDataTask *)following:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Follow a blog
- (NSURLSessionDataTask *)follow:(NSString *)blogName callback:(TMAPICallback)callback;

/// Unfollow a blog
- (NSURLSessionDataTask *)unfollow:(NSString *)blogName callback:(TMAPICallback)callback;

/// Like a post
- (NSURLSessionDataTask *)like:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback;

/// Unlike a post
- (NSURLSessionDataTask *)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback;

/** @name Blog */

/// Get the avatar for a blog
- (NSURLSessionDataTask *)avatar:(NSString *)blogName size:(NSInteger)size callback:(TMAPICallback)callback;

/// Get information about a blog
- (NSURLSessionDataTask *)blogInfo:(NSString *)blogName callback:(TMAPICallback)callback;

/// Get the followers for a blog
- (NSURLSessionDataTask *)followers:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get the posts for a blog
- (NSURLSessionDataTask *)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get the queue posts for a blog
- (NSURLSessionDataTask *)queue:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get the draft posts for a blog
- (NSURLSessionDataTask *)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get the submission posts for a blog
- (NSURLSessionDataTask *)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Get the likes for a blog
- (NSURLSessionDataTask *)likes:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/** @name Posting */

/// Create a post of a given |type|
- (NSURLSessionDataTask *)post:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Edit a post
- (NSURLSessionDataTask *)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Reblog a post
- (NSURLSessionDataTask *)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Delete a post
- (NSURLSessionDataTask *)deletePost:(NSString *)blogName id:(NSString *)postID callback:(TMAPICallback)callback;

/** @name Posting (convenience) */

/// Create a text post
- (NSURLSessionDataTask *)text:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Create a quote post
- (NSURLSessionDataTask *)quote:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Create a link post
- (NSURLSessionDataTask *)link:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;;

/// Create a chat post
- (NSURLSessionDataTask *)chat:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;;

/// Create a photo post
- (NSURLSessionDataTask *)photo:(NSString *)blogName filePathArray:(NSArray *)filePathArrayOrNil
               contentTypeArray:(NSArray *)contentTypeArrayOrNil fileNameArray:(NSArray *)fileNameArrayOrNil
                     parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;;

/// Create a video post
- (NSURLSessionDataTask *)video:(NSString *)blogName filePath:(NSString *)filePathOrNil
                    contentType:(NSString *)contentTypeOrNil fileName:(NSString *)fileNameOrNil
                     parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/// Create an audio post
- (NSURLSessionDataTask *)audio:(NSString *)blogName filePath:(NSString *)filePathOrNil
                    contentType:(NSString *)contentTypeOrNil fileName:(NSString *)fileNameOrNil
                     parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/** @name Tagging */

/// Get posts with a given tag
- (NSURLSessionDataTask *)tagged:(NSString *)tag parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

@end
