//
//  TMBasicBaseURLDeterminerTests.m
//  ExampleiOS
//
//  Created by Tyler Tape on 6/1/17.
//  Copyright © 2017 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMBasicBaseURLDeterminer.h>

@interface TMBasicBaseURLDeterminerTests : XCTestCase

@end

@implementation TMBasicBaseURLDeterminerTests

- (void)testDeterminerReturnsExpectedURL {
    XCTAssertEqualObjects([[[TMBasicBaseURLDeterminer alloc] init] baseURL].absoluteString, @"https://api.tumblr.com/v2/");
}

@end
