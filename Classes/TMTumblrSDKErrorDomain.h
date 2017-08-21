//
//  TMTumblrSDKErrorDomain.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 12/12/15.
//
//

#pragma mark - Domain

/**
 *  The error domain associated with errors from the TMTumblrSDK.
 */
extern NSString * const TMTumblrSDKErrorDomain;

#pragma mark - Error Codes

/**
 *  The error code that is returned when the URL response is not an HTTP response.
 */
extern NSInteger const TMTumblrSDKErrorURLResponseIsNotAnHTTPResponse;

/**
 *  The error code that is returned when there is no response.
 */
extern NSInteger const TMTumblrSDKErrorNoResponse;

/**
 *  The error code that is returned when the response is of the wrong type.
 */
extern NSInteger const TMTumblrSDKErrorWrongResponseType;
