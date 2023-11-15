//
//  TMMultiPartRequestBodyProtocol.h
//  Pods
//
//  Created by Pinar Olguc on 7.05.2021.
//

#import "TMRequestBody.h"

NS_ASSUME_NONNULL_BEGIN

@class TMMultipartEncodedForm;

/// Represents a multi part HTTP body.
@protocol TMMultiPartRequestBodyProtocol <TMRequestBody>

/// Returns the encoded form of the request body as `TMMultipartEncodedForm`.
/// @param error The encountered error.
- (nullable TMMultipartEncodedForm *)encodeWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
