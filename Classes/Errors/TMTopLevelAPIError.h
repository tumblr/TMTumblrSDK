//
//  TMTopLevelAPIError.h
//  Pods
//
//  Created by Kenny Ackerson on 7/18/16.
//
//

#import <Foundation/Foundation.h>
#import "TMAPIError.h"

/**
 * Model representing the errors in the top level of an API response.
 */
__attribute__((objc_subclassing_restricted))
@interface TMTopLevelAPIError : NSObject <TMAPIError>

/**
 *  Initializes an instance of @c TMTopLevelAPIError.
 *
 *  @param logout Whether or not this error denotes whether we should log a user out.
 *  @param title  The title of the API error. Eg "Unauthorized".
 *  @param detail A more descriptive string detailing why the error is occurring.
 *
 *  @return An initialized instance of @c TMTopLevelAPIError.
 */
- (nonnull instancetype)initWithLogout:(BOOL)logout title:(nonnull NSString *)title detail:(nonnull NSString *)detail;

@end
