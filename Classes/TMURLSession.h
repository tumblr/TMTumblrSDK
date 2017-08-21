//
//  TMURLSession.h
//  TMTumblrSDK
//
//  Created by Bryan Irace on 3/26/15.
//  Copyright (c) 2015 Tumblr. All rights reserved.
//

#import "TMAPIApplicationCredentials.h"
#import "TMAPIUserCredentials.h"
#import "TMNetworkActivityVisiblityCounter.h"
#import "TMSessionTaskUpdateDelegate.h"
#import "TMURLSessionCallbacks.h"
#import "TMSession.h"

@class TMAPIApplicationCredentials;
@class TMAPIUserCredentials;
@class TMAPIRequest;
@class TMHTTPRequest;
@protocol TMRequest;
@protocol TMURLSessionMetricsDelegate;
@protocol TMRequestTransformer;

/**
 *  Clients can post a notificaiton with this name with an instance of @c TMAPIApplicationCredentials passed as the object to replace the application credentials on all instances of @c TMURLSession.
 */
extern NSString * _Nonnull const TMURLSessionInvalidateApplicationCredentialsNotificationKey;

/**
 *  Clients can post a notificaiton with this name with a dictionary passed as the object to replace the additional headers on all instances of @c TMURLSession.
 */
extern NSString * _Nonnull const TMURLSessionInvalidateHTTPHeadersNotificationKey;

/**
 *  Manages an `NSURLSession` instance and uses it to create (OAuth-signed) Tumblr API requests.
 */
__attribute__((objc_subclassing_restricted))
@interface TMURLSession : NSObject <TMSession>

/**
 *  Initialize a URL Session .
 *
 *  @param configuration             (Required) Configuration that the underlying @c NSURLSession should be configured with.
 *  @param applicationCredentials    (Required) The current applications credentials object.
 *  @param userCredentials           (Required) The current user's credentials.
 *  @param networkActivityManager    (Optional) An object that can manage the state of whether or not the network activity indicator should be visible.
 *  @param sessionTaskUpdateDelegate (Optional) An object that is updated on changes in the session task.
 *  @param sessionMetricsDelegate    An object that can handle metrics updates for network tasks.
 *  @param additionalHeaders         (Optional) Additional headers for each requests created with this object.
 *
 *  @return The new Session instance.
 */
- (nonnull instancetype)initWithConfiguration:(nonnull NSURLSessionConfiguration *)configuration
                       applicationCredentials:(nullable TMAPIApplicationCredentials *)applicationCredentials
                              userCredentials:(nullable TMAPIUserCredentials *)userCredentials
                       networkActivityManager:(nullable id <TMNetworkActivityIndicatorManager>)networkActivityManager
                    sessionTaskUpdateDelegate:(nullable id <TMSessionTaskUpdateDelegate>)sessionTaskUpdateDelegate
                       sessionMetricsDelegate:(nullable id <TMURLSessionMetricsDelegate>)sessionMetricsDelegate
                           requestTransformer:(nullable id <TMRequestTransformer>)requestTransformer
                            additionalHeaders:(nullable NSDictionary *)additionalHeaders  NS_DESIGNATED_INITIALIZER;

/**
 *  Initialize a URL Session .
 *
 *  @param configuration          (Required) Configuration that the underlying `NSURLSession` should be configured with.
 *  @param applicationCredentials (Required) The current applications credentials object.
 *  @param userCredentials        (Required) The current user's credentials.
 *
 *  @return The new Session instance.
 */
- (nonnull instancetype)initWithConfiguration:(nonnull NSURLSessionConfiguration *)configuration
                       applicationCredentials:(nullable TMAPIApplicationCredentials *)applicationCredentials
                              userCredentials:(nullable TMAPIUserCredentials *)userCredentials;

- (nonnull instancetype)init __attribute__((unavailable("Please use initWithConfiguration:applicationCredentials:userCredentials instead.")));


@end
