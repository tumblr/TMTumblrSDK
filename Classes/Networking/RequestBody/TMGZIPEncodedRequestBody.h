//
//  TMGZIPEncodeRequestBody.h
//  TMTumblrSDK
//
//  Created by Michael Benedict on 2/9/18.
//

#import <Foundation/Foundation.h>
#import "TMRequestBody.h"

/**
 * A request body that represents gzipped data.
 */
__attribute__((objc_subclassing_restricted))
@interface TMGZIPEncodedRequestBody : NSObject <TMRequestBody>

/**
 *  Initialized instance of @c TMGZIPEncodedRequestBody.
 *
 *  @param body The uncompressed body that will be transformed into a gzipped request body.
 *
 *  @return A newly initialized instance of @c TMGZIPEncodedRequestBody.
 */
- (nonnull instancetype)initWithRequestBody:(nonnull id<TMRequestBody>)body;

@end
