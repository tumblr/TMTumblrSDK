//
//  TMMultipartFormData.m
//  Pods
//
//  Created by Kenny Ackerson on 4/23/16.
//
//

#import "TMMultipartFormData.h"
#import "TMMultipartPart.h"
#import "TMMultipartConstants.h"

@interface TMMultipartFormData ()

@property (nonatomic, nonnull, copy, readonly) NSArray <TMMultipartPart *> *parts;
@property (nonatomic, nonnull, copy, readonly) NSString *boundary;

@end

@implementation TMMultipartFormData

- (nonnull instancetype)initWithParts:(nonnull NSArray <TMMultipartPart *> *)parts boundary:(nonnull NSString *)boundary {
    NSParameterAssert(parts);
    NSParameterAssert(boundary);
    self = [super init];

    if (self) {
        _parts = [parts copy];
        _boundary = [boundary copy];
    }
    
    return self;
}

- (nonnull NSData *)dataRepresentation {
    NSMutableData *data = [[NSMutableData alloc] init];

    // Maps all the current body parts to data and appends to the mutable data.
    {
        NSString *boundary = self.boundary;
        for (TMMultipartPart *bodyPart in self.parts) {
            [data appendData:[bodyPart dataRepresentationWithBoundary:[@"--" stringByAppendingString:boundary]]];
        }
    }

    NSData *boundaryData = [[NSString stringWithFormat:@"--%@--", self.boundary] dataUsingEncoding:NSUTF8StringEncoding];

    if (boundaryData) {
        [data appendData:boundaryData];
    }

    NSData *CRLFData = [TMMultipartCRLF dataUsingEncoding:NSUTF8StringEncoding];

    if (CRLFData) {
        [data appendData:CRLFData];
    }

    return data;
}

@end
