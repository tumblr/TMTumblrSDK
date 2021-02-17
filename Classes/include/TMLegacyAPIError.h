//
//  TMLegacyAPIError.h
//  Pods
//
//  Created by Kenny Ackerson on 7/18/16.
//
//

#import <Foundation/Foundation.h>
#import "TMAPIError.h"

/**
 * An error that represents an errors key that appears in the "response" dictionary instead of the correct place (top level).
 */
__attribute__((objc_subclassing_restricted))
@interface TMLegacyAPIError : NSObject <TMAPIError>

/**
 *  Initializes an instance of @c TMLegacyAPIError
 *
 *  This error will always default @c logout to NO because there is no notion of this in legacy errors.
 *
 *  @param title  The title of the API error. Eg "Unauthorized".
 *  @param detail A more descriptive string detailing why the error is occurring.
 *
 *  @return A new instance of @c TMLegacyAPIError.
 */
- (nonnull instancetype)initWithTitle:(nonnull NSString *)title detail:(nonnull NSString *)detail;

@end
