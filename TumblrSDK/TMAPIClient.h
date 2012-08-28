//
//  TMAPIClient.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

typedef void (^TMAPISuccessCallback)(id);
typedef void (^TMAPIErrorCallback)(NSError *);

// TODO: Add support for NSNumbers, NSArrays to JXHTTP
@interface TMAPIClient : NSObject

@property (nonatomic, copy) NSString *APIKey;
@property (nonatomic, copy) NSString *OAuthConsumerKey;
@property (nonatomic, copy) NSString *OAuthConsumerSecret;
@property (nonatomic, copy) NSString *OAuthToken;
@property (nonatomic, copy) NSString *OAuthTokenSecret;

+ (TMAPIClient *)sharedInstance;

// TODO: Add methods that don't require properties with defaults?

// TODO: Probably use my own queue instance rather than shared queue

// Blog methods

- (void)blogInfo:(NSString *)blogName
         success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

- (void)followers:(NSString *)blogName parameters:(NSDictionary *)parameters
          success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

- (void)avatar:(NSString *)blogName size:(int)size
       success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

- (void)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
      success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

- (void)queue:(NSString *)blogName parameters:(NSDictionary *)parameters
      success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

- (void)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters
       success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

- (void)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters
            success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

// Posting methods

// TODO: Text
// TODO: Photo
// TODO: Quote
// TODO: Link
// TODO: Chat
// TODO: Audio
// TODO: Video
// TODO: Answer
// TODO: Edit
// TODO: Reblog
// TODO: Delete

// User methods

- (void)userInfo:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

- (void)dashboard:(NSDictionary *)parameters
          success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

- (void)likes:(NSDictionary *)parameters
      success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

- (void)following:(NSDictionary *)parameters
          success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

// TODO: Follow
// TODO: Unfollow
// TODO: Like
// TODO: Unlike

// Tagged methods

- (void)tagged:(NSString *)tag parameters:(NSDictionary *)parameters
       success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

@end
