//
//  TMAPIClient.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "JXHTTP.h"

typedef void (^TMAPICallback)(id, NSError *error);

@interface TMAPIClient : NSObject

@property (nonatomic, copy) NSString *OAuthConsumerKey;
@property (nonatomic, copy) NSString *OAuthConsumerSecret;
@property (nonatomic, copy) NSString *OAuthToken;
@property (nonatomic, copy) NSString *OAuthTokenSecret;
@property (nonatomic, copy) NSDictionary *customHeaders;

@property (nonatomic, strong, readonly) JXHTTPOperationQueue *queue;
@property (nonatomic, strong) NSOperationQueue *callbackQueue;

+ (TMAPIClient *)sharedInstance;

// Send a low-level request (for methods not available directly)
- (void)sendRequest:(JXHTTPOperation *)request callback:(TMAPICallback)callback;

/** @name Authentication */

// Authenticate via OAuth
- (void)authenticate:(NSString *)URLScheme callback:(void(^)(NSError *))error;

// Handle opening a given URL
- (BOOL)handleOpenURL:(NSURL *)url;

// Authenticate via xAuth
- (void)xAuth:(NSString *)emailAddress password:(NSString *)password callback:(void(^)(NSError *))error;

/** @name User */

// Get information about the authenticating user
- (JXHTTPOperation *)userInfoRequest;
- (void)userInfo:(TMAPICallback)callback;

// Get posts for the authenticating user's dashboard
- (JXHTTPOperation *)dashboardRequest:(NSDictionary *)parameters;
- (void)dashboard:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Get posts the authenticating user likes
- (JXHTTPOperation *)likesRequest:(NSDictionary *)parameters;
- (void)likes:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Get blogs the authenticating user is following
- (JXHTTPOperation *)followingRequest:(NSDictionary *)parameters;
- (void)following:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Follow a blog
- (JXHTTPOperation *)followRequest:(NSString *)blogName;
- (void)follow:(NSString *)blogName callback:(TMAPICallback)callback;

// Unfollow a blog
- (JXHTTPOperation *)unfollowRequest:(NSString *)blogName;
- (void)unfollow:(NSString *)blogName callback:(TMAPICallback)callback;

// Like a post
- (JXHTTPOperation *)likeRequest:(NSString *)postID reblogKey:(NSString *)reblogKey;
- (void)like:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback;

// Unlike a post
- (JXHTTPOperation *)unlikeRequest:(NSString *)postID reblogKey:(NSString *)reblogKey;
- (void)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback;

/** @name Blog */

// Get information about a blog
- (JXHTTPOperation *)blogInfoRequest:(NSString *)blogName;
- (void)blogInfo:(NSString *)blogName callback:(TMAPICallback)callback;

// Get the followers for a blog
- (JXHTTPOperation *)followersRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)followers:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Get the avatar for a blog
- (JXHTTPOperation *)avatarRequest:(NSString *)blogName size:(int)size;
- (void)avatar:(NSString *)blogName size:(int)size callback:(TMAPICallback)callback;

// Get the posts for a blog
- (JXHTTPOperation *)postsRequest:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters;
- (void)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Get the queue posts for a blog
- (JXHTTPOperation *)queueRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)queue:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Get the draft posts for a blog
- (JXHTTPOperation *)draftsRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Get the submission posts for a blog
- (JXHTTPOperation *)submissionsRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Get the likes for a blog
- (JXHTTPOperation *)likesRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)likes:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/** @name Posting */

// Create a post of a given |type|
- (JXHTTPOperation *)postRequest:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters;
- (void)post:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Edit a post
- (JXHTTPOperation *)editPostRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Reblog a post
- (JXHTTPOperation *)reblogPostRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Delete a post
- (JXHTTPOperation *)deletePostRequest:(NSString *)blogName id:(NSString *)postID;
- (void)deletePost:(NSString *)blogName id:(NSString *)postID callback:(TMAPICallback)callback;

/** @name Posting - convenience */

// Create a text post
- (JXHTTPOperation *)textRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)text:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Create a quote post
- (JXHTTPOperation *)quoteRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)quote:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Create a link post
- (JXHTTPOperation *)linkRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)link:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Create a chat post
- (JXHTTPOperation *)chatRequest:(NSString *)blogName parameters:(NSDictionary *)parameters;
- (void)chat:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Create a photo post
- (JXHTTPOperation *)photoRequest:(NSString *)blogName filePathArray:(NSArray *)filePathArrayOrNil
                 contentTypeArray:(NSArray *)contentTypeArrayOrNil parameters:(NSDictionary *)parameters;
- (void)photo:(NSString *)blogName filePathArray:(NSArray *)filePathArrayOrNil contentTypeArray:(NSArray *)contentTypeArrayOrNil
   parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Create a video post
- (JXHTTPOperation *)videoRequest:(NSString *)blogName filePath:(NSString *)filePathOrNil
                      contentType:(NSString *)contentTypeOrNil parameters:(NSDictionary *)parameters;
- (void)video:(NSString *)blogName filePath:(NSString *)filePathOrNil contentType:(NSString *)contentTypeOrNil
   parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Create an audio post
- (JXHTTPOperation *)audioRequest:(NSString *)blogName filePath:(NSString *)filePathOrNil
                      contentType:(NSString *)contentTypeOrNil parameters:(NSDictionary *)parameters;
- (void)audio:(NSString *)blogName filePath:(NSString *)filePathOrNil contentType:(NSString *)contentTypeOrNil
   parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

/** @name Tagging */

// Get posts with a given tag
- (JXHTTPOperation *)taggedRequest:(NSString *)tag parameters:(NSDictionary *)parameters;
- (void)tagged:(NSString *)tag parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

@end
