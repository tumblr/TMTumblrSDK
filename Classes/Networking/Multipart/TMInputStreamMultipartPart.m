//
//  TMInputStreamMultipartPart.m
//  TMTumblrSDK
//
//  Created by Pinar Olguc on 5.05.2021.
//

#import "TMInputStreamMultipartPart.h"

@interface TMInputStreamMultipartPart ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic) NSInputStream *inputStream;

@end

@implementation TMInputStreamMultipartPart

- (nonnull instancetype)initWithInputStream:(nonnull NSInputStream *)inputStream
                                       name:(nonnull NSString *)name
                                   fileName:(nullable NSString *)fileName
                                contentType:(nonnull NSString *)contentType
                              contentLength:(UInt64)contentLength {
    NSParameterAssert(inputStream);
    NSParameterAssert(name);
    NSParameterAssert(contentType);
    self = [super init];
    
    if (self) {
        _inputStream = inputStream;
        _name = [name copy];
        _fileName = [fileName copy];
        _contentType = [contentType copy];
        _contentLength = contentLength;
    }
    return self;
}

@end
