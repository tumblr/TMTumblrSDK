//
//  NSURL+TumblrTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/10/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSURLRequest+TMTumblrSDK.h"

@interface NSURL_TumblrTests : XCTestCase

@end

@implementation NSURL_TumblrTests

- (void)testMethodSettingIsCorrectToPOST {
    NSURLRequest *request = [NSURLRequest URLRequestWithURL:[[NSURL alloc] initWithString:@"http://google.com"] method:TMHTTPRequestMethodPOST additionalHeaders:nil];
    XCTAssert([request.HTTPMethod isEqualToString:@"POST"]);
}

- (void)testMethodSettingIsCorrectToGET {
    NSURLRequest *request = [NSURLRequest URLRequestWithURL:[[NSURL alloc] initWithString:@"http://google.com"] method:TMHTTPRequestMethodGET additionalHeaders:nil];
    XCTAssert([request.HTTPMethod isEqualToString:@"GET"]);
}

- (void)testMethodSettingIsCorrectToDELETE {
    NSURLRequest *request = [NSURLRequest URLRequestWithURL:[[NSURL alloc] initWithString:@"http://google.com"] method:TMHTTPRequestMethodDELETE additionalHeaders:nil];
    XCTAssert([request.HTTPMethod isEqualToString:@"DELETE"]);
}

- (void)testAdditionalHeadersWork {
    NSURLRequest *request = [NSURLRequest URLRequestWithURL:[[NSURL alloc] initWithString:@"http://google.com"] method:TMHTTPRequestMethodDELETE additionalHeaders:@{@"ELLO" : @"It's Oli"}];
    XCTAssert(request.allHTTPHeaderFields[@"ELLO"], @"ELLO must be included in the request's HTTP header fields.");
}

- (void)testAnAdditionalHeaderIsNotAddedForNilAdditionalHeaders {
    NSURLRequest *request = [NSURLRequest URLRequestWithURL:[[NSURL alloc] initWithString:@"http://google.com"] method:TMHTTPRequestMethodDELETE additionalHeaders:nil];
    XCTAssert(request.allHTTPHeaderFields.count == 0);
}

@end
