//
//  TMURLEncodingTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/14/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMURLEncoding.h"

@interface TMURLEncodingTests : XCTestCase

@end

@implementation TMURLEncodingTests

- (void)testFormEncodingReplacesPercentTwentyFromSpaceWithPlus {
    XCTAssert([[TMURLEncoding formEncodedString:@" "] isEqualToString:@"+"]);
}

- (void)testEncodingBlankStringReturnsAnother {
    XCTAssert([[TMURLEncoding formEncodedString:@""] isEqualToString:@""]);
}

- (void)testFormDictionary {
    NSString *string = [TMURLEncoding formEncodedDictionary:@{@"hello" : @{@"hello" : @"kenny"}}];

    XCTAssertEqualObjects(@"hello[hello]=kenny", string);
}

- (void)testFormDictionaryEmptyKey {
    NSString *string = [TMURLEncoding formEncodedDictionary:@{@"hello" : @{@"" : @"kenny"}}];

    XCTAssertEqualObjects(@"hello[]=kenny", string);
}

- (void)testFormDictionaryEmptyAllKeys {
    NSString *string = [TMURLEncoding formEncodedDictionary:@{@"" : @{@"" : @"kenny"}}];

    XCTAssertEqualObjects(@"", string);
}

- (void)testFormDictionaryWithArray {
    NSString *string = [TMURLEncoding formEncodedDictionary:@{@"hello" : @[@3, @"da"]}];

    XCTAssertEqualObjects(@"hello%5B0%5D=3&hello%5B1%5D=da", string);
}

- (void)testEncodingEmptyDictionary {
    XCTAssertEqualObjects(@"", [TMURLEncoding encodedDictionary:@{}]);
}

- (void)testLongFormDictionary {
    NSString *string = [TMURLEncoding formEncodedDictionary:@{@"hello" : @{@"hello" : @"kenny", @"o1" : @{@"hello" : @"kenny"}, @"o2" : @{@"hello" : @"kenny"}, @"o3" : @{@"hello" : @"kenny"}}}];

    XCTAssertEqualObjects(@"hello[hello]=kenny&hello%5Bo1%5D[hello]=kenny&hello%5Bo2%5D[hello]=kenny&hello%5Bo3%5D[hello]=kenny", string);
}

@end
