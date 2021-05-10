//
//  TMMultipartEncodedForm.m
//  Pods
//
//  Created by Pinar Olguc on 7.05.2021.
//

#import "TMMultipartEncodedForm.h"
#import "TMMultipartConstants.h"

@interface TMMultipartEncodedForm ()

@property (nonatomic) NSData *data;
@property (nonatomic) NSURL *fileURL;

@end

@implementation TMMultipartEncodedForm

- (instancetype)initWithFileURL:(NSURL *)fileURL
                           data:(NSData *)data {
    NSParameterAssert(fileURL);
    
    self = [super init];
    
    if (self) {
        _data = data;
        _fileURL = fileURL;
    }
    
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    
    if (self) {
        _data = data;
        NSString *extension = [NSUUID UUID].UUIDString;
        _fileURL = [[NSURL alloc] initFileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", TMMultipartFormDirectory, extension]]];
    }
    
    return self;
}

@end
