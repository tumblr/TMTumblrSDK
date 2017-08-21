//
//  NSMutableURLRequest+TMTumblrSDKAdditionsTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/10/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/NSMutableURLRequest+TMTumblrSDKAdditions.h>

@interface NSMutableURLRequest_TMTumblrSDKAdditionsTests : XCTestCase

@end

@implementation NSMutableURLRequest_TMTumblrSDKAdditionsTests

- (void)testAdditionalHeadersAreAdded {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"tumblr.com"]];

    [request addAdditionalHeaders:@{@"Oli" : @"Kenny"}];

    XCTAssert([request.allHTTPHeaderFields[@"Oli"] isEqualToString:@"Kenny"]);
}

@end
