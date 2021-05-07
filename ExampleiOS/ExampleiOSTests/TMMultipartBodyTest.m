//
//  TMMultipartBodyTest.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/13/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMMultipartRequestBodyFactory.h>
#import <TMTumblrSDK/TMMultipartRequestBody.h>
#import <TMTumblrSDK/TMRequestBody.h>
@import TMTumblrSDK;

@interface TMMultipartBodyTest : XCTestCase

@end

@implementation TMMultipartBodyTest

- (void)testMultipartDataIsTheSameBySpecifyingKeys {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];

    id <TMRequestBody> requestBody = [TMMultipartRequestBodyFactory multipartRequestBodyForParameters:nil filePathArray:@[path] contentTypeArray:@[@"image/png"] fileNameArray:@[@"code.png"] type:@"image" keys:@[@"data"]];

    NSData *data = [requestBody bodyData];

    NSString *pathToKnownMultipartData = [bundle pathForResource:@"data" ofType:@""];

    NSData *knownMultipartData = [NSData dataWithContentsOfFile:pathToKnownMultipartData];

    XCTAssert([knownMultipartData isEqual:data]);
}

- (void)testMultipartBodyIsTheSameFactoryWithMultipartBody {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];

    id <TMRequest> request = [requestFactory multipartPostRequestForParameters:nil path:@"" requestBody:[TMMultipartRequestBodyFactory multipartRequestBodyForParameters:nil filePathArray:@[path] contentTypeArray:@[@"image/png"] fileNameArray:@[@"code.png"] type:@"image" keys:@[@"data"]]];

    NSString *pathToKnownMultipartData = [bundle pathForResource:@"data" ofType:@""];

    NSData *knownMultipartData = [NSData dataWithContentsOfFile:pathToKnownMultipartData];

    XCTAssert([knownMultipartData isEqual:request.requestBody.bodyData]);
}

- (void)testMultipartDataDoesntCrashWithAnNSNULL {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];

    id <TMRequestBody> requestBody = [TMMultipartRequestBodyFactory multipartRequestBodyForParameters:nil filePathArray:@[path, [NSNull null]] contentTypeArray:@[@"image/png", @"image/png"] fileNameArray:@[@"code.png", @"other.png"] type:@"image" keys:@[@"data", @"live_photo"]];

    NSData *data = [requestBody bodyData];

    NSString *pathToKnownMultipartData = [bundle pathForResource:@"data" ofType:@""];

    NSData *knownMultipartData = [NSData dataWithContentsOfFile:pathToKnownMultipartData];

    XCTAssert([knownMultipartData isEqual:data]);
}


- (void)testMultipartBodyIsTheSameFactoryWithoutMultipartBodyWithBlogName {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];

    id <TMRequest> request = [requestFactory multipartPostRequestForParameters:nil blogName:@"" type:@"image" filePathArray:@[path] contentTypeArray:@[@"image/png"] fileNameArray:@[@"code.png"]];

    NSString *pathToKnownMultipartData = [bundle pathForResource:@"data" ofType:@""];

    NSData *knownMultipartData = [NSData dataWithContentsOfFile:pathToKnownMultipartData];

    XCTAssert([knownMultipartData isEqual:request.requestBody.bodyData]);
}

- (void)testMultipartBodyIsTheSameFactoryWithMultipartBodyBlogName {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];

    id <TMRequest> request = [requestFactory multipartPostRequestForParameters:nil blogName:@"" requestBody:[TMMultipartRequestBodyFactory multipartRequestBodyForParameters:nil filePathArray:@[path] contentTypeArray:@[@"image/png"] fileNameArray:@[@"code.png"] type:@"image" keys:@[@"data"]]];

    NSString *pathToKnownMultipartData = [bundle pathForResource:@"data" ofType:@""];

    NSData *knownMultipartData = [NSData dataWithContentsOfFile:pathToKnownMultipartData];

    XCTAssert([knownMultipartData isEqual:request.requestBody.bodyData]);
}

- (void)testMultipartBodyIsTheSameFactoryWithItGeneratingMultipartBody {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];

    id <TMRequest> request = [requestFactory multipartPostRequestForParameters:nil path:@"" type:@"image" filePathArray:@[path] contentTypeArray:@[@"image/png"] fileNameArray:@[@"code.png"]];

    NSString *pathToKnownMultipartData = [bundle pathForResource:@"data" ofType:@""];

    NSData *knownMultipartData = [NSData dataWithContentsOfFile:pathToKnownMultipartData];

    XCTAssert([knownMultipartData isEqual:request.requestBody.bodyData]);
}

- (void)testMultipartDataIsTheSameBySpecifyingKeysMultipleFilePaths {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];
    NSString *pathTwo = [bundle pathForResource:@"spaces" ofType:@"png"];

    id <TMRequestBody> requestBody = [TMMultipartRequestBodyFactory multipartRequestBodyForParameters:nil filePathArray:@[path, pathTwo] contentTypeArray:@[@"image/png", @"image/png"] fileNameArray:@[@"code.png", @"spaces.png"] type:@"image" keys:@[@"data", @"data"]];

    NSData *data = [requestBody bodyData];


//    NSString *writeDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"multiple_files"];
//
//    [data writeToFile:writeDirectory atomically:YES];

    NSString *pathToKnownMultipartData = [bundle pathForResource:@"multiple_files" ofType:@""];

    NSData *knownMultipartData = [NSData dataWithContentsOfFile:pathToKnownMultipartData];

    XCTAssert([knownMultipartData isEqual:data]);
}

- (void)testMultipartDataIsTheSameBySpecifyingKeysMultipleFilePathsUsingDefault {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];
    NSString *pathTwo = [bundle pathForResource:@"spaces" ofType:@"png"];

    id <TMRequestBody> requestBody = [TMMultipartRequestBodyFactory defaultMultipartRequestBodyForParameters:nil filePathArray:@[path, pathTwo] contentTypeArray:@[@"image/png", @"image/png"] fileNameArray:@[@"code.png", @"spaces.png"] type:@"image"];

    NSData *data = [requestBody bodyData];

    NSString *pathToKnownMultipartData = [bundle pathForResource:@"multiple_files" ofType:@""];

    NSData *knownMultipartData = [NSData dataWithContentsOfFile:pathToKnownMultipartData];

    XCTAssert([knownMultipartData isEqual:data]);
}

- (void)testMultipartDataIsTheSameWithKeysThatAreDifferentlyWithMultipleFilePaths {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];
    NSString *pathTwo = [bundle pathForResource:@"spaces" ofType:@"png"];

    id <TMRequestBody> requestBody = [TMMultipartRequestBodyFactory multipartRequestBodyForParameters:nil filePathArray:@[path, pathTwo] contentTypeArray:@[@"image/png", @"image/png"] fileNameArray:@[@"code.png", @"spaces.png"] type:@"image" keys:@[@"data", @"other_data"]];

    NSData *data = [requestBody bodyData];

    NSString *pathToKnownMultipartData = [bundle pathForResource:@"multiple_files_different_key" ofType:@""];

    NSData *knownMultipartData = [NSData dataWithContentsOfFile:pathToKnownMultipartData];

    XCTAssert([knownMultipartData isEqual:data]);
}

- (void)testMultipartDataIsTheSameWithKeysThatAreDifferentlyWithMultipleFilePathsWithThreeImages {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];
    NSString *pathTwo = [bundle pathForResource:@"spaces" ofType:@"png"];
    NSString *pathThree = [bundle pathForResource:@"diff" ofType:@"png"];

    id <TMRequestBody> requestBody = [TMMultipartRequestBodyFactory multipartRequestBodyForParameters:nil filePathArray:@[path, pathTwo, pathThree] contentTypeArray:@[@"image/png", @"image/png", @"image/png"] fileNameArray:@[@"code.png", @"spaces.png", @"diff.png"] type:@"image" keys:@[@"data", @"other_data", @"other-other_data"]];

    NSData *data = [requestBody bodyData];

    NSString *pathToKnownMultipartData = [bundle pathForResource:@"multiple_files_three" ofType:@""];

    NSData *knownMultipartData = [NSData dataWithContentsOfFile:pathToKnownMultipartData];

   XCTAssert([knownMultipartData isEqual:data]);
}

- (void)testMultipartDataIsTheSameUsingDefault {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];

    id <TMRequestBody> requestBody = [TMMultipartRequestBodyFactory defaultMultipartRequestBodyForParameters:nil filePathArray:@[path] contentTypeArray:@[@"image/png"] fileNameArray:@[@"code.png"] type:@"image"];

    NSData *data = [requestBody bodyData];

    NSString *pathToKnownMultipartData = [bundle pathForResource:@"data" ofType:@""];

    NSData *knownMultipartData = [NSData dataWithContentsOfFile:pathToKnownMultipartData];

    XCTAssert([knownMultipartData isEqual:data]);
}

- (void)testMultipartContentTypeIsCorrect {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];

    id <TMRequestBody> requestBody = [TMMultipartRequestBodyFactory multipartRequestBodyForParameters:nil filePathArray:@[path] contentTypeArray:@[@"image/png"] fileNameArray:@[@"code.png"] type:@"image" keys:@[@"data"]];

    XCTAssert([requestBody.contentType isEqualToString:@"multipart/form-data; charset=utf-8; boundary=TumblrBoundary"]);
}

- (void)testKeyGeneration {
    NSArray *array = [TMMultipartRequestBodyFactory keyArrayOfLength:2 key:@"data"];

    const BOOL arrayIsCorrect = [array isEqual:@[@"data", @"data"]];

    XCTAssert(arrayIsCorrect);
}

- (void)testMultipartJSONBody {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *pathToJSONDictionary = [bundle pathForResource:@"json_dictionary" ofType:@"json"];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:pathToJSONDictionary] options:0 error:NULL];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];
    id <TMRequestBody> requestBody = [[TMMultipartRequestBody alloc] initWithFilePaths:@[path] contentTypes:@[@"image/png"] fileNames:@[@"code.png"] parameters:dictionary keys:@[@"data"] encodeJSONBody:YES];

    NSData *data = [requestBody bodyData];
    NSString *pathToKnownMultipartJSONData = [bundle pathForResource:@"json_data" ofType:@""];
    NSData *knownMultipartJSONData = [NSData dataWithContentsOfFile:pathToKnownMultipartJSONData];

    XCTAssert([knownMultipartJSONData isEqual:data]);
}

- (void)testMultipartDataEncodeToFile {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *pathToJSONDictionary = [bundle pathForResource:@"json_dictionary" ofType:@"json"];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:pathToJSONDictionary] options:0 error:NULL];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];

    TMMultipartRequestBody *requestBody = [[TMMultipartRequestBody alloc] initWithFilePaths:@[path] contentTypes:@[@"image/png"] fileNames:@[@"code.png"] parameters:dictionary keys:@[@"data"] encodeJSONBody:YES];

    NSError *error;
    NSURL *encodedFile = [requestBody encodeIntoFileWithError:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(encodedFile);
    
    NSString *pathToKnownMultipartJSONData = [bundle pathForResource:@"json_data" ofType:@""];
    NSData *knownMultipartJSONData = [NSData dataWithContentsOfFile:pathToKnownMultipartJSONData];

    NSData *dataContent = [NSData dataWithContentsOfURL:encodedFile];
    XCTAssert([knownMultipartJSONData isEqual:dataContent]);
}

- (void)testMultipartDataEncodeWithLowFileEndodingThreshold {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    TMMultipartRequestBody *requestBody = [self createRequestBodyWithThreshold:1024]; //So anything above 1KB encoded into file
    
    NSError *error;
    TMMultipartEncodedForm *encodedForm = [requestBody encodeWithError:&error];
    XCTAssertNil(error);
    XCTAssertNil(encodedForm.data);
    XCTAssertNotNil(encodedForm.fileURL);
    
    NSString *pathToKnownMultipartJSONData = [bundle pathForResource:@"json_data" ofType:@""];
    NSData *knownMultipartJSONData = [NSData dataWithContentsOfFile:pathToKnownMultipartJSONData];
    NSData *dataContent = [NSData dataWithContentsOfURL:encodedForm.fileURL];

    XCTAssert([knownMultipartJSONData isEqual:dataContent]);
}

- (void)testMultipartDataEncodeWithHighFileEndodingThreshold {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    TMMultipartRequestBody *requestBody = [self createRequestBodyWithThreshold:TMMultipartFormFileEncodingThreshold]; //10MB threshold
    
    NSError *error;
    TMMultipartEncodedForm *encodedForm = [requestBody encodeWithError:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(encodedForm.data);
    XCTAssertNotNil(encodedForm.fileURL);

    NSString *pathToKnownMultipartJSONData = [bundle pathForResource:@"json_data" ofType:@""];
    NSData *knownMultipartJSONData = [NSData dataWithContentsOfFile:pathToKnownMultipartJSONData];

    XCTAssert([knownMultipartJSONData isEqual:encodedForm.data]);
}

- (TMMultipartRequestBody *)createRequestBodyWithThreshold:(UInt64)fileEncodingThreshold {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *pathToJSONDictionary = [bundle pathForResource:@"json_dictionary" ofType:@"json"];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:pathToJSONDictionary] options:0 error:NULL];

    NSString *path = [bundle pathForResource:@"code" ofType:@"png"];

    TMMultipartRequestBody *requestBody = [[TMMultipartRequestBody alloc] initWithFilePaths:@[path] contentTypes:@[@"image/png"] fileNames:@[@"code.png"] parameters:dictionary keys:@[@"data"] encodeJSONBody:YES fileEncodingThreshold:fileEncodingThreshold];
    return requestBody;
}

@end
