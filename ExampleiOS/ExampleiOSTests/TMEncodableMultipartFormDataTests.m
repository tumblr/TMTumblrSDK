//
//  TMEncodableMultipartFormDataTests.m
//  ExampleiOSTests
//
//  Created by Pinar Olguc on 6.05.2021.
//  Copyright © 2021 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMBaseTestCase.h"
#import <TMTumblrSDK/TMMultipartRequestBody.h>
#import <TMTumblrSDK/TMEncodableMultipartFormData.h>
#import <TMTumblrSDK/TMMultipartConstants.h>

@interface TMEncodableMultipartFormDataTests : TMBaseTestCase

@end

@implementation TMEncodableMultipartFormDataTests

- (void)testWriteMultipleEncodedBodyPartsToDisk {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    TMEncodableMultipartFormData *form = [[TMEncodableMultipartFormData alloc] initWithFileManager:[NSFileManager defaultManager] boundary:TMMultipartBoundary];

    [form appendData:[@"The quick brown fox jumps over the lazy dog." dataUsingEncoding:NSUTF8StringEncoding] name:@"latinAlphabetData" fileName:@"testFilename" contentType:@"plain/text"];
    [form appendData:[@"日本語" dataUsingEncoding:NSUTF8StringEncoding] name:@"japaneseData" fileName:nil contentType:@"plain/text"];
    [form appendData:[@"😅🐻👋🍒🎉" dataUsingEncoding:NSUTF8StringEncoding] name:@"emojiData" fileName:nil contentType:@"plain/text"];

    NSURL *outputURL = [self tempFileURL];
    NSError *error;
    [form encodeIntoFileWithURL:outputURL error:&error];
    XCTAssertNil(error);
    
    NSString *path = [bundle pathForResource:@"multipartTextData" ofType:@""];
    NSData *expectedData = [NSData dataWithContentsOfFile:path];
    NSData *generatedData = [NSData dataWithContentsOfURL:outputURL];
    
    XCTAssert([expectedData isEqual:generatedData]);
}

- (void)testInvalidLastPathComponent {
    
    TMEncodableMultipartFormData *form = [[TMEncodableMultipartFormData alloc] initWithFileManager:[NSFileManager defaultManager] boundary:TMMultipartBoundary];

    NSURL *fileURL = [NSURL fileURLWithPath:@""];
    
    NSError *error;
    [form appendFileURL:fileURL name:@"name" contentType:@"contenType" error:&error];
    XCTAssertEqual(error.code, TMMultipartFormErrorTypeFileNameNotValid);
}

- (void)testAppendNonFileURL {
    
    TMEncodableMultipartFormData *form = [[TMEncodableMultipartFormData alloc] initWithFileManager:[NSFileManager defaultManager] boundary:TMMultipartBoundary];

    NSURL *fileURL = [NSURL URLWithString:@"https://test.com/image.jpg"];
    
    NSError *error;
    [form appendFileURL:fileURL name:@"name" contentType:@"contenType" error:&error];
    XCTAssertEqual(error.code, TMMultipartFormErrorTypeURLNotUsingFileScheme);
}

- (void)testAppendNonReachableFileURL {
    
    TMEncodableMultipartFormData *form = [[TMEncodableMultipartFormData alloc] initWithFileManager:[NSFileManager defaultManager] boundary:TMMultipartBoundary];

    NSURL *fileURL = [NSURL fileURLWithPath:@"not-existing.png"];
    
    NSError *error;
    [form appendFileURL:fileURL name:@"name" contentType:@"contenType" error:&error];
    XCTAssertEqual(error.code, TMMultipartFormErrorTypeFileNotReachable);
}

- (void)testAppendDirectory {
    
    TMEncodableMultipartFormData *form = [[TMEncodableMultipartFormData alloc] initWithFileManager:[NSFileManager defaultManager] boundary:TMMultipartBoundary];

    NSURL *fileURL = [self tempTestDirectory];

    NSError *error;
    [form appendFileURL:fileURL name:@"name" contentType:@"contenType" error:&error];
    XCTAssertEqual(error.code, TMMultipartFormErrorTypeFileIsDirectory);
}

- (void)testWritingToAnExistingFileFails {
    TMEncodableMultipartFormData *form = [[TMEncodableMultipartFormData alloc] initWithFileManager:[NSFileManager defaultManager] boundary:TMMultipartBoundary];

    NSURL *fileURL = [self tempFileURL];
    
    NSError *writeError;
    [@"test" writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    XCTAssertNil(writeError);
    
    NSData *testData = [@"Lorem ipsum" dataUsingEncoding:NSUTF8StringEncoding];

    [form appendData:testData name:@"name" fileName:nil contentType:@"contenType"];
    
    NSError *error;
    [form encodeIntoFileWithURL:fileURL error:&error];
    
    XCTAssertEqual(error.code, TMMultipartFormErrorTypeOutputFileAlreadyExists);
}

- (void)testWritingToBadURLFails {
    TMEncodableMultipartFormData *form = [[TMEncodableMultipartFormData alloc] initWithFileManager:[NSFileManager defaultManager] boundary:TMMultipartBoundary];

    NSURL *fileURL = [NSURL URLWithString:@"/bad/url"];
        
    NSData *testData = [@"Lorem ipsum" dataUsingEncoding:NSUTF8StringEncoding];

    [form appendData:testData name:@"name" fileName:nil contentType:@"contenType"];
    
    NSError *error;
    [form encodeIntoFileWithURL:fileURL error:&error];
    
    XCTAssertEqual(error.code, TMMultipartFormErrorTypeOutputFileURLInvalid);
}

- (void)testUnexpecedStreamLenght {
    TMEncodableMultipartFormData *form = [[TMEncodableMultipartFormData alloc] initWithFileManager:[NSFileManager defaultManager] boundary:TMMultipartBoundary];

    NSData *testData = [@"Lorem ipsum" dataUsingEncoding:NSUTF8StringEncoding];
    [form appendData:testData name:@"name" fileName:nil contentType:@"contenType"];

    NSError *error1;
    [form encodeIntoDataWithError:&error1];
    
    NSError *error2;
    [form encodeIntoDataWithError:&error2];

    XCTAssertNil(error1);
    XCTAssertEqual(error2.code, TMMultipartFormErrorTypeUnexpectedInputLength);
}

@end
