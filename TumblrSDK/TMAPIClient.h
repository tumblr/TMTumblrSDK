//
//  TMAPIClient.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

typedef void (^TMAPICallback)(id, NSError *error);

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

- (void)sendRequest:(JXHTTPOperation *)request;

- (void)sendRequest:(JXHTTPOperation *)request callback:(TMAPICallback)callback;

@end
