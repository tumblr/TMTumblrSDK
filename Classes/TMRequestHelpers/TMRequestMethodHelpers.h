//
//  TMRequestMethodHelpers.h
//  Pods
//
//  Created by Kenny Ackerson on 6/17/16.
//
//

#import <Foundation/Foundation.h>
#import "TMHTTPRequestMethod.h"

__attribute__((objc_subclassing_restricted))
@interface TMRequestMethodHelpers : NSObject

/**
 *  Calculates a @c TMHTTPRequestMethod out of a string. Accepts either GET, POST, or DELETE. Defaults to @c TMHTTPRequestMethodGET if the string
 *  is something else.
 *
 *  @param methodString The string representation of the HTTP request method
 *
 *  @return A request method based on the string representation.
 */
+ (TMHTTPRequestMethod)methodFromString:(nonnull NSString *)methodString;

+ (nonnull NSString *)stringFromMethod:(TMHTTPRequestMethod)method;

@end
