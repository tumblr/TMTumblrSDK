//
//  TMAPIClient.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "JXHTTP.h"

typedef void (^TMAPICallback)(id);
typedef void (^TMAPIDataCallback)(NSData *);
typedef void (^TMAPIErrorCallback)(NSError *);

extern NSString * const TMAPIBaseURL;

@interface TMAPIClient : NSObject

@property (nonatomic, copy) NSString *OAuthConsumerKey;
@property (nonatomic, copy) NSString *OAuthConsumerSecret;
@property (nonatomic, copy) NSString *OAuthToken;
@property (nonatomic, copy) NSString *OAuthTokenSecret;

+ (TMAPIClient *)sharedInstance;

- (JXHTTPOperation *)get:(NSString *)path parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                   error:(TMAPIErrorCallback)error;

- (JXHTTPOperation *)post:(NSString *)path parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                    error:(TMAPIErrorCallback)error;

- (void)sendRequest:(JXHTTPOperation *)request;

@end
