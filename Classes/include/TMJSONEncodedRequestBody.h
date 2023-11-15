//
//  TMJSONEncodedRequestBody.h
//  Pods
//
//  Created by Kenny Ackerson on 4/25/16.
//
//

#import <Foundation/Foundation.h>
#import "TMRequestBody.h"

/**
 * A request body that represents a JSON string.
 */
__attribute__((objc_subclassing_restricted))
@interface TMJSONEncodedRequestBody : NSObject <TMRequestBody>

/**
 *  Initialized instance of @c TMJSONEncodedRequestBody.
 *
 *  @param JSONDictionary The JSON dictionary object that will be transformed into a request body.
 *
 *  @return A newly initialized instance of @c TMJSONEncodedRequestBody.
 */
- (nonnull instancetype)initWithJSONDictionary:(nonnull NSDictionary *)JSONDictionary;

@end
