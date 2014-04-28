//
//  TMAPIClientUnitTest.h
//  TumblrSDK
//
//  Created by John Crepezzi on 3/19/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <OCMock/OCMockObject.h>
#import <OCMock/OCMArg.h>
#import <XCTest/XCTest.h>
#import "TMAPIClient.h"

@interface TMAPIClientUnitTest : XCTestCase

@property(nonatomic, retain) TMAPIClient *client;

// Set up the Test with a TMAPIClient
- (void) setUp;

// Assert that with a given callback being fired, we can verify the response is
// of a certain form
- (void) assertCallback:(void(^)(id, TMAPICallback))action andVerify:(JXHTTPOperation*)op;

// Verify that two requests are the same
- (void) assertSimilarRequest:(JXHTTPOperation*)op1 to:(JXHTTPOperation*)op2;

// Verify that the multipart body of a request is a certain NSString
- (void) assertMultipartBody:(JXHTTPOperation*)op is:(NSString*)expected;

// Verify that the body of a request is a certain NSString
- (void) assertBody:(JXHTTPOperation*)op is:(NSDictionary*)expected;

// Verify that the query of a request is a certain NSString
- (void) assertQuery:(JXHTTPOperation*)op is:(NSString*)expected;

// Verify that the part of a request is a certain NSString
- (void) assertPath:(JXHTTPOperation*)op is:(NSString*)expected;

// Verify that the request method of a request is a certain NSString
- (void) assertMethod:(JXHTTPOperation*)op is:(NSString*)expected;

@end
