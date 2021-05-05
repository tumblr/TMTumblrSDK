//
//  TMInputStreamMultipartPart.h
//  TMTumblrSDK
//
//  Created by Pinar Olguc on 5.05.2021.
//

#import <Foundation/Foundation.h>
#import "TMMultipartPartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMInputStreamMultipartPart : NSObject <TMMultipartPartProtocol>

@property (nonatomic, readonly) UInt64 contentLength;
@property (nonatomic, nonnull, readonly) NSInputStream *inputStream;
@property (nonatomic, nonnull, copy, readonly) NSString *name;
@property (nonatomic, nullable, copy, readonly) NSString *fileName;
@property (nonatomic, nonnull, copy, readonly) NSString *contentType;
@property (nonatomic) BOOL hasTopBoundary;
@property (nonatomic) BOOL hasBottomBoundary;

- (nonnull instancetype)initWithInputStream:(nonnull NSInputStream *)inputStream
                                       name:(nonnull NSString *)name
                                   fileName:(nullable NSString *)fileName
                                contentType:(nonnull NSString *)contentType
                              contentLength:(UInt64)contentLength;
@end

NS_ASSUME_NONNULL_END
