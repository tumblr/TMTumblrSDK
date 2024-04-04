//
//  TMSDKUserAgentTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/10/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMSDKUserAgent.h"

@interface TMSDKUserAgentTests : XCTestCase

@end

@implementation TMSDKUserAgentTests

- (void)testSDKUserAgentStringContainsTMTumblrSDK {

    XCTAssert([[TMSDKUserAgent userAgentHeaderString] containsString:@"TMTumblrSDK"]);
}

@end
