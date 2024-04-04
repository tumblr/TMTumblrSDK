//
//  TMAuthTokenRequestGeneratorTests.m
//  ExampleiOS
//
//  Created by Tyler Tape on 5/4/17.
//  Copyright © 2017 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMAuthTokenRequestGenerator.h"
#import "TMHTTPRequest.h"

@interface TMAuthTokenRequestGeneratorTests : XCTestCase

@end

@implementation TMAuthTokenRequestGeneratorTests

- (void)testGeneratingAnAuthTokenRequest {
    TMAuthTokenRequestGenerator *generator = [[TMAuthTokenRequestGenerator alloc] initWithURLScheme:@"grund"];
    TMHTTPRequest *request = [generator authTokenRequest];
    XCTAssertTrue(request.isSigned, @"The auth token request should be signed");
    XCTAssertFalse(request.isUpload, @"The auth token request is not an upload request");
    XCTAssertEqualObjects(request.URL.absoluteString,
                          @"https://www.tumblr.com/oauth/request_token?oauth_callback=grund%3A%2F%2Ftumblr-authorize",
                          @"The auth token request URL was formatted incorrectly");
}

@end
