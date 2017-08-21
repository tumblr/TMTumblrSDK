//
//  TMLegacyAPIErrorTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 7/19/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
@import TMTumblrSDK;

@interface TMLegacyAPIErrorTests : XCTestCase

@end

@implementation TMLegacyAPIErrorTests

- (void)testLogoutIsAlwaysNo {

    TMLegacyAPIError *error = [[TMLegacyAPIError alloc] initWithTitle:@"Some Title" detail:@"detail"];

    XCTAssert(![error logout]);
}

@end
