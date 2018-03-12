//
//  TMAuthenticationResponseProcessorTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/14/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMAuthenticationResponseProcessor.h>
#import <TMTumblrSDK/TMAPIUserCredentials.h>

@interface TMAuthenticationResponseProcessorTests : XCTestCase

@end

@implementation TMAuthenticationResponseProcessorTests

- (void)testTokensAreCorrectlyParsed {

    XCTestExpectation *expectation = [self expectationWithDescription:@"callback is called"];

    TMAuthenticationResponseProcessor *response = [[TMAuthenticationResponseProcessor alloc] initWithCallback:^(TMAPIUserCredentials * _Nullable creds, NSError * _Nullable error) {

        XCTAssert([creds.token isEqualToString:@"hello"]);
        XCTAssert([creds.tokenSecret isEqualToString:@"hi"]);

        [expectation fulfill];
    }];

    [response sessionCompletionBlock]([@"oauth_token_secret=hi&oauth_token=hello" dataUsingEncoding:NSUTF8StringEncoding], [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] init] statusCode:200 HTTPVersion:@"1.1" headerFields:nil], nil);

    [self waitForExpectationsWithTimeout:DISPATCH_TIME_FOREVER handler:nil];
}

- (void)testTokensAreWrongType {

    XCTestExpectation *expectation = [self expectationWithDescription:@"callback is called"];

    TMAuthenticationResponseProcessor *response = [[TMAuthenticationResponseProcessor alloc] initWithCallback:^(TMAPIUserCredentials * _Nullable creds, NSError * _Nullable error) {

        XCTAssert(error);
        XCTAssert(error.code == 3400);

        [expectation fulfill];
    }];

    [response sessionCompletionBlock]([@"oauth_token_secret=2&oauth_token_secret=2&oauth_token=3&oauth_token=3" dataUsingEncoding:NSUTF8StringEncoding], [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] init] statusCode:200 HTTPVersion:@"1.1" headerFields:nil], nil);

    [self waitForExpectationsWithTimeout:DISPATCH_TIME_FOREVER handler:nil];
}

- (void)testErrorStatusCodeCallsCallbackFunction {

    XCTestExpectation *expectation = [self expectationWithDescription:@"callback is called"];

    TMAuthenticationResponseProcessor *response = [[TMAuthenticationResponseProcessor alloc] initWithCallback:^(TMAPIUserCredentials * _Nullable creds, NSError * _Nullable error) {

        XCTAssert(error.code == 400);
        XCTAssert(error);

        [expectation fulfill];
    }];

    [response sessionCompletionBlock]([@"oauth_token_secret=hi&oauth_token=hello" dataUsingEncoding:NSUTF8StringEncoding], [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] init] statusCode:400 HTTPVersion:@"1.1" headerFields:nil], nil);

    [self waitForExpectationsWithTimeout:DISPATCH_TIME_FOREVER handler:nil];
}

- (void)testErrorCallsCallbackFunction {

    XCTestExpectation *expectation = [self expectationWithDescription:@"callback is called"];
    NSError *baseError = [[NSError alloc] initWithDomain:@"" code:22321 userInfo:nil];
    TMAuthenticationResponseProcessor *response = [[TMAuthenticationResponseProcessor alloc] initWithCallback:^(TMAPIUserCredentials * _Nullable creds, NSError * _Nullable error) {

        XCTAssert([error isEqual:baseError]);

        [expectation fulfill];
    }];

    [response sessionCompletionBlock]([@"oauth_token_secret=hi&oauth_token=hello" dataUsingEncoding:NSUTF8StringEncoding], [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] init] statusCode:400 HTTPVersion:@"1.1" headerFields:nil], baseError);

    [self waitForExpectationsWithTimeout:DISPATCH_TIME_FOREVER handler:nil];
}

- (void)testFailedRequestCallsCallbackFunctionWithFullJSONPayload {

    XCTestExpectation *expectation = [self expectationWithDescription:@"callback is called"];
    NSDictionary *responseFields = @{@"errors": @[@{@"key_1": @(YES), @"key_2": @(NO)}]};

    NSData *dataFromDict = [NSJSONSerialization dataWithJSONObject:responseFields
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];

    TMAuthenticationResponseProcessor *response = [[TMAuthenticationResponseProcessor alloc] initWithCallback:^(TMAPIUserCredentials * _Nullable creds, NSError * _Nullable error) {

        XCTAssert([error.userInfo isEqual:responseFields]);

        [expectation fulfill];
    }];

    [response sessionCompletionBlock](dataFromDict, [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] init] statusCode:400 HTTPVersion:@"1.1" headerFields:nil], nil);

    [self waitForExpectationsWithTimeout:DISPATCH_TIME_FOREVER handler:nil];
}

@end
