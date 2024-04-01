//
//  TMHTTPRequestTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/13/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMHTTPRequest.h"

@interface TMHTTPRequestTests : XCTestCase

@end

@implementation TMHTTPRequestTests

- (void)testCopyingAndAddingQueryParametersDoesNotWork {
    // We actually dont support query parameters on TMHTTPRequest yet, so we want to test that we dont add any query parameters

    TMHTTPRequest *request = [[TMHTTPRequest alloc] initWithURLString:@"tumblr.com" method:TMHTTPRequestMethodGET];

    XCTAssert([request isEqual:[request requestByAddingQueryParameters:@{@"idk" : @"ok"}]]);
}

- (void)testExceptionIsThrownWithBadURLString {
    TMHTTPRequest *request = [[TMHTTPRequest alloc] initWithURLString:@" " method:TMHTTPRequestMethodGET];

    XCTAssertThrows(request.URL);
}

@end
