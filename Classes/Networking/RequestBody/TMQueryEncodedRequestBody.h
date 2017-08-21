//
//  TMQueryEncodedRequestBody.h
//  Pods
//
//  Created by Kenny Ackerson on 4/25/16.
//
//

#import <Foundation/Foundation.h>
#import "TMRequestBody.h"

/**
 * A request body that represents a query string.
 */
__attribute__((objc_subclassing_restricted))
@interface TMQueryEncodedRequestBody : NSObject <TMRequestBody>

/**
 *  Initializes an instance of @c TMQueryEncodedRequestBody.
 *
 *  @param queryDictionary The keys and values that represent the query string.
 *
 *  @return A newly initialized instance of @c TMQueryEncodedRequestBody.
 */
- (nonnull instancetype)initWithQueryDictionary:(nonnull NSDictionary *)queryDictionary;

@end
