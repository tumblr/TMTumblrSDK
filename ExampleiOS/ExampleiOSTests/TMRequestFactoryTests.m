//
//  TMRequestFactoryTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/16/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
@import TMTumblrSDK;

@interface TMRequestFactoryTests : XCTestCase

@end

@implementation TMRequestFactoryTests

- (void)testPOSTRequestMethodIsAPOSTRequest {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    id <TMRequest> request = [requestFactory POSTRequestWithPath:@"/" JSONParameters:@{}];

    XCTAssert(request.method == TMHTTPRequestMethodPOST);
}

@end
