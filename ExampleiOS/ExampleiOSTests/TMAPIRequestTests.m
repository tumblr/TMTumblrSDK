//
//  TMAPIRequestTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/11/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMAPIRequest.h>

@interface TMAPIRequestTests : XCTestCase

@end

@implementation TMAPIRequestTests

- (void)testAddingAdditionalQueryParametersWorks {

    id <TMRequest> request = [[TMAPIRequest alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.tumblr.com/v2/"]
                                                           method:TMHTTPRequestMethodGET
                                                             path:@"user/info"
                                                  queryParameters:nil
                                                      requestBody:nil
                                                 additionalHeaders:nil
                                                         isUpload:YES];

    XCTAssertNil(request.queryParameters);

    request = [request requestByAddingQueryParameters:@{@"paul" : @"chains"}];

    XCTAssert([request.queryParameters[@"paul"] isEqual:@"chains"]);

}

- (void)testBadPath {
    XCTAssertThrows([[TMAPIRequest alloc] initWithBaseURL:[NSURL URLWithString:@""]
                                                   method:TMHTTPRequestMethodGET
                                                     path:@"/?/&/C://hello"
                                          queryParameters:nil
                                              requestBody:nil
                                        additionalHeaders:nil
                                                 isUpload:YES]);
}

- (void)testAdditionalHeaders {

    id <TMRequest> request = [[TMAPIRequest alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.tumblr.com/v2/"]
                                                            method:TMHTTPRequestMethodGET
                                                              path:@"user/info"
                                                   queryParameters:nil
                                                       requestBody:nil
                                                 additionalHeaders:nil
                                                          isUpload:YES];

    XCTAssertNil(request.additionalHeaders);

    request = [request requestByAddingAdditionalHeaders:@{@"paul" : @"chains"}];

    XCTAssert([request.additionalHeaders[@"paul"] isEqual:@"chains"]);

}

@end
