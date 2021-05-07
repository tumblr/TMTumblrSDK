//
//  TMMultiPartRequestBodyProtocol.h
//  Pods
//
//  Created by Pinar Olguc on 7.05.2021.
//

#import "TMRequestBody.h"

NS_ASSUME_NONNULL_BEGIN

@class TMMultipartEncodedForm;

@protocol TMMultiPartRequestBodyProtocol <TMRequestBody>

- (nullable TMMultipartEncodedForm *)encodeWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
