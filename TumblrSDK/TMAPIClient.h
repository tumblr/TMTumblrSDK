//
//  TMAPIClient.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

typedef void (^TMAPICallback)(id, NSError *error);
typedef void (^TMAPIDataCallback)(NSData *, NSError *error);

// TODO: Evaluate the usefulness of these
extern NSString * const TMAPIParameterLimit;
extern NSString * const TMAPIParameterOffset;
extern NSString * const TMAPIParameterTag;
extern NSString * const TMAPIParameterURL;
extern NSString * const TMAPIParameterPostID;
extern NSString * const TMAPIParameterReblogKey;
extern NSString * const TMAPIParameterType;

@interface TMAPIClient : NSObject

@property (nonatomic, copy) NSString *OAuthConsumerKey;
@property (nonatomic, copy) NSString *OAuthConsumerSecret;
@property (nonatomic, copy) NSString *OAuthToken;
@property (nonatomic, copy) NSString *OAuthTokenSecret;

@property (nonatomic, readonly) JXHTTPOperationQueue *queue;

+ (TMAPIClient *)sharedInstance;

- (JXHTTPOperation *)get:(NSString *)path parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)post:(NSString *)path parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (void)sendRequest:(JXHTTPOperation *)request callback:(TMAPICallback)callback;

// Authentication

- (JXHTTPOperation *)xAuthRequest:(NSString *)userName password:(NSString *)password callback:(TMAPICallback)callback;

// User

- (JXHTTPOperation *)userInfo:(TMAPICallback)callback;

- (JXHTTPOperation *)dashboard:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)likes:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)following:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)follow:(NSString *)blogName callback:(TMAPICallback)callback;

- (JXHTTPOperation *)unfollow:(NSString *)blogName callback:(TMAPICallback)callback;

- (JXHTTPOperation *)like:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback;

- (JXHTTPOperation *)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback;

// Blog

- (JXHTTPOperation *)blogInfo:(NSString *)blogName callback:(TMAPICallback)callback;

- (JXHTTPOperation *)followers:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)avatar:(NSString *)blogName size:(int)size callback:(TMAPIDataCallback)callback;

- (JXHTTPOperation *)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)queue:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Posting

- (JXHTTPOperation *)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)createPost:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)deletePost:(NSString *)blogName id:(NSString *)postID callback:(TMAPICallback)callback;

- (JXHTTPOperation *)text:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)quote:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)link:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)chat:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)audio:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)video:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

- (JXHTTPOperation *)photo:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

// Tagging

- (JXHTTPOperation *)tagged:(NSString *)tag parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback;

@end
