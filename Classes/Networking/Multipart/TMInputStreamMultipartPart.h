//
//  TMInputStreamMultipartPart.h
//  TMTumblrSDK
//
//  Created by Pinar Olguc on 5.05.2021.
//

#import <Foundation/Foundation.h>
#import "TMMultipartPart.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMInputStreamMultipartPart : TMMultipartPart

@property (nonatomic, nonnull, readonly) NSInputStream *inputStream;

- (nonnull instancetype)initWithInputStream:(nonnull NSInputStream *)inputStream
                                       name:(nonnull NSString *)name
                                   fileName:(nullable NSString *)fileName
                                contentType:(nonnull NSString *)contentType
                              contentLength:(UInt64)contentLength;
@end

NS_ASSUME_NONNULL_END
