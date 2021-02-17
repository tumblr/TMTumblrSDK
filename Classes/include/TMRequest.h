//
//  TMRequest.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/16/16.
//
//

#import "TMHTTPRequestMethod.h"

@protocol TMRequestBody;

@protocol TMRequest

/**
 *  Additional headers for this request.
 */
@property (nonatomic, nullable, copy, readonly) NSDictionary *additionalHeaders;

/**
 *  The URL for this request.
 */
@property (nonatomic, nonnull, readonly) NSURL *URL;

/**
 *  The request body for this request that represents the body data.
 */
@property (nonatomic, readonly, nullable) id <TMRequestBody> requestBody;

/**
 *  Whether the request should be signed.
 */
@property (nonatomic, readonly) BOOL isSigned;

/**
 *  The request method for the request.
 */
@property (nonatomic, readonly) TMHTTPRequestMethod method;

/**
 *  Since we handle uploads a little differently, we need to mark requests that are specifically only upload requests (eg "multipart requests").
 */
@property (nonatomic, readonly) BOOL isUpload;

/**
 *  Query parameters for this request.
 */
@property (nonatomic, nullable, copy, readonly) NSDictionary *queryParameters;

/**
 *  Makes a new instance of @c TMRequest by adding query parameters.
 *
 *  @param queryParameters The additional query parameters to add to the request.
 *
 *  @return A new instance of @c TMRequest with additional query parameters.
 */
- (nonnull id <TMRequest>)requestByAddingQueryParameters:(nonnull NSDictionary *)queryParameters;

/**
 Makes a new instance of @c TMRequest by adding headers.

 @param additionalHeaders The new headers to add to the request.
 @return A new instance of @c TMRequest with additional headers.
 */
- (nonnull id <TMRequest>)requestByAddingAdditionalHeaders:(nonnull NSDictionary *)additionalHeaders;

@end
