//
//  TMAPIRequestTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/11/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMAPIRequest.h"

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
    if (@available(iOS 17.0, *)) {
        /**
         https://developer.apple.com/documentation/foundation/nsurl/1572047-urlwithstring

         For apps linked on or after iOS 17 and aligned OS versions, NSURL parsing has updated from the obsolete RFC 1738/1808 parsing to the same RFC 3986 parsing as NSURLComponents. This unifies the parsing behaviors of the NSURL and NSURLComponents APIs. Now, NSURL automatically percent- and IDNA-encodes invalid characters to help create a valid URL.
         */
        return;
    }
    XCTAssertThrows([[TMAPIRequest alloc] initWithBaseURL:[NSURL URLWithString:@""]
                                                   method:TMHTTPRequestMethodGET
                                                     path:@"/?/&/C://hello%"
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
