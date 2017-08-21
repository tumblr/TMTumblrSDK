//
//  TMAPIClientCallbackConverterTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/17/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
@import TMTumblrSDK;

@interface TMAPIClientCallbackConverterTests : XCTestCase

@end

@implementation TMAPIClientCallbackConverterTests

- (void)testJSONIsCorrectAfterConvertingAndParsingResponse {

    NSDictionary *dictionary = @{@"response" : @{@"bye" : @"hi"}};

    XCTestExpectation *expectation = [self expectationWithDescription:@"JSON should be good"];

    TMAPIClientCallbackConverter *converter = [[TMAPIClientCallbackConverter alloc] initWithCallback:^(NSDictionary * _Nullable response, NSError * _Nullable error) {

        XCTAssert([response isEqual:dictionary[@"response"]]);

        [expectation fulfill];
    }];

    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];

    [converter completionHandler](data, [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:@"https://tumblr.com"] statusCode:200 HTTPVersion:@"1.1" headerFields:nil], nil);

    [self waitForExpectationsWithTimeout:1000 handler:^(NSError * _Nullable error) {

    }];
}

@end
