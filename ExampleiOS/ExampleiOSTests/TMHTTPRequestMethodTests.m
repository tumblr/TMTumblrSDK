//
//  TMHTTPRequestMethodTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/13/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
@import TMTumblrSDK;

@interface TMHTTPRequestMethodTests : XCTestCase

@end

@implementation TMHTTPRequestMethodTests

- (void)testRequestMethodFromStringGET {

    TMHTTPRequestMethod method = [TMRequestMethodHelpers methodFromString:@"GET"];
    XCTAssertEqual(method, TMHTTPRequestMethodGET);

}

- (void)testRequestMethodFromStringPOST {

    TMHTTPRequestMethod method = [TMRequestMethodHelpers methodFromString:@"POST"];
    XCTAssertEqual(method, TMHTTPRequestMethodPOST);
    
}

- (void)testRequestMethodFromStringDELETE {

    TMHTTPRequestMethod method = [TMRequestMethodHelpers methodFromString:@"DELETE"];
    XCTAssertEqual(method, TMHTTPRequestMethodDELETE);
    
}

- (void)testRequestMethodFromStringPATCH {

    TMHTTPRequestMethod method = [TMRequestMethodHelpers methodFromString:@"PATCH"];
    XCTAssertEqual(method, TMHTTPRequestMethodPATCH);

}

- (void)testRequestMethodFromStringUnkownIsGET {

    TMHTTPRequestMethod method = [TMRequestMethodHelpers methodFromString:@"adfishapd"];
    XCTAssertEqual(method, TMHTTPRequestMethodGET);

}

@end
