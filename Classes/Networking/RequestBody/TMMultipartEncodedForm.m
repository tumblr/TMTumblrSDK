//
//  TMMultipartEncodedForm.m
//  Pods-ExampleiOS
//
//  Created by Pinar Olguc on 7.05.2021.
//

#import "TMMultipartEncodedForm.h"

@interface TMMultipartEncodedForm ()

@property (nonatomic) NSData *data;
@property (nonatomic) NSURL *fileURL;

@end

@implementation TMMultipartEncodedForm

- (nonnull instancetype)initWithData:(NSData *)data
                             fileURL:(NSURL *)fileURL {
    NSParameterAssert(fileURL);

    self = [super init];
    
    if (self) {
        _data = data;
        _fileURL = fileURL;
    }
    
    return self;
}

- (nonnull instancetype)initWithData:(NSData *)data {
    self = [super init];
    
    if (self) {
        _data = data;
        NSString *extension = [NSUUID UUID].UUIDString;
        _fileURL = [[NSURL alloc] initFileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:extension]];
    }
    
    return self;
}

@end
