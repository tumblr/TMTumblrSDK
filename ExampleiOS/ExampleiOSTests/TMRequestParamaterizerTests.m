//
//  TMRequestParamaterizerTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 5/2/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMRequestParamaterizer.h>
#import <TMTumblrSDK/TMHTTPRequest.h>
#import <TMTumblrSDK/TMHTTPRequestMethod.h>
#import <TMTumblrSDK/TMJSONEncodedRequestBody.h>
#import <TMTumblrSDK/TMFormEncodedRequestBody.h>
#import <TMTumblrSDK/TMAPIUserCredentials.h>
#import <TMTumblrSDK/TMAPIApplicationCredentials.h>
#import <TMTumblrSDK/TMSDKFunctions.h>


@interface TMRequestParamaterizerTests : XCTestCase

@end

@implementation TMRequestParamaterizerTests


- (void)testGetMethod {
    XCTAssert([[self basicRequestWithMethod:TMHTTPRequestMethodGET].HTTPMethod isEqualToString:@"GET"]);
}

- (void)testPostMethod {
    XCTAssert([[self basicRequestWithMethod:TMHTTPRequestMethodPOST].HTTPMethod isEqualToString:@"POST"]);
}

- (void)testDeleteMethod {
    XCTAssert([[self basicRequestWithMethod:TMHTTPRequestMethodDELETE].HTTPMethod isEqualToString:@"DELETE"]);
}

- (void)testPatchMethod {
    XCTAssert([[self basicRequestWithMethod:TMHTTPRequestMethodPATCH].HTTPMethod isEqualToString:@"PATCH"]);
}

- (void)testHTTPBodyExistsJSONBody {
    NSURLRequest *paramedRequest = [self basicHTTPBodyRequestWithBody:[[TMJSONEncodedRequestBody alloc] initWithJSONDictionary:@{@"key" : @"value"}]];

    XCTAssert(paramedRequest.HTTPBody);
}

- (void)testHTTPBodyExistsFormEncodedBody {
    NSURLRequest *paramedRequest = [self basicHTTPBodyRequestWithBody:[[TMFormEncodedRequestBody alloc] initWithBody:@{@"key" : @"value"}]];

    XCTAssert(paramedRequest.HTTPBody);
}

- (void)testNoneRequestBodyRequestHasNoBody {
    XCTAssert(![self basicRequestWithMethod:TMHTTPRequestMethodGET].HTTPBody);
}

- (void)testHTTPBodyDataIsSet {
    TMHTTPRequest *request = [[TMHTTPRequest alloc] initWithURLString:@"http://tumblr.com"
                                                               method:TMHTTPRequestMethodPOST
                                                    additionalHeaders:nil
                                                          requestBody:[[TMFormEncodedRequestBody alloc] initWithBody:@{@"key" : @"value"}]
                                                             isSigned:NO
                                                             isUpload:NO];
    TMRequestParamaterizer *paramaterizer = [[TMRequestParamaterizer alloc] initWithApplicationCredentials:nil userCredentials:nil request:request additionalHeaders:@{}];


    XCTAssert([paramaterizer URLRequestWithRequest:request].HTTPBody);
}

- (void)testAdditionalHeadersWork {
    TMHTTPRequest *request = [[TMHTTPRequest alloc] initWithURLString:@"http://tumblr.com"
                                                               method:TMHTTPRequestMethodPOST
                                                    additionalHeaders:nil
                                                          requestBody:[[TMFormEncodedRequestBody alloc] initWithBody:@{@"key" : @"value"}]
                                                             isSigned:NO
                                                             isUpload:NO];
    TMRequestParamaterizer *paramaterizer = [[TMRequestParamaterizer alloc] initWithApplicationCredentials:nil userCredentials:nil request:request additionalHeaders:@{@"kenny-header" : @"hello"}];


    XCTAssert([[paramaterizer URLRequestWithRequest:request].allHTTPHeaderFields[@"kenny-header"] isEqualToString:@"hello"]);
}

-(void)testParametizerNilForGET {
    TMHTTPRequest *request = [[TMHTTPRequest alloc] initWithURLString:@"http://tumblr.com" method:TMHTTPRequestMethodGET];
    XCTAssertNil(postParametersForSignedRequests(request));
}

-(void)testParametizerNilForHEAD {
    TMHTTPRequest *request = [[TMHTTPRequest alloc] initWithURLString:@"http://tumblr.com" method:TMHTTPRequestMethodHEAD];
    XCTAssertNil(postParametersForSignedRequests(request));
}

-(void)testParametizerNilForPUT {
    TMHTTPRequest *request = [[TMHTTPRequest alloc] initWithURLString:@"http://tumblr.com" method:TMHTTPRequestMethodPUT];
    XCTAssertNil(postParametersForSignedRequests(request));
}



- (void)testHTTPBodyDataIsNotSet {
    TMHTTPRequest *request = [[TMHTTPRequest alloc] initWithURLString:@"http://tumblr.com"
                                                               method:TMHTTPRequestMethodPOST
                                                    additionalHeaders:nil
                                                          requestBody:[[TMFormEncodedRequestBody alloc] initWithBody:@{@"key" : @"value"}]
                                                             isSigned:NO
                                                             isUpload:YES];
    TMRequestParamaterizer *paramaterizer = [[TMRequestParamaterizer alloc] initWithApplicationCredentials:nil userCredentials:nil request:request additionalHeaders:@{}];


    XCTAssertNil([paramaterizer URLRequestWithRequest:request].HTTPBody);
}


#pragma mark - Helpers

- (NSURLRequest *)basicHTTPBodyRequestWithBody:(id <TMRequestBody>)body {
    TMHTTPRequest *request = [[TMHTTPRequest alloc] initWithURLString:@"http://tumblr.com"
                                                               method:TMHTTPRequestMethodPOST
                                                    additionalHeaders:nil
                                                          requestBody:body
                                                             isSigned:NO
                                                             isUpload:NO];

    TMRequestParamaterizer *paramaterizer = [[TMRequestParamaterizer alloc] initWithApplicationCredentials:nil userCredentials:nil request:request additionalHeaders:@{}];

    return [paramaterizer URLRequestWithRequest:request];
}

- (NSURLRequest *)basicRequestWithMethod:(TMHTTPRequestMethod)method {
    TMHTTPRequest *request = [[TMHTTPRequest alloc] initWithURLString:@"http://tumblr.com" method:method];

    TMRequestParamaterizer *paramaterizer = [[TMRequestParamaterizer alloc] initWithApplicationCredentials:nil userCredentials:nil request:request additionalHeaders:@{}];

    return [paramaterizer URLRequestWithRequest:request];
}


@end
