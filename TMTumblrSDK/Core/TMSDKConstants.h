//
//  TMSDKConstants.h
//  TMTumblrSDK
//
//  Created by Sergey Shpuntov on 3/11/16.
//  Copyright (c) 2016 Tumblr. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @abstract The error domain for all errors from TMTumblrSDK.
 */
FOUNDATION_EXPORT NSString *const TMTumblrSDKErrorDomain;

/*!
 @typedef NS_ENUM(NSInteger, TMTumblrSDKErrorCode)
 @abstract Error codes for TMTumblrSDKErrorDomain.
 */
typedef NS_ENUM(NSInteger, TMTumblrSDKErrorCode) {
    /*!
     @abstract The error code for unknown errors.
     */
    TMTumblrSDKUnknownErrorCode = 0,

    /*!
     @abstract The error code for failed requests.
     */
    TMTumblrSDKRequestFailedErrorCode,

    /*!
     @abstract Authentication canceled by a user.
     */
    TMTumblrSDKCanceledErrorCode,
};

/*!
 @const NSURLErrorFailingURLErrorKey
 @abstract The NSError userInfo dictionary key used to store and retrieve HTTP status code of failed request.
 */
FOUNDATION_EXPORT NSString * const TMTumblrSDKHTTPStatusCodeErrorKey;
