//
//  TMEncodableMultipartFormDataTests.m
//  ExampleiOSTests
//
//  Created by Pinar Olguc on 6.05.2021.
//  Copyright © 2021 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMMultipartFormData.h>
#import <TMTumblrSDK/TMMultipartRequestBody.h>
#import <TMTumblrSDK/TMEncodableMultipartFormData.h>
#import <TMTumblrSDK/TMMultipartConstants.h>

@interface TMEncodableMultipartFormDataTests : XCTestCase

@end

@implementation TMEncodableMultipartFormDataTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    [self createTempDirectory];
}

- (void)tearDown {
    [self removeAllItemsInsideTempDirectory];
}

- (void)testWriteMultipleEncodedBodyPartsToDisk {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    TMEncodableMultipartFormData *form = [[TMEncodableMultipartFormData alloc] initWithFileManager:[NSFileManager defaultManager] boundary:TMMultipartBoundary];

    [form appendData:[@"The quick brown fox jumps over the lazy dog." dataUsingEncoding:NSUTF8StringEncoding] name:@"latinAlphabetData" fileName:nil contentType:@"plain/text"];
    [form appendData:[@"日本語" dataUsingEncoding:NSUTF8StringEncoding] name:@"japaneseData" fileName:nil contentType:@"plain/text"];
    [form appendData:[@"😅🐻👋🍒🎉" dataUsingEncoding:NSUTF8StringEncoding] name:@"emojiData" fileName:nil contentType:@"plain/text"];

    NSURL *outputURL = [self tempFileURL];
    NSError *error;
    [form writePartsToFileWithURL:outputURL error:&error];
    XCTAssertNil(error);
    
    NSString *path = [bundle pathForResource:@"multipartTextData" ofType:@""];
    NSData *expectedData = [NSData dataWithContentsOfFile:path];
    NSData *generatedData = [NSData dataWithContentsOfURL:outputURL];
    
    XCTAssert([expectedData isEqual:generatedData]);
}

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
