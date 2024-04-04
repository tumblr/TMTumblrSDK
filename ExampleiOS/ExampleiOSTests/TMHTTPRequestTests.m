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
    if (@available(iOS 17.0, *)) {
        /**
         https://developer.apple.com/documentation/foundation/nsurl/1572047-urlwithstring

         For apps linked on or after iOS 17 and aligned OS versions, NSURL parsing has updated from the obsolete RFC 1738/1808 parsing to the same RFC 3986 parsing as NSURLComponents. This unifies the parsing behaviors of the NSURL and NSURLComponents APIs. Now, NSURL automatically percent- and IDNA-encodes invalid characters to help create a valid URL.
         */
        return;
    }
    TMHTTPRequest *request = [[TMHTTPRequest alloc] initWithURLString:@" " method:TMHTTPRequestMethodGET];

    XCTAssertThrows(request.URL);
}

@end
