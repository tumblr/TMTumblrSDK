//
//  TMAPIErrorFactory.h
//  Pods
//
//  Created by Kenny Ackerson on 7/18/16.
//
//

#import <Foundation/Foundation.h>
#import "TMAPIError.h"

/**
 * A factory class that can determine which kind of @c TMAPIError we need to provide to clients.
 */
__attribute__((objc_subclassing_restricted))
@interface TMAPIErrorFactory : NSObject

/**
 *  Initializes this factory with the array of objects that are present in the API response.
 *
 *  @param errors The error objects that are inside the API response.
 *  @param legacy Whether or not these are legacy formatted errors.
 *
 *  @return A new factory class that can generate the correct @c TMAPIError.
 */
- (nonnull instancetype)initWithErrors:(nonnull NSArray <NSDictionary *> *)errors legacy:(BOOL)legacy;

/**
 *  Creates an array of @c TMAPIError's that appear in the response of a response.
 *
 *  @return An array of @c TMAPIError's that appear in the response of a response.
 */
- (nonnull NSArray <id <TMAPIError>> *)APIErrors;

@end
