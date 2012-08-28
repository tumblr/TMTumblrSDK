//
//  TMAPIClient.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

typedef void (^TMAPICallback)(id);
typedef void (^TMAPIDataCallback)(NSData *);
typedef void (^TMAPIErrorCallback)(NSError *);

// TODO: Add support for NSNumbers, NSArrays to JXHTTP
@interface TMAPIClient : NSObject

@property (nonatomic, copy) NSString *APIKey;
@property (nonatomic, copy) NSString *OAuthConsumerKey;
@property (nonatomic, copy) NSString *OAuthConsumerSecret;
@property (nonatomic, copy) NSString *OAuthToken;
@property (nonatomic, copy) NSString *OAuthTokenSecret;

+ (TMAPIClient *)sharedInstance;

// Blog methods

- (void)blogInfo:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)followers:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
            error:(TMAPIErrorCallback)error;

- (void)avatar:(NSString *)blogName size:(int)size success:(TMAPIDataCallback)success error:(TMAPIErrorCallback)error;

- (void)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
      success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)queue:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error;

- (void)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
         error:(TMAPIErrorCallback)error;

- (void)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
              error:(TMAPIErrorCallback)error;

// Posting methods

- (void)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
           error:(TMAPIErrorCallback)error;

- (void)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
             error:(TMAPIErrorCallback)error;

- (void)deletePost:(NSString *)blogName id:(NSString *)postID success:(TMAPICallback)success
             error:(TMAPIErrorCallback)error;

- (void)text:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error;

- (void)quote:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error;

- (void)link:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error;

- (void)chat:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error;

- (void)audio:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error;

- (void)video:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error;

- (void)photo:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error;

// User methods

- (void)userInfo:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)dashboard:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)likes:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)following:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)follow:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)unfollow:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)like:(NSString *)postID reblogKey:(NSString *)reblogKey success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error;

- (void)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey success:(TMAPICallback)success
         error:(TMAPIErrorCallback)error;

// Tagged methods

- (void)tagged:(NSString *)tag parameters:(NSDictionary *)parameters success:(TMAPICallback)success
         error:(TMAPIErrorCallback)error;

@end
