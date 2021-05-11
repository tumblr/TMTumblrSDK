//
//  TMBaseTestCase.m
//  ExampleiOSTests
//
//  Created by Pinar Olguc on 10.05.2021.
//  Copyright © 2021 tumblr. All rights reserved.
//

#import "TMBaseTestCase.h"

@implementation TMBaseTestCase

- (void)setUp {
    [super setUp];
    [self createTempDirectory];
}

- (void)tearDown {
    [self removeAllItemsInsideTempDirectory];
}

//MARK: - Temp directory utils

- (NSURL *)tempTestDirectory {
    return [[[NSFileManager defaultManager] temporaryDirectory] URLByAppendingPathComponent:@"com.tumblr.sdk"];
}

- (NSURL *)tempFileURL {
    return [[self tempTestDirectory] URLByAppendingPathComponent: [[NSUUID UUID] UUIDString]];
}

- (BOOL)removeAllItemsInsideTempDirectory
{
    __block BOOL result = YES;
    NSDirectoryEnumerator<NSString *> *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:[self tempTestDirectory].path];
    NSString *fileName;
    while (fileName = [enumerator nextObject])
    {
        NSURL *fileURL = [[self tempTestDirectory] URLByAppendingPathComponent: fileName];
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:fileURL.path error:nil];
        if (!success) {
            result = NO;
        }
    }
    return result;
}

- (BOOL)createTempDirectory
{
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtURL:self.tempTestDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    return error == nil;
}

@end
