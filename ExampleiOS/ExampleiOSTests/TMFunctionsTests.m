//
//  TMFunctionsTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/11/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMFunctions.h>

@interface TMFunctionsTests : XCTestCase

@end

@implementation TMFunctionsTests

- (void)testOneQueryParameterReturnsRightPath {

    NSString *path = pathFromPathWithQueryParameters(@"/topics?hello=hello", @"/topics");

    XCTAssertEqualObjects(path, @"/topics");
}

- (void)testWrongDefaultPathAndOneQueryParametersOnAURLStringReturnsCorrectFirstPart{

    NSString *path = pathFromPathWithQueryParameters(@"/topics?hello=hello", @"/no");

    XCTAssertEqualObjects(path, @"/topics");
}

- (void)testQueryParametersFromPath {
    NSDictionary *queryDictionary = queryParametersFromPath(@"https://api.tumblr.com/v2/user/info?hello=kenny");

    XCTAssert([queryDictionary isEqual:@{@"hello" : @"kenny"}]);
}

@end
