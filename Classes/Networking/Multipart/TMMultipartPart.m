//
//  TMMultipartPart.m
//  Pods
//
//  Created by Kenny Ackerson on 4/23/16.
//
//

#import "TMMultipartPart.h"
#import "TMMultipartConstants.h"

@interface TMMultipartPart ()

@property (nonatomic, nonnull, readonly) NSData *data;
@property (nonatomic, nonnull, copy, readonly) NSString *name;
@property (nonatomic, nonnull, copy, readonly) NSString *fileName;
@property (nonatomic, nonnull, copy, readonly) NSString *contentType;

@end

@implementation TMMultipartPart

- (nonnull instancetype)initWithData:(nonnull NSData *)data
                                name:(nonnull NSString *)name
                            fileName:(nullable NSString *)fileName
                         contentType:(nonnull NSString *)contentType {
    NSParameterAssert(data);
    NSParameterAssert(name);
    NSParameterAssert(contentType);
    self = [super init];

    if (self) {
        _data = data;
        _name = [name copy];
        _fileName = [fileName copy];
        _contentType = [contentType copy];
    }
    
    return self;
}

- (nonnull NSData *)dataRepresentationWithBoundary:(nonnull NSString *)boundary {
    NSParameterAssert(boundary);
    
    NSMutableData *bodyData = [[NSMutableData alloc] init];

    NSData *prefixData = ({
        NSMutableString *prefixString = [[NSMutableString alloc] init];

        [prefixString appendString:boundary];
        [prefixString appendString:TMMultipartCRLF];

        [prefixString appendFormat:@"Content-Disposition: form-data; name=\"%@\"", self.name];

        if (self.fileName) {
            [prefixString appendFormat:@"; filename=\"%@\"", self.fileName];
        }

        [prefixString appendString:TMMultipartCRLF];

        [prefixString appendFormat:@"Content-Type: %@", self.contentType];

        [prefixString appendString:TMMultipartCRLF];
        [prefixString appendString:TMMultipartCRLF];
        [prefixString dataUsingEncoding:NSUTF8StringEncoding];
    });

    if (prefixData) {
        [bodyData appendData:prefixData];
    }

    [bodyData appendData:self.data];

    NSData *CRLFData = [TMMultipartCRLF dataUsingEncoding:NSUTF8StringEncoding];

    if (CRLFData) {
        [bodyData appendData:CRLFData];
    }

    return bodyData;
}

@end
