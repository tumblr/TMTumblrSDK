//
//  TMInputStreamMultipartPart.m
//  TMTumblrSDK
//
//  Created by Pinar Olguc on 5.05.2021.
//

#import "TMInputStreamMultipartPart.h"

@interface TMInputStreamMultipartPart ()

@property (nonatomic) NSInputStream *inputStream;

@end

@implementation TMInputStreamMultipartPart

- (nonnull instancetype)initWithInputStream:(nonnull NSInputStream *)inputStream
                                       name:(nonnull NSString *)name
                                   fileName:(nullable NSString *)fileName
                                contentType:(nonnull NSString *)contentType
                              contentLength:(NSUInteger)contentLength {
    NSParameterAssert(inputStream);
    self = [super initWithName:name fileName:fileName contentType:contentType contentLength:contentLength];
    
    if (self) {
        _inputStream = inputStream;
    }
    return self;
}

@end
