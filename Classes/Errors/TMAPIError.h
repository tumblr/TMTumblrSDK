//
//  TMAPIError.h
//  Pods
//
//  Created by Kenny Ackerson on 7/18/16.
//
//

/**
 *  A protocol representing errors that are inside of an API response.
 */
@protocol TMAPIError 

/**
 *  Whether this error means we need to log the user out.
 */
@property (nonatomic, readonly) BOOL logout;

/**
 *  The title of the API error. Eg "Unauthorized".
 */
@property (nonatomic, readonly, nonnull) NSString *title;

/**
 *  A more descriptive string detailing why the error is occurring.
 */
@property (nonatomic, readonly, nonnull) NSString *detail;

@end

