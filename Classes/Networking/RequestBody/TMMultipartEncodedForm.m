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

- (nonnull instancetype)initWithData:(nullable NSData *)data
                             fileURL:(nullable NSURL *)fileURL {
    self = [super init];
    
    if (self) {
        _data = data;
        _fileURL = fileURL;
    }
    
    return self;
}

@end
