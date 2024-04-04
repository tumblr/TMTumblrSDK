//
//  TMFormEncodedRequestBody.h
//  Pods
//
//  Created by Kenny Ackerson on 4/25/16.
//
//

#import <Foundation/Foundation.h>
#import "TMRequestBody.h"

/**
 * A request body that form encodes a dictionary
 */
__attribute__((objc_subclassing_restricted))
@interface TMFormEncodedRequestBody : NSObject <TMRequestBody>

/**
 *  Initializes an instance of @c TMFormEncodedRequestBody
 *
 *  @param body The dictionary to form encode.
 *
 *  @return A newly initialized instance of @c TMFormEncodedRequestBody
 */
- (nonnull instancetype)initWithBody:(nonnull NSDictionary *)body;

@end
