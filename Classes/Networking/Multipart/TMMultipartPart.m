//
//  TMMultipartPart.m
//  Pods
//
//  Created by Kenny Ackerson on 4/23/16.
//
//

#import "TMMultipartPart.h"

@interface TMMultipartPart ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic) NSUInteger contentLength;

@end

@implementation TMMultipartPart

- (instancetype)initWithName:(NSString *)name
                    fileName:(NSString *)fileName
                 contentType:(NSString *)contentType
               contentLength:(NSUInteger)contentLength {
    NSParameterAssert(name);
    NSParameterAssert(contentType);
    self = [super init];
    
    if (self) {
        _name = [name copy];
        _fileName = [fileName copy];
        _contentType = [contentType copy];
        _contentLength = contentLength;
    }
    
    return self;
}

@end
