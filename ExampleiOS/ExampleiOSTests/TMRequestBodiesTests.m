//
//  TMRequestBodiesTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/10/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMQueryEncodedRequestBody.h>
#import <TMTumblrSDK/TMFormEncodedRequestBody.h>
#import <TMTumblrSDK/TMJSONEncodedRequestBody.h>

@interface TMRequestBodiesTests : XCTestCase

@end

@implementation TMRequestBodiesTests

- (void)testQueryParametersAreTheSame {
    TMQueryEncodedRequestBody *queryBody = [[TMQueryEncodedRequestBody alloc] initWithQueryDictionary:@{@"paul" : @"kenny", @"pool" : @"object"}];

    const BOOL passes = [queryBody.parameters isEqual:@{@"paul" : @"kenny", @"pool" : @"object"}];

    XCTAssert(passes);
}

- (void)testQueryContentTypeIsRightForQuery {
    TMQueryEncodedRequestBody *queryBody = [[TMQueryEncodedRequestBody alloc] initWithQueryDictionary:@{@"paul" : @"kenny", @"pool" : @"object"}];

    XCTAssert(queryBody.contentType == nil);
}

- (void)testQueryContentTypeIsRightForForm {
    TMFormEncodedRequestBody *body = [[TMFormEncodedRequestBody alloc] initWithBody:@{@"4" : @3}];

    XCTAssert([body.contentType isEqualToString:@"application/x-www-form-urlencoded; charset=utf-8"]);
}

- (void)testQueryContentTypeIsRightForJSON {
    TMJSONEncodedRequestBody *body = [[TMJSONEncodedRequestBody alloc] initWithJSONDictionary:@{@"4" : @3}];

    XCTAssert([body.contentType isEqualToString:@"application/json"]);
}

- (void)testContentTypeIsNil {
    NSString *contentType = [[[TMQueryEncodedRequestBody alloc] initWithQueryDictionary:@{@"paul" : @"kenny", @"pool" : @"object"}] contentType];
    XCTAssertNil(contentType);
}

- (void)testDataExists {
    NSData *data = [[[TMQueryEncodedRequestBody alloc] initWithQueryDictionary:@{@"paul" : @"kenny", @"pool" : @"object"}] bodyData];

    XCTAssert(data);
}

- (void)testFormEncodedRequestBodysParamtersAreCorrect {
    TMFormEncodedRequestBody *body = [[TMFormEncodedRequestBody alloc] initWithBody:@{@"4" : @3}];
    XCTAssert([[body parameters] isEqual:@{@"4" : @3}]);
}

- (void)testJSONEncodedRequestBodysParamtersAreCorrect {
    TMJSONEncodedRequestBody *body = [[TMJSONEncodedRequestBody alloc] initWithJSONDictionary:@{@"4" : @3}];
    XCTAssert([[body parameters] isEqual:@{@"4" : @3}]);
}

@end
