//
//  TMAPIClient.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

typedef void (^TMAPISuccessCallback)(id);
typedef void (^TMAPIErrorCallback)(NSError *);

@interface TMAPIClient : NSObject

@property (nonatomic, copy) NSString *APIKey;
@property (nonatomic, copy) NSString *OAuthConsumerKey;
@property (nonatomic, copy) NSString *OAuthConsumerSecret;
@property (nonatomic, copy) NSString *OAuthToken;
@property (nonatomic, copy) NSString *OAuthTokenSecret;

+ (TMAPIClient *)sharedInstance;

// TODO: Add methods that don't require properties with defaults?

// Blog methods

- (void)blogInfo:(NSString *)blogName
         success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

- (void)followers:(NSString *)blogName limit:(int)limit offset:(int)offset
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

@end
