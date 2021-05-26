//
//  TMMultipartEncodedForm.m
//  Pods
//
//  Created by Pinar Olguc on 7.05.2021.
//

#import "TMMultipartEncodedForm.h"
#import "TMMultipartUtil.h"

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
        if (_data) {
            _fileURL = [TMMultipartUtil createTempFileWithError:nil];
            if (_fileURL && ![_data writeToURL:_fileURL atomically:YES]) {
                _fileURL = nil;
            }
        }
    }
    
    return self;
}

@end
