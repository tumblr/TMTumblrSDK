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

@end
